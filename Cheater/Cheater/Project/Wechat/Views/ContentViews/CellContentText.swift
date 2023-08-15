//
//  CellContentText.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 文本消息的容器
 *
 *  计算文本高度
 */

import UIKit

class CellContentView: UIView {
    lazy var deletetBtn = getDeleteBtn()
    
    private func getDeleteBtn() -> UIButton{
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "buddle-msg-error")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }
}

class CellContentText: CellContentView {
    
    let receiveImg = UIImage(named: "ReceiverTextNodeBkg")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    let sendImg = UIImage(named: "SenderTextNodeBkg")?.resizableImage(withCapInsets: .init(top: 25, left: 30, bottom: 22, right: 30))
    
    let label = UILabel()
    let bgImage = UIImageView()
    

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(bgImage)
        addSubview(deletetBtn)
        bgImage.addSubview(label)
        
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}

extension CellContentText: WXDetailContentProtocol {
    
    
    var showIconImage: Bool { true }
    
    var showNamelable: Bool { false }
    
    var showReadLabel: Bool { false }
    
    var contentClass: UIView.Type {
        CellContentText.self
    }
    
    func setModel(_ model: WXDetailModel) {
        
        if model.isOutGoingMsg {
            bgImage.image = sendImg
            bgImage.snp.remakeConstraints { make in
                make.right.equalToSuperview()
                make.left.greaterThanOrEqualToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            label.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview().offset(12)
                make.width.lessThanOrEqualTo(200)
                make.left.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-12)
            }
            
            deletetBtn.snp.remakeConstraints { make in
                make.right.equalTo(bgImage.snp.left).offset(-5)
                make.centerY.equalTo(bgImage)
            }
        }else
        {
            bgImage.image = receiveImg
            bgImage.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.right.lessThanOrEqualToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            label.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(12)
                make.width.lessThanOrEqualTo(CGFloat.width - 120)
                make.right.equalToSuperview().offset(-20)
                make.bottom.equalToSuperview().offset(-12)
            }
            
            deletetBtn.snp.remakeConstraints { make in
                make.left.equalTo(bgImage.snp.right).offset(5)
                make.centerY.equalTo(bgImage)
            }
        }
        
        deletetBtn.isHidden = !(model.isUserBeingBlocked ?? false)
        if let data = model.data {
            setModel(data)
        }
    }
    
    func setModel(_ data: Data) {
        let text = String(data: data, encoding: .utf8) ?? ""
        
        // 解析对应的表情
        let attrMStr = NSMutableAttributedString(string: text)
        label.attributedText = attrMStr
        
        let regx = try? NSRegularExpression(pattern: "\\[.*?\\]", options: .caseInsensitive)
        guard let matches = regx?.matches(in: text, range: NSRange(location: 0, length: text.count)) else { return }
        for m in matches.reversed() {
            // 0.find emotion
            for emotion in EmotionManager.shared.emotions {
                let emoName = (text as NSString).substring(with: m.range)
                if emoName == "\(emotion.title)" {
                    // 1.create att
                    let attachment = EmotionAttchment()
                    attachment.chs = emotion.title
                    attachment.image = emotion.image //UIImage(contentsOfFile: emotion.pngPath!)
                    let font = label.font
                    attachment.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
                    
                    // 2.通过attachMent生成待使用属性字符串
                    let attrImageStr = NSAttributedString(attachment: attachment)
                    
                    // 4.替换当前位置的属性字符串并重新赋值给textView
                    let range = m.range
                    attrMStr.replaceCharacters(in: range, with: attrImageStr)
                    
                    continue
                }
            }
        }
        
        label.attributedText = attrMStr
    }
}
