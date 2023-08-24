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
    /// 是否是从首页直接进入的
    var isFromHome: Bool = false
    private var mtModel: MTModel = .init()
    
    let header = MoneyTransferHeader()
    let content = MoneyTransferContentView()
    var callback:((MsgMoneyTransferModel)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WXConfig.navBarBgColor

        buildUI()
        
        if isFromHome == true { // if is push from home page
            content.transferBtnCallback = { [weak self] in
                guard let self = self else { return }
                self.showTransferResultMenu()
            }
            
            // 本页面专属转账对象
            setHeaderWhenIsBeingPresnted()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        content.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        content.end()
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        set{}
        get{.custom}
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
        if let currentUserBeingSpoken = DataSource_wxDetail.currentUserBeingSpoken {
            header.setModel(userInfo: currentUserBeingSpoken.userInfo)
        }
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
        
        content.callback = { // 用户输入完成回调, 这里创建 转账模型 - this is default action
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
        dismiss(animated: true)
    }
}

// MARK: - 单独 push 进入此页面的特殊操作

extension SendMoneyTransfertViewController {
    override var isBeingPresented: Bool {
        if navigationController == nil {
            return super.isBeingPresented
        }else{
            for res in responderChain {
                if let vc = res as? UIViewController, vc != self, vc.isBeingPresented == true {
                    return true
                }
            }
            return false
        }
    }
    
    func setHeaderWhenIsBeingPresnted() {
        if let mtModel: MTModel = XYFileManager.readFile(with: "mt_file").first {
            self.mtModel = mtModel
            content.updateTransferInstructions(mtModel.transferDesc ?? "")
            header.setModel(model: mtModel) { [weak self] in
                guard let self = self else { return }
                //print("header - click")
                
                let detail = EditMoneyTransferController2()
                self.push(detail, animated: true)
                detail.setModel(model: mtModel) {[weak self] mtModel in
                    guard let self = self else { return }
                    // update UI
                    self.header.setModel(model: mtModel)
                    self.content.updateTransferInstructions(mtModel.transferDesc ?? "")
                    
                    // update data
                    XYFileManager.writeFile(with: "mt_file", models: [mtModel])
                }
            }
        }else{
            let userInfo = WXUserInfo.shared
            let mtModel = MTModel()
            mtModel.name = userInfo.name
            mtModel.iconName = userInfo.iconName
            mtModel.realName = userInfo.realName
            mtModel.wechatId = userInfo.wechatId
            XYFileManager.writeFile(with: "mt_file", models: [mtModel])
            setHeaderWhenIsBeingPresnted()
        }
    }
    
    /// 转账按钮点击后,自定义操作,展示结果页面
    func showTransferResultMenu() {
        let actionTitles = [
            "转账成功(更多7个页面)",
            "扫码转账成功(个人)",
            "扫码转账成功(商户)",
            "转账限额"]
        XYAlertSheetController.showDefault(on: self, title: nil, subTitle: nil, actions: actionTitles) { index in
            if index == 0 {
                self.showDetailResultPage()
            } else if index == 1 {
                let detail = MTSuccessViewController()
                self.push(detail, animated: true)
                detail.isPersonal = true
                detail.mtModel = self.getCurrentMTModel()
            } else if index == 2 {
                let detail = MTSuccessViewController()
                self.push(detail, animated: true)
                detail.isMerchant = true
                detail.mtModel = self.getCurrentMTModel()
            } else if index == 3 {
                AlertController.showAlert(title: "", message: self.mtModel.transferLimitTip ?? "", btnTitles: "确定", "查看解决办法") { index in
                    if index == 1 {
                        let detail = EditMoneyTransferController2()
                        self.push(detail, animated: true)
                        detail.setModel(model: self.mtModel) {[weak self] mtModel in
                            guard let self = self else { return }
                            // update UI
                            self.header.setModel(model: mtModel)
                            self.content.updateTransferInstructions(mtModel.transferDesc ?? "")
                            
                            // update data
                            XYFileManager.writeFile(with: "mt_file", models: [mtModel])
                        }
                    }
                }
            }
        }
    }
    
    /// 展示具体的子页面
    func showDetailResultPage() {
        let actionTitles = [
            "付款成功页面",
            "待对方确认收款",
            "对方已收款",
            "待我确认收款",
            "我已收款",
            "我已退还",
            "对方已退还"]
        XYAlertSheetController.showDefault(on: self, title: nil, subTitle: nil, actions: actionTitles) { index in
            if index == 0 {
                let detail = MTSuccessViewController()
                self.push(detail, animated: true)
                detail.mtModel = self.getCurrentMTModel()
            } else if index == 1 {
                let detail = MTWaitTargetReceiveController()
                self.push(detail, animated: true)
                detail.mtModel = self.getCurrentMTModel()
            } else if index == 2 {
                let detail = MTTargetReceivedController()
                self.push(detail, animated: true)
                detail.mtModel = self.getCurrentMTModel()
            } else if index == 3 {
                let detail = MTWaitMeReceiveController()
                self.push(detail, animated: true)
                detail.mtModel = self.getCurrentMTModel()
            } else if index == 4 {
                let detail = MTMeReceivedController()
                self.push(detail, animated: true)
                detail.mtModel = self.getCurrentMTModel()
            } else if index == 5 {
                let detail = MTAlreadySendBackController()
                self.push(detail, animated: true)
                detail.mtModel = self.getCurrentMTModel()
            } else if index == 6 {
                let detail = MTAlreadySendBackController()
                detail.isFromTarget = true
                self.push(detail, animated: true)
                detail.mtModel = self.getCurrentMTModel()
            }
        }
    }
    
    func getCurrentMTModel() -> MTModel {
        mtModel.moneyAmount = content.moneyFloatString
        mtModel.transferDesc = content.transferInstructions
        mtModel.time = TimeTool.fullTime(from: .since1970)
        mtModel.receiveTime = TimeTool.fullTime(from: .since1970 + 2)
        return mtModel
    }
}
