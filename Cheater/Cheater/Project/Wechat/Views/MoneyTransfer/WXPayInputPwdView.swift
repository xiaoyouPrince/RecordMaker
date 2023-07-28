//
//  WXPayInputPwdView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/26.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 微信转账,输入密码的 View
 *
 *  1. 基本UI
 *  2. 输入密码键盘
 */
import UIKit
import XYUIKit

struct WXPayInputPwdViewModel{
    let userName: String
    let amountOfMoney: CGFloat
}

class WXPayInputPwdView: UIView {
    
    private let closeBtn = UIButton()
    private let title_label = UILabel(title: "请输入支付密码", font: .boldSystemFont(ofSize: 14), textColor: .C_222222, textAlignment: .center)
    private let toLabel = UILabel(title: "向 XX 转账", font: .systemFont(ofSize: 17), textColor: .C_222222, textAlignment: .center)
    private let yuanLabel = UILabel(title: "¥", font: .wx_moeny_font(25), textColor: .C_222222, textAlignment: .center)
    private let moneyLabel = UILabel(title: "2.00", font: .wx_moeny_font(40), textColor: .C_222222, textAlignment: .center)
    private let line = UIView.line
    private let payTypeLabel = UILabel(title: "付款方式", font: .systemFont(ofSize: 12), textColor: .C_999999, textAlignment: .center)
    private let payTypeView = PaytypeView()
    private let pwdView: PwdView!

    init(model: WXPayInputPwdViewModel, callback: @escaping ()->()) {
        pwdView = PwdView(callback: {
            callback()
        })
        super.init(frame: .zero)
        
        setModel(model)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension WXPayInputPwdView {
    
    func setModel(_ model: WXPayInputPwdViewModel) {
        toLabel.text = "向" + model.userName + "转账"
        moneyLabel.text = String(format: "%.2f", model.amountOfMoney)
    }
    
    func buildUI() {
        addSubview(closeBtn)
        addSubview(title_label)
        addSubview(toLabel)
        addSubview(yuanLabel)
        addSubview(moneyLabel)
        addSubview(line)
        addSubview(payTypeLabel)
        addSubview(payTypeView)
        addSubview(pwdView)
        
        closeBtn.addTap { sender in
            XYAlertSheetController.dissmiss()
        }
        closeBtn.setImage(.nav_close, for: .normal)
        closeBtn.snp.makeConstraints { make in
            make.left.top.equalTo(20)
        }
        
        title_label.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
        toLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(title_label.snp.bottom).offset(20)
        }
        
        yuanLabel.snp.makeConstraints { make in
            make.right.equalTo(moneyLabel.snp.left).offset(-2)
            make.top.equalTo(moneyLabel).offset(3)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(5)
            make.top.equalTo(toLabel.snp.bottom).offset(20)
        }
        
        line.backgroundColor = .C_wx_keyboard_bgcolor
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalTo(-30)
            make.height.equalTo(CGFloat.line)
            make.top.equalTo(moneyLabel.snp.bottom).offset(20)
        }
        
        payTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(line.snp.bottom).offset(20)
        }
        
        payTypeView.snp.makeConstraints { make in
            make.centerY.equalTo(payTypeLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        pwdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(payTypeLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()//.offset(-CGFloat.safeBottom)
        }
    }
}

// MARK: - PaytypeView
 
class PaytypeView: UIView {
    
    let iconView = UIImageView()
    let titleLabel = UILabel()
    let arrawView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(arrawView)
        
        iconView.image = UIImage(named: "lingqian")
        iconView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.text = "零钱"
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = .C_999999
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(2)
            make.centerY.equalToSuperview()
        }
        
        arrawView.image = UIImage(named: "Map_xiala")?.withRenderingMode(.alwaysTemplate)
        arrawView.tintColor = titleLabel.textColor
        arrawView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(3)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PwdView

class PwdView: UIView {
    
    /// 输入框
    private var boxs = [UITextField]()
    /// 当前输入的密码
    private var pwd = ""
    private var callback: (()->())?

    init(callback: @escaping ()->()) {
        super.init(frame: .zero)
        self.callback = callback
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PwdView {
    func buildUI() {
        // 输入框
        let margin = 10
        let wh = 40
        for index in 0...5 {
            let box = UITextField()
            box.isUserInteractionEnabled = false
            box.isSecureTextEntry = true
            box.textAlignment = .center
            addSubview(box)
            box.backgroundColor = WXConfig.inputBgColor
            box.corner(radius: 5)
            box.snp.makeConstraints { make in
                make.width.height.equalTo(wh)
                make.top.equalTo(20)
                make.centerX.equalToSuperview().offset(-(wh + margin) * 2 - (margin + wh)/2 + index * (margin + wh) )
            }
            self.boxs.append(box)
        }
        
        // 键盘
        let keyBdHeight: CGFloat = 90
        let kbView = UIView()
        addSubview(kbView)
        kbView.backgroundColor = .C_wx_keyboard_bgcolor//.line//WXConfig.inputBgColor
        kbView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(keyBdHeight)
            make.bottom.equalToSuperview()
        }
        
        
        let keys = TheKeys
        let clunm = 3
        let kbMargin = CGFloat.line
        let width = (CGFloat.width - 2*kbMargin) / 3
        let height = 49
        for (index, key) in keys.enumerated() {
            //if key.isEmpty { continue }
            
            let btn = UIButton(type: .system)
            kbView.addSubview(btn)
            btn.setTitle(key, for: .normal)
            btn.setTitleColor(.C_000000, for: .normal)
            btn.titleLabel?.font = .wx_moeny_font(25)
            btn.backgroundColor = .white
            btn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(CGFloat(index%clunm) * (width+kbMargin))
                make.top.equalToSuperview().offset(CGFloat(index/clunm) * (CGFloat(height)+kbMargin) + CGFloat.line)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            
            if key == "delete" {
                btn.setImage(UIImage(named: "deleteNum")?.withRenderingMode(.alwaysOriginal), for: .normal)
                btn.setTitle("", for: .normal)
                btn.backgroundColor = .C_wx_keyboard_bgcolor
            }
            if key == "" {
                btn.backgroundColor = .C_wx_keyboard_bgcolor
            }
            
            btn.addTap { [weak self] sender in
                guard let self = self, let sender = sender as? UIButton else { return }
                self.keyBoardBtnClick(sender: sender)
            }
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(keyBdHeight + CGFloat(height) * 4 + 2*CGFloat.line)
        }
    }
}

private extension PwdView {
    var TheKeys: [String] {
        [
            "1", "2", "3",
            "4", "5", "6",
            "7", "8", "9",
            "", "0", "delete"
        ]
    }
    
    /// 键盘按键点击
    /// - Parameter sender: 按键按钮
    func keyBoardBtnClick(sender: UIButton) {
        
        if sender.currentImage != nil { // 说明是删除按钮
            pwd = String(pwd.dropLast(1))
        }else{
            pwd.append(sender.currentTitle ?? "")
        }
    
        boxs.forEach{ $0.text = nil }
        for index in 0..<pwd.count {
            boxs[index].text = "*"
        }
        
        // done
        if pwd.count == boxs.count {
            callback?()
            self.isUserInteractionEnabled = false // 暂时禁用一下,细节较多,不能沉浸到太细节
        }
    }
}
