//
//  CommandOperation.swift
//  ZZExtension
//
//  Created by isee15 on 2016/11/26.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

protocol CommandOperation {
    func doAction(input: String) -> AnyObject

    func reverseAction(input: String) -> String
}
