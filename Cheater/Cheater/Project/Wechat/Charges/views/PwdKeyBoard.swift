//
//  PwdKeyBoard.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/30.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 密码键盘 -
 * 参考转账页面 - 输入密码页面 / 提现输入密码页面
 */

import UIKit

class PwdKeyBoard: UIView {
    private var callback: (_ key: String) -> ()
    
    /// 初始化一个键盘
    /// - Parameter callback: 按键点击回调, key 是每个键的 String, 删除为 delete
    init(callback: @escaping (_ key: String) -> ()) {
        self.callback = callback
        super.init(frame: .zero)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        // 键盘
        let keyBdHeight: CGFloat = 0 // 可以给 top 提供一个预留空间
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
            
            let btn = UIButton(type: .system)
            btn.tag = index
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
                
                if index == (keys.count - 1){
                    make.bottom.equalToSuperview()
                }
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
        
        self.bounds.size.height = keyBdHeight + CGFloat(height) * 4 + 4*CGFloat.line
    }
}

private extension PwdKeyBoard {
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
        let index = sender.tag
        let key = TheKeys[index]
        callback(key)
    }
}
