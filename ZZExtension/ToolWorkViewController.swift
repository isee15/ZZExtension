//
//  ToolWorkViewController.swift
//  ZZExtension
//
//  Created by isee15 on 2016/11/26.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

class ToolWorkViewController: NSViewController {

    var operation: CommandOperation!
    var tabTitle: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    @IBOutlet var outputTextView: NSTextView!
    @IBOutlet var inputTextView: NSTextView!

    @IBAction func onDo(_: AnyObject) {
        let output = self.operation.doAction(input: self.inputTextView.string!)
        self.outputTextView.string = output
    }

    @IBAction func onReverseDo(_: AnyObject) {
        let input = self.operation.reverseAction(input: self.outputTextView.string!)
        self.inputTextView.string = input
    }

}
