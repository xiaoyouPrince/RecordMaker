//
//  CellContentLink.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 微信消息,文件类型
 * 连接消息
 */

import UIKit

class MsgModelIDCard: WXDetailContentModelProtocol {
    /// 昵称
    var name: String?
    /// 头像
    var iconData: Data?
    /// 微信号
    var wechatID: String?
    /// 是否是公众号名片
    var isOfficial: Bool?
}

extension MsgModelIDCard {
    var icon: UIImage {
        UIImage(data: iconData ?? Data()) ?? UIImage()
    }
}

class CellContentIDCard: CellContentRedPacket {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBubbleTintColor(.white)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setModel(_ model: WXDetailModel) {
        bubbleView.addSubview(line)
        bubbleView.addSubview(appIcon)
        bubbleView.addSubview(bottomLabel)
        super.setModel(model)
        
        guard let data = model.data, let subModel: MsgModelIDCard = data.toModel() else { return }
        setData(data: subModel, isOutMsg: model.isOutGoingMsg)
    }
}

extension CellContentIDCard {
    
    func setData(data: MsgModelIDCard, isOutMsg: Bool) {
        // base properties
        bottomLabel.textColor = .C_wx_tip_text
        line.backgroundColor = .line
        titleLabel.numberOfLines = 1
        subTitleLabel.numberOfLines = 1
        subTitleLabel.textColor = .C_wx_tip_text
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        
        // content
        titleLabel.text = data.name
        subTitleLabel.text = data.wechatID
        iconView.image = data.icon
        
        // layout
        relayoutSubview(isOutMsg)
        
        // official
        if data.isOfficial == true {
            iconView.corner(radius: 22.5)
            bottomLabel.text = "公众号名片"
        }else{
            iconView.corner(radius: 5)
            bottomLabel.text = "个人名片"
            
            if data.wechatID != nil {
                titleLabel.snp.remakeConstraints { make in
                    make.left.equalTo(iconView.snp.right).offset(10)
                    make.right.equalTo(-15)
                    make.top.equalTo(iconView).offset(4)
                }
                
                subTitleLabel.snp.remakeConstraints { make in
                    make.left.equalTo(titleLabel)
                    make.right.equalTo(titleLabel)
                    make.top.equalTo(titleLabel.snp.bottom).offset(5)
                }
            }else{
                titleLabel.snp.remakeConstraints { make in
                    make.left.equalTo(iconView.snp.right).offset(10)
                    make.right.equalTo(-15)
                    make.centerY.equalTo(iconView)
                }
            }
        }
    }
    
    func relayoutSubview(_ isOutMsg: Bool) {
        // title
        // desc
        // fileIcon
        // appName
        if isOutMsg {
            iconView.snp.remakeConstraints { make in
                make.left.equalTo(10)
                make.top.equalTo(10)
                make.width.equalTo(45)
                make.height.equalTo(45)
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(iconView.snp.right).offset(10)
                make.right.equalTo(-15)
                make.centerY.equalTo(iconView)
            }
            
            bottomLabel.snp.remakeConstraints { make in
                make.left.equalTo(appIcon)
                make.right.equalTo(-15)
                make.top.equalTo(line.snp.bottom).offset(3)
                make.bottom.equalToSuperview().offset(-3)
                make.height.equalTo(15)
            }
            
        }else{
            
            iconView.snp.remakeConstraints { make in
                make.left.equalTo(15)
                make.top.equalTo(10)
                make.width.equalTo(45)
                make.height.equalTo(45)
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(iconView.snp.right).offset(10)
                make.right.equalTo(-10)
                make.centerY.equalTo(iconView)
            }
            
            bottomLabel.snp.remakeConstraints { make in
                make.left.equalTo(appIcon)
                make.right.equalTo(-15)
                make.top.equalTo(line.snp.bottom).offset(3)
                make.bottom.equalToSuperview().offset(-3)
                make.height.equalTo(15)
            }
        }
    }
}

