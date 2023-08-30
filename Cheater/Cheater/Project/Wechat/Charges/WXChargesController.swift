//
//  WXChargesController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/29.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 微信零钱页面
 */

import UIKit
import XYUIKit
import XYInfomationSection

class WXChargesController: XYInfomationBaseViewController {
    
    /// 金钱数字 view
    private var moenyView: MoneyView = .init(with: "")
    /// 零钱通 label
    private var lqtLabel: UILabel = .init()
    /// 底部功能 label
    private var linkLabel: UILabel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        loadData()
    }
    
}

extension WXChargesController {
    
    func buildUI() {
        setupNav()
        setupContent()
    }
    
    func setupNav() {
        navigationItem.title = ""
        nav_hideBarBottomLine()
        nav_setCustom(backImage: .wx_backImag)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(rightBtnClick), title: "零钱明细", font: .systemFont(ofSize: 18), titleColor: .black, highlightedColor: nil, titleEdgeInsets: .init(top: 0, left: 5, bottom: 0, right: -5))
        
    }
    
    @objc func rightBtnClick() {
        gotoChargesDetailVC()
    }
    
    func setupContent() {
        view.backgroundColor = .white
        let gotoEditCallback: (UIView)->() = {[weak self] sender in
            guard let self = self else { return }
            self.gotoEditVC()
        }
        
        let vstack = VStack.init(frame: .zero)
        
        // -
        let iconView = UIImageView(named: "a-wallet-detail-new-icon1")
        vstack.addArrangedSubview(iconView.boxView(top: 70 ))
        
        // -
        let titlteBox = BoxView(withTitle: "我的零钱", edgeInsets: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        vstack.addArrangedSubview(titlteBox)
        titlteBox.addTap(callback: gotoEditCallback)
        
        // -
        let moneyView = MoneyView(with: "100.00")
        let moneyBox = BoxView(with: moneyView, edgeInsets: .init(top: 30, left: 0, bottom: 0, right: 0))
        vstack.addArrangedSubview(moneyBox)
        self.moenyView = moneyView
        moneyBox.addTap(callback: gotoEditCallback)
        
        // -
        let shouyiLabel = UILabel(title: "转入零钱通赚收益 七年年化率2.51%", font: .systemFont(ofSize: 17), textColor: .orange, textAlignment: .center)
        let rightArraw = UIImageView(image: .wx_right_arraw?.withRenderingMode(.alwaysTemplate))
        rightArraw.tintColor = shouyiLabel.textColor
        let hStack = HStack(spacing: 5)
        hStack.addArrangedSubview(shouyiLabel)
        hStack.addArrangedSubview(rightArraw)
        vstack.addArrangedSubview(BoxView(with: hStack, edgeInsets: .init(top: 30, left: 0, bottom: 0, right: 0)))
        hStack.addTap(callback: gotoEditCallback)
        self.lqtLabel = shouyiLabel
        
        // -
        let chongzhiLabel = UILabel(title: "充值", font: .systemFont(ofSize: 20), textColor: .white, textAlignment: .center)
        let chongzhiBox = BoxView(with: chongzhiLabel, edgeInsets: .init(top: 15, left: 80, bottom: 15, right: 80))
        chongzhiBox.backgroundColor = .C_wx_green
        chongzhiBox.corner(radius: 5)
        let tixianLabel = UILabel(title: "提现", font: .systemFont(ofSize: 20), textColor: .C_wx_green, textAlignment: .center)
        let tixianBox = BoxView(with: tixianLabel, edgeInsets: .init(top: 15, left: 80, bottom: 15, right: 80))
        tixianBox.backgroundColor = .gray.withAlphaComponent(0.1)
        tixianBox.corner(radius: 5)
        vstack.addArrangedSubview(chongzhiBox.boxView(top: CGFloat.getRealValue(value: 150)))
        vstack.addArrangedSubview(tixianBox.boxView(top: 15))
        chongzhiBox.addTap(callback: gotoEditCallback)
        tixianBox.addTap { [weak self] sender in
            guard let self = self else { return }
            self.gotoWithdrawVC()
        }
        
        // -
        let linkLabel = UILabel(title: "常见问题 | 账户升级服务", font: .systemFont(ofSize: 15), textColor: .C_wx_link_text, textAlignment: .center)
        let serverLabel = UILabel(title: "本服务由财付通提供", font: .systemFont(ofSize: 12), textColor: .C_wx_tip_text, textAlignment: .center)
        vstack.addArrangedSubview(linkLabel.boxView(top: CGFloat.getRealValue(value: 70)))
        vstack.addArrangedSubview(serverLabel.boxView(top: 15, bottom: CGFloat.getRealValue(value: 20)))
        self.linkLabel = linkLabel
        
        setContentView(vstack, edgeInsets: .zero)
    }
    
}

extension WXChargesController {
    
    /// 进入编辑页面
    func gotoEditVC() {
        let items: [EditItem] = [
            .init(title: "我的零钱", key: "moneyAmount", value: moenyView.moneyStr),
            .init(title: "显示零钱通", key: "showLqt", value: (!lqtLabel.isHidden).stringValue, type: .switch),
            .init(title: "零钱通文字", key: "LqtString", value: lqtLabel.text),
            .init(title: "隐藏底部账户升级服务文字", key: "hideServer", value: (!(linkLabel.text?.contains("账户升级服务") ?? false)).stringValue, type: .switch)
        ]
        self.pushEditVC(items) {[weak self] params in
            guard let self = self else {return}
            
            let moneyAmount = params["moneyAmount"] as? String
            let showLqt = (params["showLqt"] as? String)?.boolValue ?? true
            let LqtString = params["LqtString"] as? String
            let hideServer = (params["hideServer"] as? String)?.boolValue
            
            self.moenyView.moneyStr = moneyAmount ?? ""
            self.lqtLabel.superview?.isHidden = !showLqt
            if let lqtStack = self.lqtLabel.superview {
                lqtStack.subviews.forEach { subV in
                    subV.isHidden = !showLqt
                }
            }
            self.lqtLabel.text = LqtString
            if hideServer == false {
                self.linkLabel.text = "常见问题 | 账户升级服务"
            }else{
                self.linkLabel.text = "常见问题"
            }
        }
    }
    
    /// 进入零钱明细页面
    func gotoChargesDetailVC() {
        Toast.make("零钱明细,待开发")
    }
    
    /// 进入提现页面
    func gotoWithdrawVC() {
        nav_present(WXChargesWithdrawController(), animated: true)
    }
    
    func loadData() {
        // refreshUI
    }
}
