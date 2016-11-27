//
//  CommandModel.swift
//  ZZExtension
//
//  Created by isee15 on 2016/11/26.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

class CommandModel: NSObject {

    var title: String = ""

    var doAction: ((String) -> String)?

    var reverseAction: ((String) -> String)?

    override init() {
        super.init()
    }

}
