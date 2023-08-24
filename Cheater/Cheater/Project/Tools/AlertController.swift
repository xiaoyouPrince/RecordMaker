//
//  AlertController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/7.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

struct AlertController {
    
    /// 弹出一个 tip 类型的 alert
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - callback: 确认按钮点击回调
    static func showTipAlert(title: String, message: String, okBtnTitle btnTitle: String, _ callback:@escaping ()->()) {
        showAlert(title: title, message: message, btnTitles: btnTitle) { _ in callback() }
    }
    
    /// 弹出一个弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 晓霞
    ///   - btnTitles: 底部按钮标题, 逗号分隔 egg: "cancel", "ok"
    ///   - callback: 按钮点击回调, 按标题顺序从 0 开始
    static func showAlert(title: String, message: String, btnTitles: String..., callback:@escaping (_ index: Int)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (idx, title) in btnTitles.enumerated() {
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
                alert.dismiss(animated: true)
                callback(idx)
            }))
        }
        UIViewController.currentVisibleVC.present(alert, animated: true)
    }
    
    /// 弹出设置未读数输入 alert
    /// - Parameter callback: 确认回调
    static func showInputCountAlert(_ callback: @escaping (_ text: String)->()) {
        showTextFiledAlert(title: "设置未读数量", message: nil) { tf in
            tf.placeholder = "请输入未读消息数量"
            tf.keyboardType = .numberPad
        } callBack: { text in
            callback(text)
        }
    }
    
    /// 弹出一个可以含有输入框的 alert
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - configurationHandler: textField 配置回调
    ///   - callBack: 用户点击确定回调
    static func showTextFiledAlert(title: String, message: String?, configurationHandler: ((UITextField) -> Void)? = nil, callBack: @escaping (_ text: String)->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationHandler)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { action in
            alert.dismiss(animated: true)
            let count = alert.textFields?.first?.text ?? ""
            callBack(count)
        }))
        
        UIViewController.currentVisibleVC.present(alert, animated: true)
    }
    
    /// 弹出合法性提示弹框
    /// - Parameter callBack: 当用户点击不同意按钮回调
    static func showLegalTips(callBack: @escaping ()->()) {
        showAlert(title: "改功能仅限于娱乐,请勿用于违法行为,否则封号上报!", message: "", btnTitles: "同意","不同意") { index in
            if index == 1 {
                callBack()
            }
        }
    }
}
