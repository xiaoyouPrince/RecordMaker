//
//  WXConfig.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/13.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/**
 一些微信页面的配置项目
 如各种颜色
 
 */

import XYUIKit

enum WXTheme {
    case light, dark
}

struct WXConfig {
    static var shared: WXConfig = WXConfig()
    private init () { }
    
    /// 导航栏背景色
    static var navBarBgColor: UIColor {
        // 判断主题 - default is light
        return UIColor.xy_getColor(red: 230, green: 230, blue: 230)//.withAlphaComponent(0.8)
    }
    
    /// 微信tabbar背景色
    static var tabBarBgColor: UIColor {
        return UIColor.xy_getColor(red: 246, green: 246, blue: 246).withAlphaComponent(0.8)
    }
    
    /// 微信tabbar Item 选中色
    static var tabBarItemSelelectedColor: UIColor {
        return UIColor.xy_getColor(red: 25, green: 184, blue: 78)
    }
    
    /// 微信tabbar Item 未选中色
    static var tabBarItemNormalColor: UIColor {
        return UIColor.xy_getColor(red: 0, green: 0, blue: 0)
    }
    
    /// 微信列表背景色
    static var listBgColor: UIColor {
        return UIColor.xy_getColor(red: 255, green: 255, blue: 255)
    }
    
    /// 微信主页的背景色(同导航栏颜色无透明)
    static var tableViewBgColor: UIColor {
        return navBarBgColor.withAlphaComponent(1)
    }
    
}
