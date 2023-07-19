//
//  CellContentRedPacket.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/17.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit

/// voip数据模型
class MsgRedPacketModel: Codable {
    /// 金额
    var amountOfMoney: String?
    /// 是否已经被拆开,被处理过
    var isHandled: Bool? = false
}

class CellContentRedPacket: UIView {
    
    let receiveImg = UIImage(named: "ChatRoom_Bubble_HB_Receiver")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let receiveImg_Handled = UIImage(named: "ChatRoom_Bubble_HB_Receiver_Handled")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let sendImg = UIImage(named: "ChatRoom_Bubble_HB_Sender")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let sendImg_Handled = UIImage(named: "ChatRoom_Bubble_HB_Sender_Handled")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let wechat_chat_hongbao_not_open = UIImage(named: "wechat_chat_hongbao_a")
    let wechat_chat_hongbao_open = UIImage(named: "wechat_chat_hongbao_c")
    
    let contentView = UIView()
    let bubbleView = UIImageView()
    let iconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let line: UIView = UIView.line
    let bottomLabel = UILabel(title: "微信红包", font: .systemFont(ofSize: 10), textColor: .white, textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(contentView)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(iconView)
        bubbleView.addSubview(titleLabel)
        bubbleView.addSubview(line)
        bubbleView.addSubview(bottomLabel)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CellContentRedPacket: WXDetailContentProtocol {
    
    
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
            
            iconView.image = wechat_chat_hongbao_not_open
            iconView.snp.remakeConstraints { make in
                make.left.equalTo(10)
                make.top.equalTo(10)
            }
            
            titleLabel.text = "恭喜发才,大吉大利"
            titleLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(iconView)
                make.right.equalToSuperview().offset(-15)
                make.left.equalTo(iconView.snp.right).offset(10)
            }
            
            line.backgroundColor = .white.withAlphaComponent(0.3)
            line.snp.remakeConstraints { make in
                make.left.equalTo(10)
                make.right.equalTo(-15)
                make.height.equalTo(CGFloat.line)
                make.top.equalTo(iconView.snp.bottom).offset(10)
            }
            
            bottomLabel.snp.remakeConstraints { make in
                make.left.equalTo(10)
                make.right.equalTo(-15)
                make.top.equalTo(line.snp.bottom).offset(3)
                make.bottom.equalToSuperview().offset(-3)
                make.height.equalTo(15)
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
            
            
            iconView.image = wechat_chat_hongbao_not_open
            iconView.snp.remakeConstraints { make in
                make.left.equalTo(15)
                make.top.equalTo(10)
            }
            
            titleLabel.text = "恭喜发才,大吉大利"
            titleLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(iconView)
                make.right.equalToSuperview().offset(-10)
                make.left.equalTo(iconView.snp.right).offset(10)
            }
            
            line.backgroundColor = .white.withAlphaComponent(0.3)
            line.snp.remakeConstraints { make in
                make.left.equalTo(15)
                make.right.equalTo(-10)
                make.height.equalTo(CGFloat.line)
                make.top.equalTo(iconView.snp.bottom).offset(10)
            }
            
            bottomLabel.snp.remakeConstraints { make in
                make.left.equalTo(15)
                make.right.equalTo(-10)
                make.top.equalTo(line.snp.bottom).offset(3)
                make.bottom.equalToSuperview().offset(-3)
                make.height.equalTo(15)
            }
        }
        
        if let data = model.data {
            guard let voipModel: MsgRedPacketModel = data.toModel() else { return }
            setModel(voipModel, isOutGoingMsg: model.isOutGoingMsg)
        }
    }
    
    func setModel(_ data: MsgRedPacketModel, isOutGoingMsg: Bool) {
        if data.isHandled == true {
            
        }else{
            
        }
    }
    
}


