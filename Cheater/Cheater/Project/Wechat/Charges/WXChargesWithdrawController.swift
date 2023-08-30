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
        let items: [EditItem] = [
//            .init(title: "昵称", key: "senderName", value: model.senderName),
//            .init(title: "头像", key: "senderIcon", image: model.senderIcon ?? .init()),
//            .init(title: "备注", key: "tipString", value: model.tipString),
//            .init(title: "金额", key: "moneyAmount", value: model.moneyAmount)
        ]
        self.pushEditVC(items) {[weak self] params in
            guard let self = self else {return}
//            guard let model = self.model else {return}
//            model.senderName = params["senderName"] as? String
//            model.senderIcon = params["senderIcon"] as? UIImage
//            model.tipString = params["tipString"] as? String
//            model.moneyAmount = params["moneyAmount"] as? String
//            self.senderView.setup(with: model)
        }
    }
    
    func setupContent() {
        view.backgroundColor = .white
        
        bankView.backgroundColor = .C_wx_navbar_viewbgColor
        setHeaderView(bankView, edgeInsets: .zero)
        setContentView(inputMoneyView, edgeInsets: .zero)
        let footer = UIView()
        footer.backgroundColor = .white
        setFooterView(footer, edgeInsets: .init(top: 0, left: 0, bottom: -800, right: 0))
    }
    
}

extension WXChargesWithdrawController {
    
    func loadData() {
        // refreshUI
    }
    
}
