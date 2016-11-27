//
//  TimestampOperation.swift
//  ZZExtension
//
//  Created by isee15 on 2016/11/27.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

class TimestampOperation: NSObject, CommandOperation {
    func doAction(input: String) -> AnyObject {
        let longTime = Double(input)
        let dateTime = Date.init(timeIntervalSince1970: longTime!)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HH:mm:ss.SSS"
        return formatter.string(from: dateTime) as AnyObject
    }

    func reverseAction(input: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HH:mm:ss.SSS"
        let dateTime = formatter.date(from: input)
        return String(format: "%.3f", (dateTime?.timeIntervalSince1970)!)
    }

}
