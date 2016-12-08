//
//  ZZLinkMapViewController.swift
//  ZZExtension
//
//  Created by isee15 on 2016/12/7.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa

class SymbolModel: NSObject {
    var file: String!
    var size: UInt = 0
}

class ZZLinkMapViewController: NSViewController {

    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet var contentTextView: NSTextView!
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    @IBOutlet weak var groupButton: NSButton!
    @IBOutlet weak var filePathField: NSTextField!
    
    var linkMapFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.contentTextView.string = "使用方式：\n" + "1.在XCode中开启编译选项Write Link Map File \n" +
        "XCode -> Project -> Build Settings -> 把Write Link Map File选项设为yes，并指定好linkMap的存储位置 \n" +
        "2.工程编译完成后，在编译目录里找到Link Map文件（txt类型） \n" +
        "默认的文件地址：~/Library/Developer/Xcode/DerivedData/XXX-xxxxxxxxxxxxx/Build/Intermediates/XXX.build/Debug-iphoneos/XXX.build/ \n" +
        "3.回到本应用，点击“选择文件”，打开Link Map文件  \n" +
        "4.点击“开始”，解析Link Map文件 \n" +
        "5.点击“输出文件”，得到解析后的Link Map文件 \n" +
        "6. * 输入目标文件的关键字(例如：libIM)，然后点击“开始”。实现搜索功能 \n" +
        "7. * 勾选“分组解析”，然后点击“开始”。实现对不同库的目标文件进行分组"
    }
    
    @IBAction func selectFile(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.resolvesAliases = false
        panel.canChooseFiles = true
        
        panel.begin { (result) in
            if result == NSFileHandlingPanelOKButton {
                let document = panel.url
                self.filePathField.stringValue = (document?.path)!
                self.linkMapFileURL = document
            }
        }
    }
    @IBAction func startAnalyze(_ sender: Any) {
        if (self.linkMapFileURL == nil || !FileManager.default.fileExists(atPath: (self.linkMapFileURL?.path)!)) {
            self.showAlert("请选择正确的Link Map文件路径")
            return
        }
        DispatchQueue.global().async {
            let encoding: String.Encoding = .macOSRoman
            guard let content = try? String(contentsOf: self.linkMapFileURL!, encoding: encoding)
                else {
                    self.showAlert("Link Map文件格式有误")
                    return
            }
            DispatchQueue.main.async {
                self.indicator.isHidden = false
                self.indicator.startAnimation(self)
            }
            let symbolMap = self.symbolMapFromContent(content)
            let symbols = symbolMap.values
            let sortSymbols = symbols.sorted(by: { (s1, s2) -> Bool in
                return s1.size > s2.size
            })
            var output = ""
            if self.groupButton.state == 1 {
                output = self.buildCombinationResultWithSymbols(sortSymbols)
            }
            else {
                output = self.buildResultWithSymbols(sortSymbols)
            }
            
            DispatchQueue.main.async {
                self.contentTextView.string = output
                self.indicator.isHidden = true
                self.indicator.stopAnimation(self)
            }
        }
    }
    
    func buildCombinationResultWithSymbols(_ symbols:[SymbolModel]) -> String {
        var result = "库大小\t库名称\r\n\r\n"
        var totalSize:UInt = 0
        
        var combinationMap = [String:SymbolModel]()
        
        for symbol in symbols {
            let name = symbol.file.components(separatedBy: "/").last
            if (name?.hasSuffix(")"))! && (name?.contains("("))! {
                let range = name?.range(of: "(")
                let component = name?.substring(to: (range?.lowerBound)!)
                var combinationSymbol = combinationMap[component!]
                if combinationSymbol == nil {
                    combinationSymbol = SymbolModel()
                    combinationMap[component!] = combinationSymbol
                }
                combinationSymbol?.size += symbol.size
                combinationSymbol?.file = component
            }
            else {
                combinationMap[symbol.file] = symbol
            }
        }
        
        let combinationSymbols = combinationMap.values
        let sortSymbols = combinationSymbols.sorted { (s1, s2) -> Bool in
            return s1.size > s2.size
        }
        let searchKey = self.searchField.stringValue
        
        for symbol in sortSymbols {
            if searchKey.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                if symbol.file.contains(searchKey) {
                    result.append(self.appendResultWithSymbol(symbol))
                    totalSize += symbol.size
                }
            }
            else {
                result.append(self.appendResultWithSymbol(symbol))
                totalSize += symbol.size
            }
        }
        return result.appendingFormat("\r\n总大小: %.2fM\r\n", (Double)(totalSize) / (1024*1024.0))
        
    }
    
    func buildResultWithSymbols(_ symbols:[SymbolModel]) -> String {
        var result = "文件大小\t文件名称\r\n\r\n"
        var totalSize:UInt = 0
        let searchKey = self.searchField.stringValue
        
        for symbol in symbols {
            if searchKey.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                if symbol.file.contains(searchKey) {
                    result.append(self.appendResultWithSymbol(symbol))
                    totalSize += symbol.size
                }
            }
            else {
                result.append(self.appendResultWithSymbol(symbol))
                totalSize += symbol.size
            }
        }
        return result.appendingFormat("\r\n总大小: %.2fM\r\n", (Double)(totalSize) / (1024*1024.0))
    }
    
    func appendResultWithSymbol(_ model: SymbolModel) -> String {
        var ret = ""
        if model.size > 1024*1024 {
            ret = String(format: "%.2fM",(Double)(model.size) / (1024*1024.0))
        }
        else {
            ret = String(format: "%.2fK",(Double)(model.size) / 1024.0)
        }
        return String(format: "%@\t%@\t%ld\r\n", ret,model.file.components(separatedBy: "/").last!,model.size)
    }
    
    func symbolMapFromContent(_ content: String) -> [String:SymbolModel] {
        var symbolMap = [String:SymbolModel]()
        let lines = content.components(separatedBy: "\n")
        
        var reachFiles = false
        var reachSymbols = false
        var reachSections = false
        
        for line in lines {
            if line.hasPrefix("#") {
                if line.hasPrefix("# Object files:") {
                    reachFiles = true
                }
                else if line.hasPrefix("# Sections:") {
                    reachSections = true
                }
                else if line.hasPrefix("# Symbols:") {
                    reachSymbols = true
                }
            }
            else {
                if reachFiles && !reachSymbols && !reachSections {
                    let range = line.range(of: "]")
                    if range != nil {
                        let symbol = SymbolModel()
                        symbol.file = line.substring(from: line.index((range?.lowerBound)!,offsetBy:1))
                        let key = line.substring(to: line.index((range?.lowerBound)!,offsetBy:1))
                        symbolMap[key] = symbol
                    }
                }
                else if reachFiles && reachSymbols && reachSections {
                    let symbolArray = line.components(separatedBy: "\t")
                    if symbolArray.count == 3 {
                        let fileKeyAndName = symbolArray[2]
                        let size = strtoul(symbolArray[1], nil, 16)
                        let range = fileKeyAndName.range(of: "]")
                        if range != nil {
                            let key = fileKeyAndName.substring(to: line.index((range?.lowerBound)!,offsetBy:1))
                            let symbol: SymbolModel? = symbolMap[key]
                            if symbol != nil {
                                symbol?.size += size
                            }
                        }
                    }
                }
            }
        }
        return symbolMap
    }
    
    func showAlert(_ msg: String) {
        let alert = NSAlert()
        alert.messageText = msg
        alert.addButton(withTitle: "确定")
        alert.beginSheetModal(for: NSApplication.shared().windows[0], completionHandler: { (_) in
            
        })
    }
}
