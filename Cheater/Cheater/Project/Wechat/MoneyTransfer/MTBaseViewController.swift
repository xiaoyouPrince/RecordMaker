//
//  MTBaseViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/22.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 转账相关页面的基类页面 - UI示例见微信转账 - 待对方确认收款页面
 *
 *  1. 数据模型
 *  2. 基本UI
 */

import UIKit
import XYUIKit
import XYInfomationSection

/// 转账数据模型
class MTModel: Codable {
    var iconData: Data?
    var iconName: String?
    var name: String?
    var realName: String?
    var wechatId: String?
    
    /// 转账说明
    var transferDesc: String?
    /// 转账限制文字
    @objc var transferLimitTip: String? = "零钱支付已超过法律规定的每年20万元上限. 请换用银行卡支付, 零钱资金可提现或明年使用"
    /// 转账金额
    var moneyAmount: String?
    /// 转账时间
    var time: String?
    /// 收款时间
    var receiveTime: String?
}

extension MTModel {
    /// 获取加密后的真实姓名 egg: (**峰)
    var screatRealName: String {
        if var name = realName {
            let result = "("
            var stars = ""
            for _ in 0..<name.count {
                stars.append("*")
            }
            name.replaceSubrange(name.startIndex..<name.index(before: name.endIndex), with: stars)
            return result + name + ")"
        }
        return "(**峰)"
    }
    
    /// 支付或者转账场景下的名称 egg: 深海一只贝 (**u)
    var paySceneName: String {
        (name ?? "") + " " + screatRealName
    }
    
    var icon: UIImage? {
        if let data = iconData {
            return UIImage(data: data)
        }else{
            return UIImage(named: iconName ?? "")
        }
    }
}

class MTBaseViewController: UIViewController {
    
    private var iconView = UIImageView()
    private var statusLabel = UILabel()
    private var moneyView = MoneyView(with: "1")
    private var tipsLabel = UILabel()
    private var line = UIView.line
    private var sectionView = XYInfomationSection()
    var mtModel: MTModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nav_setCustom(backImage: .wx_backImag)
        nav_hideBarBottomLine()
        
        buildUI()
    }
}

extension MTBaseViewController {
    
    func updateIcon(img: UIImage)  {
        iconView.image = img
    }
    
    func updateStatusLabel(text: String) {
        statusLabel.text = text
    }
    
    func updateMoney(amount: String) {
        moneyView.moneyStr = amount
    }
    
    func updateTipsLabel(attrStr: NSAttributedString) {
        tipsLabel.attributedText = attrStr
    }
    
    @objc func updateSection(with dataArray: [XYInfomationItem]) {
        sectionView.dataArray = dataArray.map({ item in
            item.type = .other
            item.customCellClass = SectionCell.self
            item.cellHeight = 30
            item.isHideSeparateLine = true
            return item
        })
    }
    
    func buildUI() {
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        statusLabel.textColor = .C_000000
        
        tipsLabel.font = UIFont.systemFont(ofSize: 13)
        tipsLabel.textColor = .C_wx_tip_text
        
        view.addSubview(iconView)
        view.addSubview(statusLabel)
        view.addSubview(moneyView)
        view.addSubview(tipsLabel)
        view.addSubview(line)
        view.addSubview(sectionView)
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(CGFloat.naviBar + 50)
            make.width.height.equalTo(60)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(35)
        }
        
        moneyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(moneyView.snp.bottom).offset(20)
        }
        
        line.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(tipsLabel.snp.bottom).offset(20)
            make.height.equalTo(CGFloat.line)
        }
        
        sectionView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(5)
            make.left.right.equalTo(line)
        }
    }
}

class SectionCell: XYInfomationCell {
    var titelLabel = UILabel()
    var detailLabel = UILabel()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        addSubview(titelLabel)
        addSubview(detailLabel)
        
        titelLabel.font = .systemFont(ofSize: 12)
        titelLabel.textColor = .C_wx_tip_text
        titelLabel.numberOfLines = 0
        detailLabel.font = .systemFont(ofSize: 12)
        detailLabel.textColor = .C_000000
        detailLabel.numberOfLines = 0
        
        titelLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titelLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titelLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(5)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titelLabel)
            make.right.equalToSuperview().offset(-5)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
            make.left.greaterThanOrEqualTo(titelLabel.snp.right).offset(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model: XYInfomationItem{
        didSet{
            titelLabel.text = model.title
            detailLabel.text = model.value
        }
    }
}
