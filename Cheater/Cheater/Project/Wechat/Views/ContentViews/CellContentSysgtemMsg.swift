//
//  CellContentSystemMsg.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/14.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

/// 系统消息数据模型
class MsgSystemModel: Codable {
    var content: String? = "" // 消息内容
    
    /*
     * - 系统消息包括 -
     *
     *单聊
     * 添加好友成功消息 -> 以上是打招呼内容
     * 添加好友消息 -> 你已经添加了xx, 现在可以开始聊天了
     * 拍一拍 -> 我拍了拍 “xxx”
     *
     *群聊
     * 邀请进群消息 -> 你邀请“xxx,xxx”加入群聊
     * 隐私安全消息 -> “xxx”与群里其他人都不是微信朋友关系,请注意隐私安全
     * 拍一拍 -> 我拍了拍 “xxx”
     */
}


class CellContentSystemMsg: UIView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(label)
        
        label.textAlignment = .center
        label.textColor = .C_wx_tip_text
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
    }
}

extension CellContentSystemMsg: WXDetailContentProtocol {
    var contentClass: UIView.Type {
        CellContentSystemMsg.self
    }
    
    var fullCustom: Bool { true }
    
    func setModel(_ model: WXDetailModel) {
        guard let data: MsgSystemModel = model.data?.toModel() else { return }
        setModel(data)
    }
    
    func setModel(_ data: MsgSystemModel) {
        let contentString = data.content ?? ""
        //label.text = contentString
        
        label.attributedText = contentString.addAttributes(attrs: [.foregroundColor: UIColor.red], withRegx: "#[^#]*#")
        
        let leftMargin: CGFloat = 60
        let topMargin: CGFloat = 8
        
        let stringHeight = contentString.heightOf(font: label.font, size: .init(width: .width - 2*leftMargin, height: .height))
        label.snp.remakeConstraints { make in
            make.left.equalTo(leftMargin)
            make.right.equalTo(-leftMargin)
            make.top.equalTo(topMargin)
            make.bottom.equalTo(-topMargin)
            make.height.equalTo(stringHeight)
        }
    }
}
