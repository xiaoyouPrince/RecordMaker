//
//  WXChargesWithdrawController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/29.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 零钱提现页面
 */

import UIKit
import XYUIKit
import XYInfomationSection

class WXChargesWithdrawController: XYInfomationBaseViewController {
    
    let bankView = WithdrawBankView()
    let inputMoneyView = WithdrawContentInputView()
    var chaegesAmmount: String = "20.00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .C_wx_navbar_viewbgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.delegate = self
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        set{}
        get{.custom}
    }
}

extension WXChargesWithdrawController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let hideNavBottomLine = scrollView.contentOffset.y < (-CGFloat.naviBar + 8)
        nav_hideBarBottomLine(hideNavBottomLine)
        
        inputMoneyView.findSubViewRecursion { subV in
            if subV is UITextField {
                subV.resignFirstResponder()
                return true
            }
            return false
        }
    }
}

extension WXChargesWithdrawController {
    
    func buildUI() {
        setupNav()
        setupContent()
    }
    
    func setupNav() {
        navigationController?.navigationBar.barTintColor = .C_wx_navbar_viewbgColor
        nav_hideBarBottomLine()
        navigationItem.leftBarButtonItem = .xy_item(withTarget: self, action: #selector(leftBtnClick), image: .nav_close)
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(rightBtnClick), image: .wx_right_3dot, imageEdgeInsets: .zero)
    }
    
    @objc func leftBtnClick() {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnClick() {
        // 进入编辑
//        let detail = WithdrawEditViewController()
//        nav_push(detail, animated: true)
//        detail.callback = {[weak self] allParams in
//            guard let self = self else { return }
//            print(allParams)
//        }
        
        guard let bankCard = bankView.currentBankCard else { return }
        guard let doneTime = bankView.doneTime else { return }
        let rate = "0.1%"
        
        let items: [EditItem] = [
            .init(title: "银行", key: "1", value: bankCard.bank.title),
            .init(title: "银行卡号", key: "2", value: bankCard.cardNumber),
            .init(title: "提现到账时间", key: "3", value: doneTime),
            .init(title: "零钱余额", key: "4", value: chaegesAmmount),
            .init(title: "提现费率(%)", key: "5", value: rate)
        ]
        self.pushEditVC(items) {[weak self] params in
            guard let self = self else {return}
            let cardTitle = params["1"] as? String ?? ""
            let cardNum = params["2"] as? String ?? ""
            let doneTime = params["3"] as? String ?? ""
            self.chaegesAmmount = params["4"] as? String ?? ""
            let rate = params["5"] as? String ?? ""
            
            // bankView update
            if let bank = BankTool.bankWithName(cardTitle) {
                self.bankView.currentBankCard = BankTool.BankCard(bank: bank, cardNumber: cardNum)
                self.bankView.doneTime = doneTime
            }
            
            // inputView update
            self.inputMoneyView.update(moneyAmmount: self.chaegesAmmount, rate: rate, bankCard: self.bankView.currentBankCard)
        }
    }
    
    func setupContent() {
        view.backgroundColor = .white
        
        bankView.backgroundColor = .C_wx_navbar_viewbgColor
        setHeaderView(bankView, edgeInsets: .zero)
        setContentView(inputMoneyView, edgeInsets: .zero)
        inputMoneyView.chaegesAmmount = chaegesAmmount
        let footer = UIView()
        footer.backgroundColor = .white
        setFooterView(footer, edgeInsets: .init(top: 0, left: 0, bottom: -800, right: 0))
        
        bankView.addTap {[weak self] sender in
            self?.rightBtnClick()
        }
        
        self.inputMoneyView.update(bankCard: bankView.currentBankCard)
    }
    
}

extension WXChargesWithdrawController {
    
    func loadData() {
        // refreshUI
    }
    
}
