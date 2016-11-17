//
//  AppDelegate.swift
//  ZZExtension
//
//  Created by isee15 on 16/9/20.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            return false;
        }
        else {
            self.window.makeKeyAndOrderFront(self);
            return true;
        }
    }
}

