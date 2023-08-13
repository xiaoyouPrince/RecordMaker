//
//  CellContentLink.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 微信消息,🔗类型
 * 连接消息
 */

import UIKit

class MsgModelLink: WXDetailContentModelProtocol {
    /// 连接地址
    var url: String?
    /// 连接标题
    var title: String?
    /// 连接描述
    var desc: String?
    /// 连接图标
    var linkIcon: Data?
    /// 应用图标
    var appIcon: Data?
    /// 应用名字
    var appName: String?
}

class CellContentLink: CellContentRedPacket {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBubbleTintColor(.white)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setModel(_ model: WXDetailModel) {
        super.setModel(model)
        
        guard let data = model.data, let subModel: MsgModelLink = data.toModel() else { return }
        setData(data: subModel, isOutMsg: model.isOutGoingMsg)
    }
}

extension CellContentLink {
    
    func setData(data: MsgModelLink, isOutMsg: Bool) {
        
        titleLabel.text = data.title
        subTitleLabel.text = data.desc
        iconView.image = UIImage(data: data.linkIcon ?? Data())
        appIcon.image = UIImage(data: data.appIcon ?? Data())
        bottomLabel.text = data.appName
        bottomLabel.textColor = .C_wx_tip_text
        line.backgroundColor = .line
        
        // title
        // desc
        // linkIcon
        // appIcon
        // appName
        titleLabel.numberOfLines = 2
        subTitleLabel.numberOfLines = 2
        subTitleLabel.textColor = .C_wx_tip_text
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        if isOutMsg {
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(10)
                make.top.equalTo(13)
                make.right.equalTo(-15)
            }
            
            iconView.snp.remakeConstraints { make in
                make.right.equalTo(-15)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.width.height.equalTo(50)
            }
            
            subTitleLabel.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel)
                make.right.equalTo(iconView.snp.left).offset(-8)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
            }
        }else{
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(15)
                make.top.equalTo(13)
                make.right.equalTo(-10)
            }
            
            iconView.snp.remakeConstraints { make in
                make.right.equalTo(-10)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.width.height.equalTo(50)
            }
            
            subTitleLabel.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel)
                make.right.equalTo(iconView.snp.left).offset(-8)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
            }
        }
    }
}

