//
//  RedPacketBaseViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/26.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 红包页面基类
 *
 *  1. 待对方领取
 *  2. 对方已经领取
 *  2. 我已领取
 */

import UIKit
import XYUIKit
import XYInfomationSection

class RedPacketBaseViewController: XYInfomationBaseViewController {
    fileprivate var senderView = RedPacketSenderView()
    var model: RedPacketModel? { didSet{setupSenderView()} }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSenderView()
    }
    
    func setupSenderView() {
        if let model = model {
            senderView.setup(with: model)
        }
    }
}

extension RedPacketBaseViewController {
    @objcMembers
    class RedPacketModel: NSObject {
        var senderIcon: UIImage? = WXUserInfo.shared.icon
        var senderName: String? = WXUserInfo.shared.name
        var tipString: String? = "恭喜发财,大吉大利"
        var moneyAmount: String? = "0".toMoneyString
        /// 是否已经被领取
        var hasReceived: Bool = false
        /// 是否已经被我领取
        var hasReceivedByMe: Bool = false
        
        var receiverIcon: UIImage? = WXUserInfo.shared.icon
        var receiverName: String? = WXUserInfo.shared.name
        var receiveTime: String? = Date(timeIntervalSince1970: .since1970).string(withFormatter: "YYYY-MM-dd HH:mm:ss")
    }
}

private extension RedPacketBaseViewController {
    
    class NavBar: UIView {
        let leftBtn = UIView()
        let rightBtn = UIView()
        
        init(backClick: @escaping ()->()) {
            super.init(frame: .zero)
            setupContentView()
            
            leftBtn.addTap { sender in
                backClick()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupContentView(){
            addSubview(leftBtn)
            addSubview(rightBtn)
            leftBtn.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.width.equalTo(60)
                make.bottom.equalToSuperview()
                make.height.equalTo(CGFloat.naviHeight)
            }
            
            rightBtn.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.width.equalTo(60)
                make.bottom.equalToSuperview()
                make.height.equalTo(CGFloat.naviHeight)
            }
            
            let backIcon = UIImageView(image: .wx_backImag?.withRenderingMode(.alwaysTemplate))
            leftBtn.addSubview(backIcon)
            backIcon.snp.makeConstraints { make in
                make.left.equalTo(15)
                make.centerY.equalToSuperview()
                //make.width.equalTo(backIcon.snp.height)
            }
            
            let dianIcon = UIImageView(image: .init(named: "wechat_sandian")?.withRenderingMode(.alwaysTemplate))
            rightBtn.addSubview(dianIcon)
            dianIcon.snp.makeConstraints { make in
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
                //make.width.equalTo(backIcon.snp.height)
            }
            
            tintColor = .white
            snp.makeConstraints { make in
                make.height.equalTo(CGFloat.naviBar)
            }
        }
    }
    
    class RedPacketSenderView: UIView {
        private let iconView = UIImageView()
        private let titleLabel = UILabel(title: "", font: .boldSystemFont(ofSize: 20), textColor: .black, textAlignment: .left)
        private let topContentView = UIView()
        private let tipLabel = UILabel(title: "恭喜发财, 大吉大利", font: .systemFont(ofSize: 14), textColor: .C_wx_tip_text, textAlignment: .center)
        private let moneyStatusLabel = UILabel(title: "", font: .systemFont(ofSize: 16), textColor: .C_wx_tip_text, textAlignment: .left)
        private let bottomLine = UIView.line
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupContent()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup(with model: RedPacketModel) {
            iconView.image = model.senderIcon
            titleLabel.text = (model.senderName ?? "") + "发出的红包"
            tipLabel.text = model.tipString
            
            if model.hasReceivedByMe { // 我领取的 UI 不同
                moneyStatusLabel.removeFromSuperview()
                bottomLine.removeFromSuperview()
                snp.makeConstraints { make in
                    make.height.equalTo(80)
                }
            }else{// 非我领取的红包
                if model.hasReceived { // 看对方是否已经领取
                    moneyStatusLabel.text = "1个红包共\(model.moneyAmount ?? "0.00")元"
                }else
                {
                    moneyStatusLabel.text = "红包金额\(model.moneyAmount ?? "0.00")元，等待对方领取"
                }
            }
        }
        
        private func setupContent() {
            addSubview(topContentView)
            topContentView.addSubview(iconView)
            topContentView.addSubview(titleLabel)
            addSubview(tipLabel)
            addSubview(moneyStatusLabel)
            
            topContentView.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
            }
            
            iconView.corner(radius: 5)
            iconView.image = .defaultHead
            iconView.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.height.equalTo(30)
            }
            
            titleLabel.text = "XXX发出的红包"
            titleLabel.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.left.equalTo(iconView.snp.right).offset(5)
                make.centerY.equalTo(iconView)
            }
            
            tipLabel.numberOfLines = 0
            tipLabel.snp.makeConstraints { make in
                make.centerX.equalTo(topContentView)
                make.top.equalTo(topContentView.snp.bottom).offset(15)
            }
            
            moneyStatusLabel.text = "总共100元,待领取"
            moneyStatusLabel.snp.makeConstraints { make in
                make.left.equalTo(15)
                make.top.equalTo(topContentView.snp.bottom).offset(97)
                make.right.equalTo(-15)
            }
            
            addSubview(bottomLine)
            bottomLine.snp.makeConstraints { make in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(moneyStatusLabel.snp.bottom).offset(15)
                make.height.equalTo(CGFloat.line)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    func buildUI() {
        baseUI()
    }
    
    func baseUI() {
        // bgView
        let bgHeight: CGFloat
        if let bgImage = UIImage.init(named: "RedEnvelope_Bg") {
            let topBgView = UIImageView(image: bgImage)
            view.addSubview(topBgView)
            topBgView.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(CGFloat.getRealValue(value: bgImage.size.height))
            }
            
            bgHeight = CGFloat.getRealValue(value: bgImage.size.height)
        }else{
            bgHeight = 100
        }
        
        // navbar
        let navBar = NavBar {[weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        // topView
        let senderView = RedPacketSenderView()
        view.addSubview(senderView)
        senderView.snp.makeConstraints { make in
            make.top.equalTo(bgHeight + 20)
            make.left.right.equalToSuperview()
        }
        self.senderView = senderView
    }
    
    
}

// MARK: - 子类


/// 等待对方领取
class RPWaitReceiveController: RedPacketBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bottomTip = UILabel.init(title: "", font: UIFont.systemFont(ofSize: 15), textColor: .C_wx_tip_text, textAlignment: .center)
        view.addSubview(bottomTip)
        bottomTip.text = "未领取的红包，将于24小时后发起退款"
        bottomTip.snp.makeConstraints { make in
            make.bottom.equalTo(-CGFloat.safeBottom - 20)
            make.centerX.equalToSuperview()
        }
    }
}


/// 对方已经领取
class RPTargetHasReceivedController: RedPacketBaseViewController {
    class ReceiverView: UIView {
        private let iconView = UIImageView()
        private let titleLabel = UILabel(title: "", font: .systemFont(ofSize: 17), textColor: .black, textAlignment: .left)
        private let detailLabel = UILabel(title: "", font: .systemFont(ofSize: 15), textColor: .C_wx_tip_text, textAlignment: .left)
        private let moneyLabel = UILabel(title: "", font: .wx_moeny_font(17), textColor: .black, textAlignment: .right)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupContent()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup(with model: RedPacketModel) {
            iconView.image = model.receiverIcon
            titleLabel.text = model.receiverName
            detailLabel.text = model.receiveTime
            moneyLabel.text = "\(model.moneyAmount ?? "".toMoneyString)元"
        }
        
        private func setupContent() {
            addSubview(iconView)
            addSubview(titleLabel)
            addSubview(detailLabel)
            addSubview(moneyLabel)
            
            iconView.corner(radius: 5)
            iconView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(13)
                make.top.equalToSuperview().offset(13)
                make.height.width.equalTo(45)
                make.bottom.equalToSuperview().offset(-13)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(iconView.snp.right).offset(13)
                make.top.equalTo(iconView)
                make.right.equalTo(moneyLabel.snp.left).offset(-10)
            }
            
            detailLabel.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.bottom.equalTo(iconView)
            }
            
            moneyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            moneyLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            moneyLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel)
                make.right.equalToSuperview().offset(-13)
            }
        }
    }
    
    
    var receiverView = ReceiverView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = model {
            view.addSubview(receiverView)
            receiverView.setup(with: model)
            
            receiverView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(senderView.snp.bottom).offset(10)
            }
        }
    }
}

/// 我已经领取
class RPMeHasReceivedController: RedPacketBaseViewController {
    
    let stackView = VStack(spacing: 35)
    let moneyView = MoneyView(with: "299")
    let tipLabel = UILabel()
    let emojiView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let goldColor = UIColor.xy_getColor(red: 179, green: 147, blue: 95)
        
        tipLabel.text = "哈哈哈哈"
        tipLabel.textColor = goldColor
        let rightIcon = UIImageView(image: UIImage(named: "youjiantou")?.withRenderingMode(.alwaysTemplate))
        let hStack = HStack(spacing: 5)
        hStack.addArrangedSubview(tipLabel)
        hStack.addArrangedSubview(rightIcon)
        hStack.tintColor = goldColor
        
        
        
        emojiView.backgroundColor = .gray.withAlphaComponent(0.10)
        emojiView.corner(radius: 5)
        emojiView.tintColor = goldColor
        emojiView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        let emojiIcon = UIImageView(image: UIImage(named: "wechat_input_emoticon")?.withRenderingMode(.alwaysTemplate))
        let emojiLabel: UILabel = UILabel()
        emojiLabel.text = "回复表情到聊天"
        emojiLabel.textColor = goldColor
        
        let emojiStack = HStack(spacing: 5)
        emojiStack.addArrangedSubview(emojiIcon)
        emojiStack.addArrangedSubview(emojiLabel)
        emojiView.addSubview(emojiStack)
        emojiStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(15)
        }
        
        let vstack = VStack(spacing: 15)
        [moneyView, hStack].forEach { item in
            vstack.addArrangedSubview(item)
        }
        
        view.addSubview(stackView)
        [vstack, emojiView].forEach { item in
            stackView.addArrangedSubview(item)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(senderView.snp.bottom)
        }
    }
}

/*
 * - TODO -
 * 我已经收款页面
 * moneyView 修改样式 & tintColor
 *  回复表情 icon 找一个
 *  三个控制器的编辑页面
 */



