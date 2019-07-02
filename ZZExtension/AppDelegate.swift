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
        self.window.makeKeyAndOrderFront(self)
        return true
    }

    // register our app to get notified when launched via URL
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
                        self,
                        andSelector: #selector(AppDelegate.handleURLEvent(_:withReply:)),
                        forEventClass: AEEventClass(kInternetEventClass),
                        andEventID: AEEventID(kAEGetURL)
                )
    }

    /** Gets called when the App launches/opens via URL. */
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
//        let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue
//        let alert = NSAlert();
//        alert.messageText = (urlString)!
//        alert.beginSheetModal(for: window) { _ in
//
//        }
    }

}

