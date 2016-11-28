//
//  ToolViewController.swift
//  ZZExtension
//
//  Created by isee15 on 2016/11/26.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

class ToolViewController: NSViewController {

    var tab: NSTabView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.tab = NSTabView()
        self.view.addSubview(self.tab)

        self.tab.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self.tab]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self.tab]))

        var commandDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "command", ofType: "plist") {
            commandDict = NSDictionary(contentsOfFile: path)
        }
        
        for dictItem in commandDict?["Operations"] as! NSArray {
            let dict = dictItem as! NSDictionary
            let toolItem = dynamicCreateInstance(className: dict["View"] as! String)
            toolItem.setValue(dict["Title"], forKey: "tabTitle")
            (toolItem as! ToolWorkViewController).operation = dynamicCreateInstance(className: dict["Command"] as! String) as? CommandOperation
            let item = NSTabViewItem(viewController: toolItem as! NSViewController)
            item.label = dict["Title"] as! String
            self.tab.addTabViewItem(item)
        }
    }
    
    func dynamicCreateInstance(className:String) -> NSObject {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! NSObject.Type
        return aClass.init()
    }

}
