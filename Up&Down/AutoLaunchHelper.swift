//
//  AutoLaunchHelper.swift
//  Up&Down
//
//  Created by 郭佳哲 on 5/19/16.
//  Copyright © 2016 郭佳哲. All rights reserved.
//

import Foundation
public class AutoLaunchHelper {
    static func isLaunchWhenLogin() -> Bool {
        return (loginItem() != nil)
    }
    
    static func removeFromLoginItems() {
        guard let loginItem = loginItem() else { return }
        let loginItemsFileList = LSSharedFileListCreate(nil,
                                                        kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                                        nil).takeRetainedValue() as LSSharedFileListRef?
        LSSharedFileListItemRemove(loginItemsFileList, loginItem)
        print("Application was removed from login items")
    }
    
    static func addToLoginItems() {
        let bundleURL = NSBundle.mainBundle().bundleURL
        let loginItemsFileList = LSSharedFileListCreate(nil,
                                                        kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                                        nil).takeRetainedValue() as LSSharedFileListRef?
        guard loginItemsFileList != nil else { return }
        LSSharedFileListInsertItemURL(loginItemsFileList,
                                      kLSSharedFileListItemBeforeFirst.takeRetainedValue(),
                                      nil,
                                      nil,
                                      bundleURL,
                                      nil,
                                      nil)
        print("Application was added to login items")
    }
    
    static func loginItem() -> LSSharedFileListItemRef? {
        let bundleURL = NSBundle.mainBundle().bundleURL
        let loginItemsFileList = LSSharedFileListCreate(nil,
                                                        kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                                        nil).takeRetainedValue() as LSSharedFileListRef?
        guard loginItemsFileList != nil else { return nil }
        guard let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsFileList, nil).takeRetainedValue() else { return nil }
        
        for loginItem in loginItems as! [LSSharedFileListItemRef] {
            if let itemURL = LSSharedFileListItemCopyResolvedURL(loginItem, 0, nil).takeRetainedValue() as? NSURL {
                if bundleURL.isEqual(itemURL) {
                    return loginItem
                }
            }
        }
        return nil
    }
    
    static func toggleLaunchWhenLogin() {
        if isLaunchWhenLogin() {
            removeFromLoginItems()
        } else {
            addToLoginItems()
        }
    }
}