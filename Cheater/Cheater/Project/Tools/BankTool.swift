//
//  BankTool.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/29.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

// 一个银行卡相关的小工具

import Foundation
import UIKit

struct BankTool {
    static private var _allBanks: [Bank] = []
}

extension BankTool {
    /// 获取所有银行
    static var allBanks: [Bank] {
        if _allBanks.isEmpty == false {
            return _allBanks
        }
        
        for dict in bankDict {
            let bank = Bank(title: dict.value, icon: dict.key)
            _allBanks.append(bank)
        }
        return _allBanks
    }
    
    /// 随机获取一个银行
    static var randomBank: Bank {
        let index = arc4random() % UInt32(allBanks.count)
        return allBanks[Int(index)]
    }
    
    /// 通过银行名获取一个银行
    /// - Parameter name: 银行名
    /// - Returns: 银行
    static func bankWithName(_ name: String) -> Bank? {
        for (icon, title) in bankDict {
            if title == name {
                return Bank(title: title, icon: icon)
            }
        }
        
        return nil
    }
}

extension BankTool {
    struct BankCard {
        var bank: Bank
        /// 卡号
        var cardNumber: String
    }
    
    struct Bank {
        /// 银行卡名称
        var title: String
        /// 银行卡图片,保存的是icon名称
        var icon: String
        
        var image: UIImage {
            UIImage(named: icon) ?? .init()
        }
    }
    
    private static var bankDict: [String: String] = [
        "BANK_ABC"     : "农业银行",
        "BANK_BOC"     : "中国银行",
        "BANK_CCB"     : "建设银行",
        "BANK_CEB"     : "光大银行",
        "BANK_CIB"     : "兴业银行",
        "BANK_CITIC"   : "中信银行",
        "BANK_CMB"     : "招商银行",
        "BANK_CMBC"    : "民生银行",
        "BANK_COMM"    : "交通银行",
        "BANK_GDB"     : "广发银行",
        "BANK_HXBANK"  : "华夏银行",
        "BANK_ICBC"    : "工商银行",
        "BANK_PSBC"    : "邮政储蓄",
        "BANK_SPABANK" : "平安银行",
        "BANK_SPDB"    : "浦发银行",
        "BANK_SZRCB"   : "深圳农业商业银行",
        "BANK_YDRCB"   : "农村信用社"
    ]
}
