//
//  JsonOperation.swift
//  ZZExtension
//
//  Created by isee15 on 2016/11/26.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa
import CoreFoundation

class JsonOperation: NSObject, CommandOperation {

    func doAction(input: String) -> AnyObject {
        if let data = input.data(using: String.Encoding.utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                return self.jsonStringify(value: dict as AnyObject, prettyPrinted: true) as AnyObject;
            } catch let error as NSError {
                return error.localizedDescription as AnyObject
            }
        }
        return input as AnyObject;
    }

    func reverseAction(input: String) -> String {
        if let data = input.data(using: String.Encoding.utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                return self.jsonStringify(value: dict as AnyObject, prettyPrinted: false);
            } catch let error as NSError {
                return error.localizedDescription
            }
        }
        return input;
    }

    func jsonStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                return String(data: data, encoding: String.Encoding.utf8)!
            } catch let error as NSError {
                print(error)
            } catch {
            }
        }
        return ""
    }
}
