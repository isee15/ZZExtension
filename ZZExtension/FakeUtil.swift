//
//  FakeUtil.swift
//  ZZExtension
//
//  Created by rui on 2017/1/13.
//  Copyright © 2017年 isee15. All rights reserved.
//

import Cocoa

class FakeUtil: NSObject {
    //iso加权数组
    static let iso7064Arr = [7,9, 10, 5, 8, 4,2, 1, 6, 3, 7,9, 10, 5 ,8, 4,2]
    //iso校验数组,其中大小写x均视为10
    static let iso7064ModArr = [1,0, 10, 9, 8, 7,6, 5, 4, 3, 2]
    
    // 18位身份证号码各位的含义:
    // 1-2位省、自治区、直辖市代码；
    // 3-4位地级市、盟、自治州代码；
    // 5-6位县、县级市、区代码；
    // 7-14位出生年月日，比如19670401代表1967年4月1日；
    // 15-17位为顺序号，其中17位（倒数第二位）男为单数，女为双数；
    // 18位为校验码，0-9和X。
    // 作为尾号的校验码，是由把前十七位数字带入统一的公式计算出来的，
    // 计算的结果是0-10，如果某人的尾号是0－9，都不会出现X，但如果尾号是10，那么就得用X来代替，
    // 因为如果用10做尾号，那么此人的身份证就变成了19位。X是罗马数字的10，用X来代替10
    static func rand(_ max: Int) -> Int {
        let randomIndex = Int(arc4random_uniform(UInt32(max)))
        return randomIndex
    }
    
    //验证身份证号
    static func computeCheckSum(_ idCardNo: String) -> String {
        let R:[Int]          = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        let checksumMap:[String] = ["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"]
        let arr = Array(idCardNo.characters)[0...16]
        let sum = R.enumerated().reduce(0) {
            return $0 + Int(String(arr[$1.0]))! * $1.1
        }
        
        return checksumMap[sum % 11]
    }

    
    static func generateID() -> String {
        var fakeId = "420222199204179999";
        // 随机生成省、自治区、直辖市代码 1-2
        let provinces = [ "11", "12", "13", "14", "15", "21", "22", "23",
            "31", "32", "33", "34", "35", "36", "37", "41", "42", "43",
            "44", "45", "46", "50", "51", "52", "53", "54", "61", "62",
            "63", "64", "65", "71", "81", "82" ];
        let randomIndex = rand(provinces.count)
        let province = provinces[randomIndex];
        // 随机生成地级市、盟、自治州代码 3-4
        let city = rand(18)+1;
        // 随机生成县、县级市、区代码 5-6
        let county = rand(28)+1;
        // 随机生成出生年月 7-14
        let days:Double = Double(rand(365 * 50))
        let birth = Date.init().addingTimeInterval(-days * 24 * 60 * 60);
        // 随机生成顺序号 15-17(随机性别)
        let no = rand(999) + 1;
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        
        fakeId = String(format: "%@%02d%02d%@%03d", province,city,county,df.string(from: birth),no)
        // 随机生成校验码 18
        
        let check = computeCheckSum(fakeId + "0");
        // 拼接身份证号码
        
        return fakeId.appending(check);
    }
}
