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
        buildHeader()
        buildContent()
    }
    
    func buildNav() {
        setNavbarWechat()
        nav_hideBarBottomLine()
        nav_setCustom(backImage: .wx_backImag)
    }
    
    func buildHeader() {
        view.addSubview(header)
        header.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(CGFloat.naviBar)
        })
        header.setModel(userInfo: WXUserInfo.shared)
    }
    
    func buildContent() {
        view.addSubview(content)
        content.backgroundColor = .white
        content.corner(radius: 15)
        content.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(15)
        }
        
        content.callback = { // 用户输入完成回调, 这里创建 转账模型
            [weak self] in
            guard let self = self else { return }
            
            let model = MsgMoneyTransferModel()
            model.amountOfMoney = self.content.moneyString
            model.transferInstructions = self.content.transferInstructions
            self.callback?(model)
            self.cancelClick()
        }
    }
    
    @objc func cancelClick() {
        navigationController?.popViewController(animated: true)
    }
}
