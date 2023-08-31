//
//  WithdrawInputPwdController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/30.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 零钱提现页面 - 最后一步输入密码页面
 *
 *  1. infoBox
 *  2. keyBoard
 */

import UIKit
import XYUIKit
import XYInfomationSection

class WithdrawInputPwdController: UIViewController {
    var infoBox: WithdrawInputPwdView?
    var keyBoard: UIView? //PwdKeyBoard?
    private var moneyAmmount: String
    private var rate: String
    var callback:(()->())?
    
    init(infoBox: WithdrawInputPwdView? = nil, keyBoard: UIView? = nil, moneyAmmount: String, rate: String) {
        self.infoBox = infoBox
        self.keyBoard = keyBoard
        self.moneyAmmount = moneyAmmount
        self.rate = rate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        loadData()
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle{
        set{}
        get{.custom}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .clear
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = .black.withAlphaComponent(0.25)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.15) {
            self.infoBox?.isHidden = false
            self.keyBoard?.transform = CGAffineTransform(translationX: 0, y: -(self.keyBoard?.bounds.size.height ?? 300))
        }
    }
}

extension WithdrawInputPwdController {
    
    func buildUI() {
        setupNav()
        setupContent()
    }
    
    func setupNav() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupContent() {
        infoBox = .init(moneyAmmount: moneyAmmount, rate: rate, doneCallBack: {[weak self] in
            guard let self = self else { return }
            self.gotoWithdrawSuccessPage()
        })
        infoBox?.corner(radius: 15)
        view.addSubview(infoBox!)
        infoBox?.snp.makeConstraints { make in
            make.left.equalTo(33)
            make.centerX.equalToSuperview()
            make.top.equalTo(CGFloat.naviBar + 57)
        }
        infoBox?.isHidden = true
        
        keyBoard = PwdKeyBoard.init(callback: { [weak self] key in
            guard let self = self else { return }
            self.infoBox?.updatePwd(key: key)
        }).boxView(bottom: CGFloat.safeBottom)
        keyBoard?.backgroundColor = .C_wx_keyboard_bgcolor
        view.addSubview(keyBoard!)
        keyBoard?.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }
    }
    
    func gotoWithdrawSuccessPage()  {
        
        WXPayHUD.show(1) {
            // dismiss pwd input view
            self.dismiss(animated: false) {
                // new page
                self.callback?()
            }
        }
    }
}

extension WithdrawInputPwdController {
    
    func loadData() {
        // refreshUI
    }
    
}
