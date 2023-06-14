//
//  WXUserInfo.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/14.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import XYUIKit

class WXUserInfo {
    static var shared: WXUserInfo = WXUserInfo()
    private init () { }
    
    var icon: UIImage? = UIImage(named: "100003")
    var iconName: String? = "100003"
    var name: String? = "深海一只贝"
    var wechatId: String? = "Wx888"
}
