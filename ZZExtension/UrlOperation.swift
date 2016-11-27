//
//  UrlOperation.swift
//  ZZExtension
//
//  Created by isee15 on 2016/11/27.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

class UrlOperation: NSObject, CommandOperation {

    func doAction(input: String) -> AnyObject {
        return input.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)! as AnyObject
    }

    func reverseAction(input: String) -> String {
        return input.removingPercentEncoding!;
    }


}
