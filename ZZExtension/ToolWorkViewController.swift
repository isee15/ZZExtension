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
        if (output is String) {
            self.outputTextView.string = output as? String
        } else if output is NSAttributedString {
            self.outputTextView.string = ""
            self.outputTextView.textStorage?.setAttributedString(output as! NSAttributedString)
        }
    }

    @IBAction func onReverseDo(_: AnyObject) {
        let input = self.operation.reverseAction(input: self.outputTextView.string!)
        self.inputTextView.string = input
    }

}
