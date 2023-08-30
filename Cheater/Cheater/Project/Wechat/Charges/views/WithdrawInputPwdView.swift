//
//  WithdrawInputPwdView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/30.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 零钱提现输入密码的弹框 view
 *
 *  参见:
 *  微信零钱提现 - 输入密码
 */

import UIKit
import XYUIKit


class WithdrawInputPwdView: UIView {
    private var moneyAmmount: String
    /// 输入框
    private var boxs = [UITextField]()
    /// 当前输入的密码
    private var pwd = ""
    private var callback: (()->())?
    private let closeBtn = UIButton(type: .system)
    private let feeLabel = UILabel(title: "￥0.10", font: .systemFont(ofSize: 12), textColor: .black, textAlignment: .right)
    
    /// 初始化一个 inputPwdView
    /// - Parameter moneyAmmount: 金额数量
    init(moneyAmmount: String, doneCallBack: (()->())?) {
        self.moneyAmmount = moneyAmmount.toMoneyString
        self.callback = doneCallBack
        super.init(frame: .zero)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePwd(key: String) {
        if key == "delete" { // 说明是删除按钮
            pwd = String(pwd.dropLast(1))
        }else
        {
            pwd.append(key)
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
    
    private func setupContent() {
        backgroundColor = .white
        addSubview(closeBtn)
        closeBtn.setImage(.nav_close, for: .normal)
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(26)
        }
        closeBtn.addTap { sender in
            sender.viewController?.dismiss(animated: false)
        }
        
        let titleLabel = UILabel(title: "请输入支付密码", font: .boldSystemFont(ofSize: 16), textColor: .black, textAlignment: .center)
        addSubview(titleLabel)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(closeBtn)
            make.centerX.equalToSuperview()
        }
        
        let typeLabel = UILabel(title: "提现", font: .systemFont(ofSize: 17), textColor: .black, textAlignment: .center)
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
        
        let moneyView = MoneyView(with: moneyAmmount)
        addSubview(moneyView)
        moneyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(typeLabel.snp.bottom).offset(17)
        }
        
        let line = UIView.line
        addSubview(line)
        line.snp.makeConstraints { make in
            make.top.equalTo(moneyView.snp.bottom).offset(28)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(CGFloat.line)
        }
        
        let feeTipLabel = UILabel(title: "服务费", font: .systemFont(ofSize: 12), textColor: .C_wx_tip_text, textAlignment: .left)
        addSubview(feeTipLabel)
        feeTipLabel.snp.makeConstraints { make in
            make.left.equalTo(line)
            make.top.equalTo(line.snp.bottom).offset(15)
        }
        
        let feeRateLabel = UILabel(title: "费率", font: .systemFont(ofSize: 12), textColor: .C_wx_tip_text, textAlignment: .left)
        addSubview(feeRateLabel)
        feeRateLabel.snp.makeConstraints { make in
            make.left.equalTo(line)
            make.top.equalTo(feeTipLabel.snp.bottom).offset(8)
        }
        
        addSubview(feeLabel)
        feeLabel.text = "¥" + String(format: "%.2f", moneyAmmount.toMoneyString.floatValue * 0.01)
        feeLabel.snp.makeConstraints { make in
            make.right.equalTo(line)
            make.centerY.equalTo(feeTipLabel)
        }
        
        let feeRateDetailLabel = UILabel(title: "0.10%（最低¥0.10）", font: .systemFont(ofSize: 12), textColor: .black, textAlignment: .center)
        addSubview(feeRateDetailLabel)
        feeRateDetailLabel.snp.makeConstraints { make in
            make.right.equalTo(line)
            make.centerY.equalTo(feeRateLabel)
        }
        
        // boxV
        let boxv = getPwdBoxView()
        addSubview(boxv)
        boxv.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }

        snp.makeConstraints { make in
            make.bottom.equalTo(boxv.snp.bottom).offset(30)
        }
    }
    
    private func getPwdBoxView() -> UIView {
        let result = UIView()
        // 输入框
        let margin = 10
        let wh = 40
        for index in 0...5 {
            let box = UITextField()
            box.isUserInteractionEnabled = false
            box.isSecureTextEntry = true
            box.textAlignment = .center
            result.addSubview(box)
            box.backgroundColor = WXConfig.inputBgColor
            box.corner(radius: 5)
            box.snp.makeConstraints { make in
                make.width.height.equalTo(wh)
                make.top.equalToSuperview()
                make.left.equalTo( index * (margin + wh))
                if index == 5{
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
            self.boxs.append(box)
        }
        
        return result
    }
}
