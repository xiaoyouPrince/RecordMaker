//
//  WithdrawContentInputView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/29.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

class WithdrawContentInputView: UIView {
    private let titleLabel = UILabel(title: "提现金额", font: .systemFont(ofSize: 16), textColor: .black, textAlignment: .left)
    private let textField: UITextField = .init()
    private let totalMoneyLabel = UILabel(title: "当前零钱余额100.00元,", font: .systemFont(ofSize: 16), textColor: .C_wx_tip_text, textAlignment: .left)
    private let actionBtn = UILabel(title: "全部提现", font: .systemFont(ofSize: 16), textColor: .C_wx_link_text, textAlignment: .left)
    
    private var bankCard: BankTool.BankCard?
    /// 零钱数量
    var chaegesAmmount: String = "0.00" {
        didSet{
            totalMoneyLabel.text = "当前零钱余额\(chaegesAmmount.toMoneyString)元,"
        }
    }
    var rate: String = "0.1%"
    /// 更新零钱余额和费率
    /// - Parameters:
    ///   - moneyAmmount: 零钱数量
    ///   - rate: 费率
    func update(moneyAmmount: String, rate: String, bankCard: BankTool.BankCard?) {
        chaegesAmmount = moneyAmmount
        textField.text = chaegesAmmount.toMoneyString
        self.rate = rate
        self.bankCard = bankCard
    }
    
    func update(bankCard: BankTool.BankCard?) {
        self.bankCard = bankCard
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        
        // tf input view and callback
        textField.setMoneyTransferInputView {[weak self] in
            guard let self = self else { return }
            self.textViewDidClickReturn()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidClickReturn() {
        if let text = textField.text, text.doubleValue > 0 {
            WXPayHUD.show {
                let inputPwdPage = WithdrawInputPwdController(moneyAmmount: self.textField.text ?? "", rate: self.rate)
                UIViewController.currentVisibleVC.nav_present(inputPwdPage, animated: false)
                inputPwdPage.callback = { [weak self] in
                    guard let self = self, let bankCard = self.bankCard else { return }
                    
                    let withdrawAmmount = self.textField.text ?? ""
                    let fee = withdrawAmmount.toMoneyString.floatValue * self.rate.replacingOccurrences(of: "%", with: "").floatValue * 0.01
                    let pageInfo = WithdrawInprogressViewController.PageInfo(bankCard: bankCard, withdrawAmmount: withdrawAmmount, fee: String(fee), doneTime: Date().string(withFormatter: "MM-dd HH:mm"))
                    let detail = WithdrawInprogressViewController(pageInfo: pageInfo)
                    detail.modalPresentationStyle = .custom
                    UIViewController.currentVisibleVC.nav_present(detail, animated: true)
                }
            }
        }else{
            Toast.make("请输入金额")
        }
    }
    
    func setupContent() {
        backgroundColor = .white
        corner(radius: 15, markedCorner: 3)
        
        subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        let topLeftMargin: CGFloat = 30
        
        let vStack = VStack()
        vStack.alignment = .leading
        let box1 = titleLabel.boxView(top: topLeftMargin, left: topLeftMargin)
        vStack.addArrangedSubview(box1)
        
        let hStack = HStack(spacing: 10)
        let symbolLabel = UILabel(title: "¥", font: .wx_moeny_font(35), textColor: .black, textAlignment: .left)
        hStack.addArrangedSubview(symbolLabel)
        hStack.addArrangedSubview(textField)
        hStack.alignment = .top
        textField.snp.makeConstraints { make in
            make.width.equalTo(CGFloat.width * 0.7)
            make.height.equalTo(50)
        }
        vStack.addArrangedSubview(hStack.boxView(top: 25, left: topLeftMargin))
        textField.becomeFirstResponder()
        textField.font = .wx_moeny_font(50)
        textField.tintColor = .C_wx_green
        //textField.inputView = MoneyTransferInputView()
        
        let line = UIView.line
        let lineBox = line.boxView(top: 10, left: topLeftMargin, right: topLeftMargin)
        line.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.line)
            make.left.equalTo(topLeftMargin)
            make.width.equalTo(CGFloat.width - 2*topLeftMargin)
        }
        vStack.addArrangedSubview(lineBox)
        
        addSubview(vStack)
        addSubview(totalMoneyLabel)
        addSubview(actionBtn)
        
        vStack.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        totalMoneyLabel.text = "当前零钱余额\(chaegesAmmount.toMoneyString)元,"
        totalMoneyLabel.snp.makeConstraints { make in
            make.left.equalTo(topLeftMargin)
            make.top.equalTo(vStack.snp.bottom).offset(20)
            make.bottom.lessThanOrEqualToSuperview().offset(-topLeftMargin)
        }
    
        actionBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        actionBtn.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        actionBtn.snp.makeConstraints { make in
            make.left.equalTo(totalMoneyLabel.snp.right).offset(5)
            make.centerY.equalTo(totalMoneyLabel)
            make.right.lessThanOrEqualToSuperview().offset(-topLeftMargin)
        }
        actionBtn.addTap { [weak self] sender in
            guard let self = self else { return }
            self.textField.text = self.chaegesAmmount.toMoneyString
        }
    }
}
