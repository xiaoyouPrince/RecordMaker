//
//  MoneyTransferHeader.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/23.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 发转账头部发送给谁的header
 */

import UIKit
import XYUIKit

class MoneyTransferHeader: UIView {

    let toLabel = UILabel()
    let wxNoLabel = UILabel()
    let iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(toLabel)
        addSubview(wxNoLabel)
        addSubview(iconView)
        
        iconView.corner(radius: 5)
        iconView.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.height.width.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        toLabel.font = .boldSystemFont(ofSize: 16)
        toLabel.textColor = .C_000000
        toLabel.snp.remakeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(25)
        }
        
        wxNoLabel.font = .systemFont(ofSize: 15)
        wxNoLabel.textColor = .C_wx_tip_text
        wxNoLabel.snp.makeConstraints { make in
            make.left.equalTo(toLabel)
            make.top.equalTo(toLabel.snp.bottom).offset(8)
            make.bottom.equalTo(-25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(userInfo: WXUserInfo) {
        toLabel.text = "转账给" + " " + userInfo.paySceneName
        wxNoLabel.text = "微信号:" + " " + (userInfo.wechatId ?? "")
        iconView.image = userInfo.icon ?? UIImage(named: userInfo.iconName ?? "")
    }
    
}
