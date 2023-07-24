//
//  MoneyTransferContentView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/24.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 发转账页面中间的输入金额和编辑转账说明文案视图
 */

import UIKit
import XYUIKit

class MoneyTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.hideMenu(from: self)
        DispatchQueue.main.async {
            self.findSubViewRecursion { subview in
                if subview.bounds.width == 2 {
                    subview.backgroundColor = WXConfig.wxGreen
                    return true
                }
                return false
            }
        }
        return false
    }
}

class MoneyTransferContentView: UIView {

    let topLabel = UILabel()
    let yuanLabel = UILabel()
    let moneyTF = MoneyTextField()
    let line = UIView.line
    let moneyTipView = MoneyTransferTipView()
    let tipLabel = UILabel()
    let changeTipBtn = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        buildUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MoneyTransferContentView {
    
    @objc func textFieldTextDidChange(_ noti: Notification){
        
        guard let tf = noti.object as? UITextField else {
            return
        }
        
        if tf == self.moneyTF {
            let intValue = Int(tf.text?.doubleValue ?? 0)
            
            // 从 千 开始, 到百万
            var tipString = ""
            if (1000...9999).contains(intValue) { tipString = "千" }
            if (10000...99999).contains(intValue) { tipString = "万" }
            if (100000...999999).contains(intValue) { tipString = "十万" }
            if (1000000...9999999).contains(intValue) { tipString = "百万" }
            if (9999999...(.max)).contains(intValue) { tipString = "大哥,你没那么多钱" }
            
            //Toast.make(tipString)
            moneyTipView.isHidden = tipString.isEmpty
            if tipString.isEmpty == false {
                moneyTipView.updateText(tipString)
            }
        }
    }
    
    func buildUI() {
        addSubview(topLabel)
        addSubview(yuanLabel)
        addSubview(moneyTF)
        addSubview(line)
        addSubview(moneyTipView)
        addSubview(tipLabel)
        addSubview(changeTipBtn)
        
        topLabel.text = "转账金额"
        topLabel.font = .systemFont(ofSize: 13)
        topLabel.textColor = .C_222222
        topLabel.snp.makeConstraints { make in
            make.top.left.equalTo(30)
        }
        
        yuanLabel.text = "¥"
        yuanLabel.textColor = .C_000000
        yuanLabel.font = .wx_moeny_font(35)
        yuanLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        yuanLabel.snp.makeConstraints { make in
            make.left.equalTo(topLabel)
            make.top.equalTo(topLabel.snp.bottom).offset(25)
        }
        
        moneyTF.font = .wx_moeny_font(50)
        moneyTF.textColor = .C_000000
        moneyTF.snp.makeConstraints { make in
            make.top.equalTo(yuanLabel).offset(0)
            make.left.equalTo(yuanLabel.snp.right).offset(8)
            make.right.equalTo(-25)
            make.height.equalTo(50)
        }
        
        line.snp.makeConstraints { make in
            make.left.equalTo(yuanLabel)
            make.right.equalTo(-30)
            make.top.equalTo(moneyTF.snp.bottom).offset(10)
            make.height.equalTo(CGFloat.line)
        }
        
        moneyTipView.isHidden = true
        moneyTipView.snp.makeConstraints { make in
            make.left.equalTo(line).offset(15)
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(line.snp.bottom).offset(-6)
        }
        
        tipLabel.text = ""
        tipLabel.textColor = .C_wx_tip_text
        tipLabel.font = .systemFont(ofSize: 12)
        tipLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tipLabel.numberOfLines = 0
        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(30)
            make.left.equalTo(line)
            make.right.equalTo(changeTipBtn.snp.left).offset(-5)
        }
        
        changeTipBtn.setTitle("添加转账说明", for: .normal)
        changeTipBtn.titleLabel?.font = tipLabel.font
        changeTipBtn.setTitleColor(.xy_getColor(red: 80, green: 92, blue: 133), for: .normal)
        changeTipBtn.snp.makeConstraints { make in
            make.right.lessThanOrEqualToSuperview().offset(-25)
            make.centerY.equalTo(tipLabel)
        }
        changeTipBtn.addTap { [weak self] sender in
            guard let self = self else { return }
            self.addTransferTips()
        }
    }
    
    func start() {
        moneyTF.becomeFirstResponder()
        
        let input = MoneyTransferInputView()
        input.callback = {[weak self] newKey in
            guard let self = self else { return }
            let currentText = self.moneyTF.text ?? ""
            
            if newKey == "\n" {
                if currentText.intValue > 0 {
                    Toast.make("转钱啊")
                }else{
                    Toast.make("需先填写金额")
                }
                
            }else
            if newKey == "" {
                let newText = currentText.dropLast(1)
                self.moneyTF.text = String(newText)
                NotificationCenter.default.post(Notification(name: UITextField.textDidChangeNotification,object: self.moneyTF))
            }else{
                self.moneyTF.text = currentText + newKey
                NotificationCenter.default.post(Notification(name: UITextField.textDidChangeNotification,object: self.moneyTF))
            }
        }
        
        moneyTF.inputView = input
        DispatchQueue.main.asyncAfter(deadline: .now() + UINavigationController.hideShowBarDuration, execute: {
            self.moneyTF.becomeFirstResponder()
            self.moneyTF.findSubViewRecursion { subview in
                if subview.bounds.width == 2 {
                    subview.backgroundColor = WXConfig.wxGreen
                    return true
                }
                return false
            }
        })
    }
    
    func end() {
        moneyTF.resignFirstResponder()
    }
    
    /// 添加转装说明
    func addTransferTips() {
        guard let currentVC = viewController else { return }
        /*
         * - TODO -
         * 弹框添加转账说明
         * 添加完成后,要根据所添加内容判断展示
         *  1. 有内容,显示内容,按钮改为修改
         *  2. 无内容,显示空内容,按钮显示添加转账说明
         */
        
        end()
        let alert = XYAlertSheetController.showCustom(on: currentVC, customContentView: getTransferTipView(tip: tipLabel.text, ok: {[weak self] tipString in
            guard let self = self else { return }
            self.tipLabel.text = tipString
            
            if tipString.isEmpty {
                self.changeTipBtn.setTitle("添加转账说明", for: .normal)
            } else {
                self.changeTipBtn.setTitle("修改", for: .normal)
            }
            
            self.start()
        }))
        
        // 用户点击空白区域取消操作
        alert.dismissCallback = {
            self.start()
        }
    }
    
    /// 校验完成,转账前进行微信支付,输入密码和确认的流程
    func readyToTransfer() {
        /*
         * - TODO -
         * 仿写微信支付流程
         *
         *  1. 微信支付 HUD 弹出
         *  2. 微信支付密码验证
         *  3. 提示用户,这是个假的,随便输入即可
         */
    }
}

extension MoneyTransferContentView {
    
    /// 弹出添加转装说明的view
    /// - Parameters:
    ///   - orign: 已经添加的转账说明文字
    ///   - callback: 点击确定后最新的转账说明文字
    /// - Returns: 被弹出的 UIView
    func getTransferTipView(tip orign: String? = nil, ok callback:@escaping (String)->()) -> UIView {
        let result = UIButton()
        result.backgroundColor = .white
        result.corner(radius: 15)
        
        let titleLabel = UILabel(title: "转账说明", font: .systemFont(ofSize: 15), textColor: .C_000000, textAlignment: .left)
        result.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(20)
        }
        
        let tfContent = UIView()
        result.addSubview(tfContent)
        tfContent.corner(radius: 5)
        tfContent.backgroundColor = WXConfig.navBarBgColor
        tfContent.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        let tf = UITextField(frame: .zero)
        tf.backgroundColor = WXConfig.navBarBgColor
        tf.placeholder = "收付款双方可见,最多60个字"
        tf.text = orign
        tf.becomeFirstResponder()
        tfContent.addSubview(tf)
        tf.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalToSuperview()
            make.top.equalTo(0)
        }
        
        let cancelBtn = UIButton(type: .system)
        cancelBtn.corner(radius: 5)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.backgroundColor = WXConfig.navBarBgColor
        cancelBtn.setTitleColor(.black, for: .normal)
        result.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().multipliedBy(0.5).offset(-8)
            make.top.equalTo(tf.snp.bottom).offset(50)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        cancelBtn.addTap { sender in
            XYAlertSheetController.dissmiss()
        }
        
        let okBtn = UIButton(type: .system)
        okBtn.corner(radius: 5)
        okBtn.setTitle("确定", for: .normal)
        okBtn.backgroundColor = WXConfig.wxGreen
        okBtn.setTitleColor(.white, for: .normal)
        result.addSubview(okBtn)
        okBtn.snp.makeConstraints { make in
            make.left.equalTo(cancelBtn.snp.right).offset(16)
            make.top.equalTo(tf.snp.bottom).offset(50)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        okBtn.addTap {sender in
            callback(tf.text ?? "")
            XYAlertSheetController.dissmiss()
        }
        
        result.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.height - 200)
        }
        return result
    }
}
