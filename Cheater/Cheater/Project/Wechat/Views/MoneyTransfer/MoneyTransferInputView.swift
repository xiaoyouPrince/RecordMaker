//
//  MoneyTransferInputView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/24.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 一个自定义的微信转账时候的数字键盘
 * 参考微信转账页面键盘
 */

import UIKit

class MoneyTransferInputView: UIView {
    
    let line = UIView.line
    /// 规则同tv.   “\n” 是确定, “”是删除
    var callback: ((String)->())?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(line)
        backgroundColor = .C_wx_keyboard_bgcolor
        
        let margin: CGFloat = 8
        let clunm = 4
        let width = (CGFloat.width - CGFloat((clunm + 1))*margin) / CGFloat(clunm)
        let height: CGFloat = 50
        let keys = keys
        
        for (index, key) in keys.enumerated() {
            if key == "" { continue}
            
            let c: CGFloat = CGFloat(index % clunm)
            let r: CGFloat = CGFloat(index / clunm)
            
            let btn = UIButton(type: .system)
            btn.setTitle(key, for: .normal)
            btn.backgroundColor = .white
            btn.setTitleColor(.C_000000, for: .normal)
            btn.titleLabel?.font = .wx_moeny_font(22)
            btn.corner(radius: 5)
            addSubview(btn)
            btn.snp.makeConstraints { make in
                make.left.equalTo((margin + width)*c + margin)
                make.top.equalTo((margin + height)*r + margin)
            
                if key == "0" {
                    make.width.equalTo(width*2 + margin)
                }else{
                    make.width.equalTo(width)
                }
                
                if key == "ok" {
                    make.height.equalTo(height*3 + 2*margin)
                }else {
                    make.height.equalTo(height)
                }
            }
            
            if key == "delete" {
                btn.setImage(UIImage(named: "deleteNum")?.withRenderingMode(.alwaysOriginal), for: .normal)
                btn.setTitle("", for: .normal)
            }
            
            if key == "ok" {
                btn.setTitle("转账", for: .normal)
                btn.backgroundColor = WXConfig.wxGreen
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
            }
            
            btn.addTap { [weak self] sender in
                guard let self = self, let btn = sender as? UIButton else { return }
                
                if btn.currentTitle == "转账" {
                    self.callback?("\n")
                }else
                if btn.currentTitle == "delete" {
                    self.callback?("")
                }else{
                    self.callback?(btn.currentTitle ?? "")
                }
            }
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo((margin + height) * 4 + CGFloat.safeBottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MoneyTransferInputView {
    var keys: [String] {
        ["1", "2", "3", "delete",
         "4", "5", "6", "ok",
         "7", "8", "9", "",
         "0", "", ".",  ""
        ]
    }
}
