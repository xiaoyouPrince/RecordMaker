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
    //private init () { }
    
    var icon: UIImage? = UIImage(named: "100003")
    var iconName: String? = "100003"
    var name: String? = "深海一只贝"
    var realName: String? = "xiaoyou"
    var wechatId: String? = "Wx888"
    
    let id: Int = 10001 // 当前用户的系统唯一标识, 因为微信号是可以修改的,不能作为唯一标识
}

extension WXUserInfo {
    /// 获取加密后的真实姓名 egg: (**峰)
    var screatRealName: String {
        if var name = realName {
            var result = "("
            var stars = ""
            for _ in 0..<name.count {
                stars.append("*")
            }
            name.replaceSubrange(name.startIndex..<name.index(before: name.endIndex), with: stars)
            return result + name + ")"
        }
        return "(***)"
    }
    
    /// 支付或者转账场景下的名称 egg: 深海一只贝 (**u)
    var paySceneName: String {
        (name ?? "") + " " + screatRealName
    }
}
