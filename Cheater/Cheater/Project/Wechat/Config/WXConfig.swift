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
    
    /// 微信主题绿色
    static var wxGreen: UIColor {
        return UIColor.xy_getColor(red: 25, green: 184, blue: 78)
    }
    
    /// 输入框背景色
    static var inputBgColor: UIColor {
        // 判断主题 - default is light
        return UIColor.xy_getColor(red: 244, green: 244, blue: 244)//.withAlphaComponent(0.8)
    }
    
    static var wx_backImag = UIImage(named: "wechat_fanhui")?.withRenderingMode(.alwaysOriginal)
    
}

extension WXConfig {
    /// 微信消息列表的文件路径
    static let chatListFile: String = "chatlist.dat"
    
}


extension UIColor {
    static var C_587CF7: UIColor = .xy_getColor(hex: 0x587CF7)
    static var C_FFFFFF: UIColor = .xy_getColor(hex: 0xFFFFFF)
    static var C_000000: UIColor = .xy_getColor(hex: 0x000000)
    static var C_222222: UIColor = .xy_getColor(hex: 0x222222)
    /// 设置微信状态,图片的 initColor, 原图是黑色背景
    static var C_wx_status: UIColor = .xy_getColor(red: 103, green: 113, blue: 148)
    
    static var C_red_dot: UIColor = .xy_getColor(red: 228, green: 53, blue: 58)
}

extension UIImage {
    
    /// 微信返回按钮的图片
    static var wx_backImag = UIImage(named: "wechat_fanhui")?.withRenderingMode(.alwaysOriginal)
    
    /// 微信右上角的三个点
    static var wx_right_3dot = UIImage(named: "wechat_sandian")?.withRenderingMode(.alwaysOriginal)
}
