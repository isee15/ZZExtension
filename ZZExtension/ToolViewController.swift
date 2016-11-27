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

        var tools: [ToolWorkViewController] = []

        var toolItem = ToolWorkViewController()
        toolItem.tabTitle = "Json"
        toolItem.operation = JsonOperation()
        tools.append(toolItem)

        toolItem = ToolWorkViewController()
        toolItem.tabTitle = "Url"
        toolItem.operation = UrlOperation()
        tools.append(toolItem)

        toolItem = ToolWorkViewController()
        toolItem.tabTitle = "Time"
        toolItem.operation = TimestampOperation()
        tools.append(toolItem)

        toolItem = ToolWorkViewController()
        toolItem.tabTitle = "Base64"
        toolItem.operation = Base64Operation()
        tools.append(toolItem)

        for toolItem in tools {
            let item = NSTabViewItem(viewController: toolItem)
            item.label = toolItem.tabTitle
            self.tab.addTabViewItem(item)
        }


    }

}
