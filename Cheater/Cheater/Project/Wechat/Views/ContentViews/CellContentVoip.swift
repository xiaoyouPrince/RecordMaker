//
//  CellContentVoip.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/17.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit

/// voip数据模型
class MsgVoipModel: Codable {
    /// 连接时长,用户直接输入
    var voipTime: String?
    /// 是否取消
    var isCancel: Bool?
    /// 是否拒绝
    var isRefuse: Bool?
    /// 通话类型
    var voipType: Int? = 0 // 0 视频, 1 语音
}

class CellContentVoip: UIView {
    
    let receiveImg = UIImage(named: "ReceiverTextNodeBkg")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let sendImg = UIImage(named: "SenderTextNodeBkg")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let voiceIcon = UIImage(named: "wechat_chat_call_a")
    let videoIcon = UIImage(named: "wechat_chat_video_b")
    
    let contentView = UIView()
    let bubbleView = UIImageView()
    let iconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(contentView)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(iconView)
        bubbleView.addSubview(titleLabel)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CellContentVoip: WXDetailContentProtocol {
    
    
    var showIconImage: Bool { true }
    
    var showNamelable: Bool { false }
    
    var showReadLabel: Bool { false }
    
    var contentClass: UIView.Type {
        CellContentVoip.self
    }
    
    func setModel(_ model: WXDetailModel) {
        
        if model.isOutGoingMsg {
            bubbleView.image = sendImg
            bubbleView.snp.remakeConstraints { make in
                make.right.equalToSuperview()
                make.left.greaterThanOrEqualToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            iconView.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalToSuperview()
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(iconView.snp.left).offset(-5)
                make.left.equalToSuperview().offset(20)
            }
            
        }else
        {
            bubbleView.image = receiveImg
            bubbleView.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.right.lessThanOrEqualToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            iconView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.centerY.equalToSuperview()
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(iconView.snp.right).offset(5)
                make.right.equalToSuperview().offset(-20)
            }
        }
        
        if let data = model.data {
            guard let voipModel: MsgVoipModel = data.toModel() else { return }
            setModel(voipModel, isOutGoingMsg: model.isOutGoingMsg)
        }
    }
    
    func setModel(_ data: MsgVoipModel, isOutGoingMsg: Bool) {
        
        if data.voipType == 0 { // 视频
            if isOutGoingMsg {
                iconView.image = videoIcon?.withRenderingMode(.alwaysOriginal)
                iconView.transform = .init(rotationAngle: Double.pi)
            }else{
                iconView.image = videoIcon?.withRenderingMode(.alwaysOriginal)
                iconView.transform = .identity
            }
        }else{ // 1 音频
            iconView.image = voiceIcon?.withRenderingMode(.alwaysOriginal)
            iconView.transform = .identity
        }
        
        
        var title = ""
        if data.isCancel == true { // 取消高优先级
            if !isOutGoingMsg {
                title = "对方已取消"
            }else{
                title = "已取消"
            }
        } else {
            if data.isRefuse == true {
                if !isOutGoingMsg {
                    title = "已拒绝"
                }else{
                    title = "对方已拒绝"
                }
            }else{// 接通
                title = "通话时长" + " " + (data.voipTime ?? "")
            }
        }
        
        titleLabel.text = title
        
    }
    
}


