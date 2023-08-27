//
//  SendRedpacketViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/17.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 发红包编辑页面
 */

import UIKit
import XYUIKit
import XYInfomationSection

class SendRedpacketViewController: XYInfomationBaseViewController {
    
    weak var moneyTF: UITextField?
    weak var greetingTF: UITextField?
    weak var moneyView: MoneyView?
    var callback:((MsgRedPacketModel)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WXConfig.navBarBgColor

        scrollView.delegate = self
        buildUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        set{}
        get{.custom}
    }
}

extension SendRedpacketViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.moneyTF?.resignFirstResponder()
        self.greetingTF?.resignFirstResponder()
    }
}

private extension SendRedpacketViewController {
    
    func buildUI() {
        buildNav()
        
        setHeaderView(createTopView(), edgeInsets: .init(top: 8, left: 16, bottom: 10, right: 16))
        setContentView(createContentView(), edgeInsets: .init(top: 20, left: 0, bottom: 0, right: 0))
        setFooterView(createFooterView(), edgeInsets: .init(top: 10, left: 40, bottom: 0, right: 40))
        
        addTipLabel()
    }
    
    func buildNav() {
        title = "发红包"
        setNavbarWechat()
        nav_hideBarBottomLine()
            
        navigationItem.leftBarButtonItem = .xy_item(withTarget: self, action: #selector(cancelClick), title: "取消", font: UIFont.boldSystemFont(ofSize: 15), titleColor: .C_000000, highlightedColor: .C_222222, titleEdgeInsets: .init(top: 0, left: -10, bottom: 0, right: 10))
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(cancelClick), image: UIImage.wx_right_3dot, imageEdgeInsets: .init(top: 0, left: 10, bottom: 0, right: -10))
    }
    
    func createTopView() -> UIView {
        let topVoew = UIView()
        
        let moneyView = UIView()
        let titleLabel = UILabel(title: "金额", font: .boldSystemFont(ofSize: 16), textColor: .C_222222, textAlignment: .left)
        let tf = UITextField()
        self.moneyTF = tf
        let yuanLabel = UILabel(title: "元", font: .boldSystemFont(ofSize: 16), textColor: .C_222222, textAlignment: .right)
        
        topVoew.addSubview(moneyView)
        moneyView.addSubview(titleLabel)
        moneyView.addSubview(tf)
        moneyView.addSubview(yuanLabel)
        
        moneyView.corner(radius: 5)
        moneyView.backgroundColor = .white
        moneyView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.left.top.right.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(titleLabel.intrinsicContentSize.width)
            make.height.equalTo(titleLabel.intrinsicContentSize.height)
        }
        
        yuanLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        yuanLabel.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        
        tf.textAlignment = .right
        tf.keyboardType = .decimalPad
        tf.font = .systemFont(ofSize: 17)
        tf.textColor = .C_000000
        tf.placeholder = "0.00"
        tf.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(yuanLabel.snp.left).offset(-5)
            make.left.equalTo(titleLabel.snp.right).offset(5)
        }
        
        //  -- greeting tf
        let gBGView = UIView()
        let gTF = UITextField()
        topVoew.addSubview(gBGView)
        gBGView.addSubview(gTF)
        
        gBGView.corner(radius: 5)
        gBGView.backgroundColor = .C_FFFFFF
        gBGView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(moneyView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        self.greetingTF = gTF
        gTF.placeholder = "恭喜发财,大吉大利"
        gTF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        return topVoew
    }
    
    func createContentView() -> UIView {
        let contentView = UIView()
        let moneyView = MoneyView(with: "0.00", scale: 1.1)
        self.moneyView = moneyView
        contentView.addSubview(moneyView)
        moneyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        return contentView
    }
    
    func createFooterView() -> UIView {
        let footer = UIButton(type: .system)
        footer.setTitle("塞钱进红包", for: .normal)
        footer.setTitleColor(.white, for: .normal)
        footer.titleLabel?.font = .boldSystemFont(ofSize: 17)
        footer.corner(radius: 5)
        footer.backgroundColor = .C_wx_red_button
        footer.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        footer.addTap {[weak self] sender in
            guard let self = self else { return }
            if let money = self.moneyView?.moneyStr, money != "0.00" {
                if let callback = self.callback {
                    // 从聊天发红包进入
                    let model = MsgRedPacketModel()
                    model.amountOfMoney = money
                    model.sayingWords = self.greetingTF?.text
                    callback(model)
                    self.cancelClick()
                }else{
                    // 从首页进来,展示功能
                    self.showMenuSheet()
                }
            }else{
                Toast.make("请输入正确金额")
            }
        }
        
        return footer
    }
    
    func addTipLabel() {
        let tipLabel = UILabel(title: "可直接使用收到的零钱发红包", font: .systemFont(ofSize: 16), textColor: .C_wx_tip_text, textAlignment: .center)
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(CGFloat.safeBottom + 30))
        }
    }
    
    @objc func textFieldTextDidChange(_ noti: Notification){
        
        guard let tf = noti.object as? UITextField else {
            return
        }
        
        if tf == self.moneyTF {
            //Toast.make("tf.text = \(String(describing: tf.text))")
            //let doubleValue = tf.text?.doubleValue
            //let str = String(format: "%.2f", doubleValue!)
            self.moneyView?.moneyStr = tf.text ?? ""
        }
    }
    
    @objc func cancelClick() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}

extension SendRedpacketViewController {
    
    func getModel() -> RedPacketBaseViewController.RedPacketModel {
        let model = RedPacketBaseViewController.RedPacketModel.init()
        model.moneyAmount = moneyView?.moneyStr
        if let tipText = greetingTF?.text, tipText.isEmpty {
            model.tipString = greetingTF?.placeholder ?? ""
        }else{
            model.tipString = greetingTF?.text
        }
        
        let contact = WXContact.random
        model.receiverIcon = contact.image
        model.receiverName = contact.realName
        
        return model
    }
    
    func showMenuSheet() {
        let actions: [String] = [
            "待对方领取",
            "对方已领取",
            "我已领取",
            "返回上一页"
        ]
        AlertSheetController.showDefault(on: self, title: nil, subTitle: nil, actions: actions) { index in
            if index == 0 {
                let detail = RPWaitReceiveController()
                detail.model = self.getModel()
                self.nav_push(detail, animated: true)
            } else if index == 1 {
                let detail = RPTargetHasReceivedController()
                detail.model = self.getModel()
                detail.model?.hasReceived =  true
                self.nav_push(detail, animated: true)
            } else if index == 2 {
                let detail = RPMeHasReceivedController()
                detail.model = self.getModel()
                detail.model?.hasReceivedByMe =  true
                self.nav_push(detail, animated: true)
            } else if index == 3 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
