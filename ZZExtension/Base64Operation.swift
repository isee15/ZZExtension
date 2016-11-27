//
//  Base64Operation.swift
//  ZZExtension
//
//  Created by isee15 on 2016/11/27.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

class Base64Operation: NSObject, CommandOperation {
    func doAction(input: String) -> String {
        return Data(input.utf8).base64EncodedString()
    }

    func reverseAction(input: String) -> String {
        let data = Data(base64Encoded: input)
        return String(data: data!, encoding: .utf8)!
    }

}
