//
//  Constants.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/5.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import Foundation

@objc public enum AuthType: Int {
    case album = 0
    case camera
}

struct Alert {
    struct Action {
        static let open = "去开启"
        static let cancel = "取消"
        static let agree = "好"
        static let disagree = "不允许"
        static let goOn = "继续"
        static let allow = "允许"
        static let notAllow = "不允许"
        static let setting = "设置"
    }
    
//    struct Toast {
//        static let unsupported = "设备不支持拍照！"
//        static let calenderAddError = "添加失败，请稍后重试"
//    }
}

