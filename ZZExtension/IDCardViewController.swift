//
//  IDCardViewController.swift
//  ZZExtension
//
//  Created by rui on 2017/1/13.
//  Copyright © 2017年 isee15. All rights reserved.
//

import Cocoa

class IDCardViewController: NSViewController {

    @IBOutlet var outputView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func onGenerate(_ sender: Any) {
        var output = ""
        for _ in 0...10 {
            output += FakeUtil.generateID()
            output += "\n"
        }
        self.outputView.string = ""
        self.outputView.textStorage?.append(NSAttributedString(string: output))
    }
    
}
