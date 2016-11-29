//
//  Base64Operation.swift
//  ZZExtension
//
//  Created by isee15 on 2016/11/27.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

class Base64Operation: NSObject, CommandOperation {
    func doAction(input: String) -> AnyObject {
        return Data(input.utf8).base64EncodedString() as AnyObject
    }

    func reverseAction(input: String) -> String {
        guard let data = Data(base64Encoded: input) else { return "not base64 format" }
        let ret = String(data: (data), encoding: .utf8)
        return ret==nil ? "not base64 format" : ret!
    }

}
