//
//  MTWaitTargetReceiveController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/22.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

// 此文件有多个相关类,

// MARK: - 等对方确认收款页面

import UIKit

class MTWaitTargetReceiveController: MTBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        view.addTap {[weak self] sender in
            guard let self = self, let mtModel = self.mtModel else { return }
            
            let detail = EditBaseViewController()
            self.push(detail, animated: true)
            
            let items: [EditItem] = [
                .init(title: "转账金额", key: "moneyAmount", value: mtModel.moneyAmount ?? ""),
                .init(title: "收款用户", key: "name", value: mtModel.name ?? ""),
                .init(title: "转账时间", key: "time", value: mtModel.time ?? "")
            ]
            detail.setItems(items) {[weak self] params in
                guard let self = self else { return }
                
                self.mtModel?.moneyAmount = (params["moneyAmount"] as? String ?? "").toMoneyString
                self.mtModel?.name = params["name"] as? String
                self.mtModel?.time = params["time"] as? String
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        updateIcon(img: UIImage(named: "icon-wait") ?? .init())
        updateStatusLabel(text: "待\(mtModel?.name ?? "")确认收款")
        updateMoney(amount: mtModel?.moneyAmount ?? "")
        
        let attrStr = "一天内对方未收款,将退还给你.提醒对方收款".addAttributes(attrs: [.foregroundColor: UIColor.C_wx_link_text, .font: UIFont.boldSystemFont(ofSize: 14)], withRegx: "提醒对方收款")
        
        updateTipsLabel(attrStr: attrStr)
        
        if mtModel?.transferDesc?.isEmpty == true {
            updateSection(with: [
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any])
            ])
        }else{
            updateSection(with: [
                .model(withDict: ["title": "转账说明" as Any, "value": mtModel?.transferDesc as Any]),
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any]),
            ])
        }
        
    }
}

// MARK: - 对方确认收款页面

import UIKit

class MTTargetReceivedController: MTBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        view.addTap {[weak self] sender in
            guard let self = self, let mtModel = self.mtModel else { return }
            
            let detail = EditBaseViewController()
            self.push(detail, animated: true)
            
            let items: [EditItem] = [
                .init(title: "转账金额", key: "moneyAmount", value: mtModel.moneyAmount ?? ""),
                .init(title: "收款用户", key: "name", value: mtModel.name ?? ""),
                .init(title: "转账时间", key: "time", value: mtModel.time ?? ""),
                .init(title: "收款时间", key: "receiveTime", value: mtModel.receiveTime ?? ""),
            ]
            detail.setItems(items) {[weak self] params in
                guard let self = self else { return }
                
                self.mtModel?.moneyAmount = (params["moneyAmount"] as? String ?? "").toMoneyString
                self.mtModel?.name = params["name"] as? String
                self.mtModel?.time = params["time"] as? String
                self.mtModel?.receiveTime = params["receiveTime"] as? String
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        updateIcon(img: UIImage(named: "icon-finish") ?? .init())
        updateStatusLabel(text: "\(mtModel?.name ?? "")已收款")
        updateMoney(amount: mtModel?.moneyAmount ?? "")
        
        let attrStr = "已经存入对方零钱中".addAttributes(attrs: [.foregroundColor: UIColor.C_wx_tip_text, .font: UIFont.systemFont(ofSize: 14)])
        updateTipsLabel(attrStr: attrStr)
        
        if mtModel?.transferDesc?.isEmpty == true {
            updateSection(with: [
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any]),
                .model(withDict: ["title": "收款时间" as Any, "value": mtModel?.receiveTime as Any])
            ])
        }else{
            updateSection(with: [
                .model(withDict: ["title": "转账说明" as Any, "value": mtModel?.transferDesc as Any]),
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any]),
                .model(withDict: ["title": "收款时间" as Any, "value": mtModel?.receiveTime as Any])
            ])
        }
        
    }
}


// MARK: - 待我确认收款页面

import UIKit

class MTWaitMeReceiveController: MTBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        view.addTap {[weak self] sender in
            guard let self = self, let mtModel = self.mtModel else { return }
            
            let detail = EditBaseViewController()
            self.push(detail, animated: true)
            
            let items: [EditItem] = [
                .init(title: "转账金额", key: "moneyAmount", value: mtModel.moneyAmount ?? ""),
                .init(title: "转账时间", key: "time", value: mtModel.time ?? ""),
            ]
            detail.setItems(items) {[weak self] params in
                guard let self = self else { return }
                
                self.mtModel?.moneyAmount = (params["moneyAmount"] as? String ?? "").toMoneyString
                self.mtModel?.time = params["time"] as? String
                self.updateUI()
            }
        }
        
        let btnLabel = UILabel(title: "收款", font: .boldSystemFont(ofSize: 20), textColor: .white, textAlignment: .center)
        let attrStr = "一天内未确认,将退还给对方.退还".addAttributes(attrs: [.foregroundColor: UIColor.C_wx_link_text, .font: UIFont.boldSystemFont(ofSize: 15)], withRegx: "退还 ")
        let tipLabel = UILabel(title: "收款", font: .systemFont(ofSize: 14), textColor: .C_wx_tip_text, textAlignment: .center)
        tipLabel.attributedText = attrStr
        
        view.addSubview(tipLabel)
        view.addSubview(btnLabel)
        
        tipLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-CGFloat.safeBottom-30)
        }
        
        btnLabel.corner(radius: 8)
        btnLabel.backgroundColor = WXConfig.wxGreen
        btnLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.bottom.equalTo(tipLabel.snp.top).offset(-25)
        }
    }
    
    func updateUI() {
        updateIcon(img: UIImage(named: "icon-wait-new") ?? .init())
        updateStatusLabel(text: "待你收款")
        updateMoney(amount: mtModel?.moneyAmount ?? "")
        updateTipsLabel(attrStr: .init(string: ""))
        
        if mtModel?.transferDesc?.isEmpty == true {
            updateSection(with: [
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any])
            ])
        }else{
            updateSection(with: [
                .model(withDict: ["title": "转账说明" as Any, "value": mtModel?.transferDesc as Any]),
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any])
            ])
        }
        
    }
}


// MARK: - 我已经收款页面

import UIKit

class MTMeReceivedController: MTBaseViewController {
    static var show_lqt = "true"
    static var show_lqt_btn = "true"
    static var lqt_7daybouns = "1.99"
    static var lqt_title = "转入零钱通 省心赚收益"
    static var lqt_btn_title = "转入"
    static var tip_msg = "零钱余额"
    static var show_note = "true"
    static var note_title = "对此笔交易添加备注"
    static var show_deal_order = "true"
    
    class LingqianTongView: UIView {
        private var icon: UIImageView = UIImageView(image: UIImage(named: "trans-got-icon"))
        private var titleLabel: UILabel = UILabel(title: "零钱通 7日年化 \(MTMeReceivedController.lqt_7daybouns)%", font: .systemFont(ofSize: 13), textColor: .C_wx_tip_text, textAlignment: .left)
        private var detailLabel: UILabel = UILabel(title: MTMeReceivedController.lqt_title, font: .systemFont(ofSize: 16), textColor: .C_000000, textAlignment: .left)
        private var btnLabel: UILabel = UILabel(title: MTMeReceivedController.lqt_btn_title, font: .boldSystemFont(ofSize: 16), textColor: .C_FFFFFF, textAlignment: .center)
        
        override init(frame: CGRect) {
            super.init(frame: .zero)
            
            let topLine = UIView.line
            addSubview(topLine)
            topLine.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(CGFloat.line)
            }
            
            addSubview(icon)
            addSubview(titleLabel)
            addSubview(detailLabel)
            addSubview(btnLabel)
            
            icon.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalTo(20)
                make.bottom.equalTo(-20)
                make.width.height.equalTo(40)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(icon.snp.right).offset(8)
                make.top.equalTo(icon)
                make.right.equalTo(btnLabel.snp.left).offset(-10)
            }
            
            detailLabel.snp.makeConstraints { make in
                make.left.equalTo(icon.snp.right).offset(8)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.right.equalTo(btnLabel.snp.left).offset(-10)
            }
            
            btnLabel.corner(radius: 5)
            btnLabel.backgroundColor = WXConfig.wxGreen
            btnLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            btnLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            btnLabel.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.centerY.equalTo(icon)
                make.height.equalTo(btnLabel.intrinsicContentSize.height + 12)
                make.width.equalTo(btnLabel.intrinsicContentSize.width + 20)
            }
            
            let bottom = UIView.line
            addSubview(bottom)
            bottom.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(CGFloat.line)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func updateContent() {
            titleLabel.text = "零钱通 7日年化 \(MTMeReceivedController.lqt_7daybouns)%"
            btnLabel.isHidden = !MTMeReceivedController.show_lqt_btn.boolValue
            btnLabel.text = MTMeReceivedController.lqt_btn_title
            detailLabel.text =  MTMeReceivedController.lqt_title
            
            btnLabel.snp.updateConstraints { make in
                make.height.equalTo(btnLabel.intrinsicContentSize.height + 12)
                make.width.equalTo(btnLabel.intrinsicContentSize.width + 20)
            }
        }
    }
    
    var lingqiantongView = LingqianTongView()
    var noteLabel = UILabel(title: MTMeReceivedController.note_title, font: .boldSystemFont(ofSize: 13), textColor: .C_wx_link_text, textAlignment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customUI()
        updateUI()
        
        view.addTap {[weak self] sender in
            guard let self = self, let mtModel = self.mtModel else { return }
            
            let detail = EditBaseViewController()
            self.push(detail, animated: true)
            
            let items: [EditItem] = [
                .init(title: "转账金额", key: "moneyAmount", value: mtModel.moneyAmount ?? ""),
                .init(title: "提示信息", key: "tipMsg", value: MTMeReceivedController.tip_msg),
                .init(title: "转账时间", key: "time", value: mtModel.time ?? ""),
                .init(title: "收款时间", key: "receiveTime", value: mtModel.receiveTime ?? ""),
                .init(title: "显示零钱通", key: "show_lqt", value: MTMeReceivedController.show_lqt, type: .switch),
                .init(title: "零钱通文字", key: "lqt_title", value: MTMeReceivedController.lqt_title),
                .init(title: "显示零钱通按钮", key: "show_lqt_btn", value: MTMeReceivedController.show_lqt_btn, type: .switch),
                .init(title: "零钱通按钮文字", key: "lqt_btn_title", value: MTMeReceivedController.lqt_btn_title),
                .init(title: "7日年化率", key: "lqt_7daybouns", value: MTMeReceivedController.lqt_7daybouns),
                .init(title: "显示添加备注", key: "show_note", value: MTMeReceivedController.show_note, type: .switch),
                .init(title: "备注文字", key: "note_title", value: MTMeReceivedController.note_title),
                .init(title: "显示处理订单", key: "show_deal_order", value: MTMeReceivedController.show_deal_order, type: .switch),
            ]
            detail.setItems(items) {[weak self] params in
                guard let self = self else { return }
                
                self.mtModel?.moneyAmount = (params["moneyAmount"] as? String ?? "").toMoneyString
                self.mtModel?.time = params["time"] as? String
                self.mtModel?.receiveTime = params["receiveTime"] as? String
                
                MTMeReceivedController.tip_msg = params["tipMsg"] as? String ?? ""
                MTMeReceivedController.show_lqt = params["show_lqt"] as? String ?? ""
                MTMeReceivedController.show_lqt_btn = params["show_lqt_btn"] as? String ?? ""
                MTMeReceivedController.lqt_7daybouns = params["lqt_7daybouns"] as? String ?? ""
                MTMeReceivedController.lqt_title = params["lqt_title"] as? String ?? ""
                MTMeReceivedController.lqt_btn_title = params["lqt_btn_title"] as? String ?? ""
                MTMeReceivedController.note_title = params["note_title"] as? String ?? ""
                MTMeReceivedController.show_note = params["show_note"] as? String ?? ""
                MTMeReceivedController.show_deal_order = params["show_deal_order"] as? String ?? ""
                self.updateUI()
                self.updateCustomUI()
            }
        }
    }
    
    func updateUI() {
        updateIcon(img: UIImage(named: "icon-finish") ?? .init())
        updateStatusLabel(text: "待你收款")
        updateMoney(amount: mtModel?.moneyAmount ?? "")
        
        var tipText = "\(MTMeReceivedController.tip_msg)"
        if MTMeReceivedController.show_deal_order.boolValue {
            tipText.append(" | 处理订单")
        }
        let attrStr = tipText.addAttributes(attrs: [.foregroundColor: UIColor.C_wx_link_text, .font: UIFont.boldSystemFont(ofSize: 13)], withRegx: "[\(MTMeReceivedController.tip_msg) 处理订单]")
        updateTipsLabel(attrStr: attrStr)
        
        
        if mtModel?.transferDesc?.isEmpty == true {
            updateSection(with: [
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any]),
                .model(withDict: ["title": "收款时间" as Any, "value": mtModel?.receiveTime as Any])
            ])
        }else{
            updateSection(with: [
                .model(withDict: ["title": "转账说明" as Any, "value": mtModel?.transferDesc as Any]),
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any]),
                .model(withDict: ["title": "收款时间" as Any, "value": mtModel?.receiveTime as Any])
            ])
        }
        
    }
    
    /// 自定义当前页面
    func customUI() {
        if let last = view.subviews.last {
            view.addSubview(lingqiantongView)
            lingqiantongView.snp.makeConstraints { make in
                make.top.equalTo(last.snp.bottom)
                make.left.right.equalTo(last)
            }
            
            view.addSubview(noteLabel)
            noteLabel.numberOfLines = 0
            noteLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-CGFloat.safeBottom - CGFloat.statusBar)
                make.left.right.equalToSuperview()
            }
        }
    }
    
    func updateCustomUI() {
        lingqiantongView.isHidden = !MTMeReceivedController.show_lqt.boolValue
        lingqiantongView.updateContent()
        
        noteLabel.isHidden = !MTMeReceivedController.show_note.boolValue
        noteLabel.text = MTMeReceivedController.note_title
    }
}


// MARK: - 已经退还

import UIKit

class MTAlreadySendBackController: MTBaseViewController {
    /// 是否是对方退还
    var isFromTarget = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        view.addTap {[weak self] sender in
            guard let self = self, let mtModel = self.mtModel else { return }
            
            let detail = EditBaseViewController()
            self.push(detail, animated: true)
            
            let items: [EditItem] = [
                .init(title: "转账金额", key: "moneyAmount", value: mtModel.moneyAmount ?? ""),
                .init(title: "收款用户", key: "name", value: mtModel.name ?? ""),
                .init(title: "转账时间", key: "time", value: mtModel.time ?? ""),
                .init(title: "收款时间", key: "receiveTime", value: mtModel.receiveTime ?? ""),
            ]
            detail.setItems(items) {[weak self] params in
                guard let self = self else { return }
                
                self.mtModel?.moneyAmount = (params["moneyAmount"] as? String ?? "").toMoneyString
                self.mtModel?.name = params["name"] as? String
                self.mtModel?.time = params["time"] as? String
                self.mtModel?.receiveTime = params["receiveTime"] as? String
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        updateIcon(img: UIImage(named: "icon-back") ?? .init())
        
        if isFromTarget { // 对方退还给我
            updateStatusLabel(text: "\(mtModel?.name ?? "")已退还")
            
            let tipText = "已退款到零钱, 查看零钱"
            let attrStr = tipText.addAttributes(attrs: [.foregroundColor: UIColor.C_wx_link_text, .font: UIFont.boldSystemFont(ofSize: 13)], withRegx: "查看零钱")
            updateTipsLabel(attrStr: attrStr)
        }else{ // 我退还给对方
            updateStatusLabel(text: "已退还")
            updateTipsLabel(attrStr: "".addAttributes(attrs: [:]))
        }
        
        updateMoney(amount: mtModel?.moneyAmount ?? "")
        
        
        if mtModel?.transferDesc?.isEmpty == true {
            updateSection(with: [
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any]),
                .model(withDict: ["title": "收款时间" as Any, "value": mtModel?.receiveTime as Any])
            ])
        }else{
            updateSection(with: [
                .model(withDict: ["title": "转账说明" as Any, "value": mtModel?.transferDesc as Any]),
                .model(withDict: ["title": "转账时间" as Any, "value": mtModel?.time as Any]),
                .model(withDict: ["title": "收款时间" as Any, "value": mtModel?.receiveTime as Any])
            ])
        }
        
    }
}
