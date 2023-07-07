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
    
    func showInputCountAlert(_ callback: @escaping (_ text: String)->()) {
        showTextFiledAlert(title: "设置未读数量", message: nil) { tf in
            tf.placeholder = "请输入未读消息数量"
            tf.keyboardType = .numberPad
        } callBack: { text in
            callback(text)
        }
    }
    
    func showTextFiledAlert(title: String, message: String?, configurationHandler: ((UITextField) -> Void)? = nil, callBack: @escaping (_ text: String)->()) {
        
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
}
