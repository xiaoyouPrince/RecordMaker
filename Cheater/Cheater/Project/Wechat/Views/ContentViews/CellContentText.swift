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

class CellContentText: UIView {
    
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
        bgImage.addSubview(label)
        
        //backgroundColor = .red
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
        }
        
        if let data = model.data {
            setModel(data)
        }
    }
    
    func setModel(_ data: Data) {
        label.text = String(data: data, encoding: .utf8)
    }
    
}
