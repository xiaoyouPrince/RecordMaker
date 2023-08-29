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
    static var C_666666: UIColor = .xy_getColor(hex: 0x666666)
    static var C_999999: UIColor = .xy_getColor(hex: 0x999999)
    
    /// 设置微信状态,图片的 initColor, 原图是黑色背景
    static var C_wx_green: UIColor = WXConfig.wxGreen
    
    /// 设置微信状态,图片的 initColor, 原图是黑色背景
    static var C_wx_status: UIColor = .xy_getColor(red: 103, green: 113, blue: 148)
    
    /// 红点颜色
    static var C_red_dot: UIColor = .xy_getColor(red: 228, green: 53, blue: 58)
    
    /// 微信红色,比如发红包按钮
    static var C_wx_red_button: UIColor = .xy_getColor(red: 227, green: 72, blue: 44)
    
    /// 微信提示文字的颜色 一种浅灰色
    static var C_wx_tip_text: UIColor = .xy_getColor(red: 137, green: 137, blue: 137)
    
    /// 微信按钮/超链接文字颜色
    static var C_wx_link_text: UIColor = .xy_getColor(red: 80, green: 92, blue: 133)
    
    /// 微信自定义键盘的背景色
    static var C_wx_keyboard_bgcolor: UIColor = .xy_getColor(red: 241, green: 241, blue: 241)
}

extension UIImage {
    
    /// 微信返回按钮的图片
    static var wx_backImag = UIImage(named: "wechat_fanhui")?.withRenderingMode(.alwaysOriginal)
    
    /// 微信右上角的三个点
    static var wx_right_3dot = UIImage(named: "wechat_sandian")?.withRenderingMode(.alwaysOriginal)
    
    /// 微信右上角的三个点
    static var wx_right_arraw = UIImage(named: "youjiantou")?.withRenderingMode(.alwaysOriginal)
    
    /// 默认添加头像
    static var defaultHead = UIImage(named: "add_head")?.withRenderingMode(.alwaysOriginal)
    
    /// 导航条 close 按钮图片  x
    static var nav_close = UIImage(named: "nav_close")?.withRenderingMode(.alwaysOriginal)
}


extension UIFont {
    /// 获取微信金额有关的 font
    /// - Parameter size: 字号大小
    /// - Returns: uifont
    static func wx_moeny_font(_ size: CGFloat) -> UIFont {
        UIFont(name: "WeChat-Sans-Std-Medium", size: size) ?? .boldSystemFont(ofSize: size)
    }
}


// MARK: - 统一记录一下存储在 UserDefault 中的 key
extension UserDefaults {
    struct Key {
        /// 用户创建微信转账时候输入微信密码提示弹框的 key
        static let tip_for_wx_pay_pwd_has_closed_by_user = "tip_for_wx_pay_pwd_has_closed_by_user"
    }
}
