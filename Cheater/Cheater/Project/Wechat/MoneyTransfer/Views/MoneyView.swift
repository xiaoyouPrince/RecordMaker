//
//  MoneyView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/22.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 一个金额的金额view
 *
 *  egg:
 *  ¥100.00
 */

import UIKit

class MoneyView: UIView {
    private var yuanLabel = UILabel()
    private var moneyLabel = UILabel()
    var moneyStr: String {
        set{ moneyLabel.text = newValue.toMoneyString }
        get{ moneyLabel.text ?? "" }
    }
    
    /// 初始化一个 moneyView, 内部使用 autolayout ,自适应 size
    /// - Parameters:
    ///   - moneyStr: money 数额字符串
    ///   - scale: 在默认布局的size上基础上等比例缩放
    init(with moneyStr: String, scale: CGFloat = 1.0) {
        super.init(frame: .zero)
        
        setupContentView()
        self.moneyStr = moneyStr
        
        transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MoneyView {
    func setupContentView() {
        addSubview(yuanLabel)
        addSubview(moneyLabel)
        
        yuanLabel.text = "¥"
        yuanLabel.textColor = .C_000000
        yuanLabel.font = .wx_moeny_font(35)
        yuanLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        yuanLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        moneyLabel.font = .wx_moeny_font(50)
        moneyLabel.textColor = .C_000000
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(yuanLabel).offset(-2.5)
            make.left.equalTo(yuanLabel.snp.right).offset(8)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
