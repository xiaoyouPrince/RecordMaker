//
//  WithdrawBankView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/29.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 零钱提现页面中间部分 View
 *
 *  title + textField + line + tip + btn
 */


import UIKit
import XYUIKit

class WithdrawBankView: UIView {
    private let toBankLabel = UILabel(title: "到帐银行卡", font: .systemFont(ofSize: 16), textColor: .black, textAlignment: .left)
    private let iconView = UIImageView()
    private let titleLabel = UILabel(title: "建设银行", font: .boldSystemFont(ofSize: 16), textColor: .black, textAlignment: .left)
    private let tipLabel = UILabel(title: "2小时内到帐", font: .systemFont(ofSize: 16), textColor: .C_wx_tip_text, textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        
        if let bank = BankTool.bankWithName("建设银行") {
            let bankCard = BankTool.BankCard(bank: bank, cardNumber: "8899")
            setup(bankIcon: bank.image, bankTitle: bank.title, cardNum: bankCard.cardNumber)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(bankIcon: UIImage, bankTitle: String, cardNum: String) {
        iconView.image = bankIcon
        titleLabel.text = bankTitle + "(\(cardNum))"
    }
    
    private func setupContent() {
        addSubview(toBankLabel)
        addSubview(tipLabel)
        addSubview(iconView)
        addSubview(titleLabel)
        
        toBankLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(40)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(toBankLabel.snp.right).offset(30)
            make.centerY.equalTo(toBankLabel)
            make.width.height.equalTo(17)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(6)
            make.centerY.equalTo(toBankLabel)
        }
        
        let rightArraw = UIImageView(image: .wx_right_arraw?.withRenderingMode(.alwaysTemplate))
        rightArraw.tintColor = .C_wx_tip_text
        addSubview(rightArraw)
        rightArraw.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.centerY.equalTo(iconView)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}
