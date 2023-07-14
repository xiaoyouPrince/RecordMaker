//
//  CellContentVoice.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/13.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit

/// 语音数据模型
class MsgVoiceModel: Codable {
    var voiceTime: Int? = 0
    var showText: Bool? = false
    var textContent: String? = ""
    var hasRead: Bool? = false
}

/// 语音转文字内容view
private class ContentView: UIView {
    let label = UILabel()
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(label)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        corner(radius: 5)
        
        label.numberOfLines = 0
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CellContentVoice: UIView {

    let receiveImg = UIImage(named: "ReceiverTextNodeBkg")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let sendImg = UIImage(named: "SenderTextNodeBkg")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let receiveVoiceImg = UIImage(named: "wechat_voiceLeft")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let sendVoiceImg = UIImage(named: "wechat_voiceRight")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    
    let label = UILabel()
    let iconView = UIImageView()
    let bgImage = UIImageView()
    fileprivate let contentView = ContentView()
    let redDot = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(bgImage)
        bgImage.addSubview(label)
        bgImage.addSubview(iconView)
        addSubview(contentView)
        addSubview(redDot)
        
        redDot.backgroundColor = .C_red_dot
        redDot.corner(radius: 5)
    }
}

extension CellContentVoice: WXDetailContentProtocol {
    var contentClass: UIView.Type {
        CellContentVoice.self
    }
    
    var showReadLabel: Bool { false }
    
    func setModel(_ model: WXDetailModel) {
        
        guard let data: MsgVoiceModel = model.data?.toModel() else { return }
        setModel(data)
        
        if model.isOutGoingMsg {
            bgImage.image = sendImg
            bgImage.snp.remakeConstraints { make in
                make.right.equalToSuperview()
                make.left.greaterThanOrEqualToSuperview()
                make.top.equalToSuperview()
            }
            
            label.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.width.lessThanOrEqualTo(200)
                make.left.equalToSuperview().offset(20)
            }
            
            iconView.image = sendVoiceImg
            iconView.snp.remakeConstraints { make in
                make.left.equalTo(label.snp.right).offset(10)
                make.right.equalTo(-20)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(25)
            }
            
            if data.showText == true {
                contentView.snp.remakeConstraints { make in
                    make.right.equalTo(bgImage.snp.right).offset(-5)
                    make.top.equalTo(bgImage.snp.bottom).offset(10)
                    make.left.greaterThanOrEqualToSuperview()
                    make.bottom.equalToSuperview()
                }
                
            }else{
                bgImage.snp.makeConstraints { make in
                    make.bottom.equalToSuperview()
                }
            }
            
            redDot.snp.remakeConstraints { make in
                make.right.equalTo(bgImage.snp.left).offset(-5)
                make.centerY.equalTo(bgImage)
                make.width.height.equalTo(10)
            }
            
        }else
        {
            bgImage.image = receiveImg
            bgImage.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.right.lessThanOrEqualToSuperview()
                make.top.equalToSuperview()
            }
            
            label.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(12)
                make.width.lessThanOrEqualTo(CGFloat.width - 120)
            }
            
            iconView.image = receiveVoiceImg
            iconView.snp.remakeConstraints { make in
                make.left.equalTo(label.snp.right).offset(10)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(25)
                make.right.equalToSuperview().offset(-20)
            }
            
            if data.showText == true {
                contentView.snp.remakeConstraints { make in
                    make.left.equalTo(bgImage).offset(5)
                    make.top.equalTo(bgImage.snp.bottom).offset(10)
                    make.right.lessThanOrEqualToSuperview()
                    make.bottom.equalToSuperview()
                }
                
            }else{
                bgImage.snp.makeConstraints { make in
                    make.bottom.equalToSuperview()
                }
            }
            
            redDot.snp.remakeConstraints { make in
                make.left.equalTo(bgImage.snp.right).offset(5)
                make.centerY.equalTo(bgImage)
                make.width.height.equalTo(10)
            }
        }
    }
    
    func setModel(_ data: MsgVoiceModel) {
        let timeSting = "\(data.voiceTime ?? 1)" + "''"
        label.text = timeSting
        
        if data.showText == true {
            contentView.setTitle((data.textContent ?? "").trim())
        }
        
        if let hasRead = data.hasRead, let showText = data.showText {
            if showText {
                redDot.isHidden = true
            }else{
                redDot.isHidden = hasRead
            }
        }
    }
}
