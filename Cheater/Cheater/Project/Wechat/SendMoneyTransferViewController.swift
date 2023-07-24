//
//  SendMoneyTransfertViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/17.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 发转账编辑页面
 */

import UIKit
import XYUIKit
import XYInfomationSection

class SendMoneyTransfertViewController: XYInfomationBaseViewController {
    
    let header = MoneyTransferHeader()
    let content = MoneyTransferContentView()
    var callback:((MsgMoneyTransferModel)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WXConfig.navBarBgColor

        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        content.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        content.end()
    }
}

private extension SendMoneyTransfertViewController {
    
    func buildUI() {
        buildNav()
        
        view.addSubview(header)
        header.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(CGFloat.naviBar)
        })
        header.setModel(userInfo: WXUserInfo.shared)
        
        view.addSubview(content)
        content.backgroundColor = .white
        content.corner(radius: 15)
        content.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(15)
        }
    }
    
    func buildNav() {
        
        setNavbarWechat()
        nav_hideBarBottomLine()
        nav_setCustom(backImage: .wx_backImag)
    }
    
    @objc func cancelClick() {
        navigationController?.popViewController(animated: true)
    }
}
