//
//  WXListCell.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/4.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit
import XYInfomationSection

class WXListCell: XYInfomationCell {
    
    private var iconView = UIImageView()
    private var badge = UIView()
    private var titleLabel = UILabel()
    private var statusView = UIImageView()
    private var timeLabel = UILabel()
    private var lastMessageLabel = UILabel()
    private var dontDisturbView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WXListCell {
    
    func setupUI() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(statusView)
        addSubview(timeLabel)
        addSubview(lastMessageLabel)
        addSubview(dontDisturbView)
        
        iconView.corner(radius: 5)
        iconView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(50)
        }
        
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.top.equalTo(iconView).offset(2)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5)
        }
        
        statusView.tintColor = .C_wx_status
        statusView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(4)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        timeLabel.textColor = .xy_getColor(red: 180, green: 180, blue: 180)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(titleLabel)
        }
        
        lastMessageLabel.textColor = .xy_getColor(red: 180, green: 180, blue: 180)
        lastMessageLabel.font = .systemFont(ofSize: 14)
        lastMessageLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(iconView).offset(-2)
            make.right.equalToSuperview().offset(-40)
        }
        
        dontDisturbView.image = .init(named: "wechat_top_mute_new")
        dontDisturbView.snp.makeConstraints { make in
            make.right.equalTo(timeLabel)
            make.size.equalTo(CGSize(width: 12, height: 12))
            make.centerY.equalTo(lastMessageLabel)
        }
    }
    
    func setBadge(_ count: Int) -> XYBadgeView {
        let badge = XYBadgeView(type: .stringContext)
        addSubview(badge)
        badge.intContent = count
        badge.snp.makeConstraints { make in
            make.right.equalTo(iconView).offset(8)
            make.top.equalTo(iconView).offset(-5)
        }
        return badge
    }
    
    func setBadgeDot() -> XYBadgeView {
        let badge = XYBadgeView(type: .redDot)
        addSubview(badge)
        badge.snp.makeConstraints { make in
            make.right.equalTo(iconView).offset(4)
            make.top.equalTo(iconView).offset(-4)
        }
        return badge
    }
    
    override var model: XYInfomationItem {
        didSet {
            guard let listModel = model.obj as? WXListModel else { return }
            
            iconView.image = listModel.image
            titleLabel.text = listModel.title
            timeLabel.text = listModel.timeStr
            statusView.image = UIImage(named: listModel.statusName ?? "")?.withRenderingMode(.alwaysTemplate)
            backgroundColor = listModel.isTop == true ? WXConfig.navBarBgColor : .white

            badge.removeFromSuperview()
            if let count = listModel.badgeInt, count > 0 {
                badge = setBadge(count)
            }
            
            dontDisturbView.isHidden = !(listModel.noDisturb ?? false)
            
            if let silenceNotify = listModel.silenceNotify, silenceNotify {
                badge.removeFromSuperview()
                badge = setBadgeDot()
            }
            
            lastMessageLabel.text = listModel.lsatMessage
        }
    }
}
