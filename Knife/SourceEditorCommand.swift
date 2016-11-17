//
//  SourceEditorCommand.swift
//  Knife
//
//  Created by isee15 on 16/9/20.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        let commandIdentifier = invocation.commandIdentifier;
        
        if commandIdentifier == "cn.z.ZZExtension.Knife.CommentSelection" {
            let selections = invocation.buffer.selections;
            let buffers = invocation.buffer.lines;
            //XCSourceTextRange
            for case let selection as XCSourceTextRange in selections{
                let startLine = selection.start.line;
                let endLine = selection.end.line;
                
                var commentCount:Int = 0;
                for i in startLine...endLine {
                    guard let line = invocation.buffer.lines[i] as? NSString else {
                        continue
                    }
                    guard !line.hasPrefix("//") else { commentCount += 1;continue }
                    let newLine = NSString(format: "//%@", line)
                    buffers.replaceObject(at: i, with: newLine)
                }
                //取消comment
                if (commentCount >= endLine - startLine) {
                    for i in startLine...endLine {
                        guard let line = invocation.buffer.lines[i] as? NSString else {
                            continue
                        }
                        let newLine = line.substring(from: 2)
                        buffers.replaceObject(at: i, with: newLine)
                    }

                }
                debugPrint(selection);
            }
        }
        else if commandIdentifier == "cn.z.ZZExtension.Knife.JsonPretty" {
            
            let buffers = invocation.buffer.completeBuffer;
            let data = buffers.data(using: .utf8);
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers);
                
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObj, options: JSONSerialization.WritingOptions.prettyPrinted);
                
                let prettyString = NSString(data: prettyData, encoding: String.Encoding.utf8.rawValue);
                
                invocation.buffer.lines.removeAllObjects();
                let prettyLines = prettyString?.components(separatedBy: "\n");
                invocation.buffer.lines.addObjects(from: prettyLines!);
            } catch  {
                print("exception in jsonpretty");
            }
            
        }

       
        
        
        completionHandler(nil)
    }
    
}
