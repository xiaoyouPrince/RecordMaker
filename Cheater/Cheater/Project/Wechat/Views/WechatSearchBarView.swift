//
//  WechatSearchBarView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/16.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/**
    微信首页的搜索框
 */

import UIKit

class WechatSearchBarView: UIView {
    
    private var label = UILabel()

    init(title: String = "搜索") {
        super.init(frame: .init(origin: .zero, size: CGSize(width: 0, height: 60)))
        addSubview(label)
        backgroundColor = WXConfig.tableViewBgColor
        
        let textColor = UIColor.xy_getColor(red: 186, green: 186, blue: 186)
        
        if let icon = UIImage(named: "search_wx") {
            let att = NSTextAttachment(image: icon)
            att.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
            let attIcon = NSAttributedString(attachment: att)
            let attText = NSMutableAttributedString(string: "  \(title)")
            attText.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: attText.length))
            let text = NSMutableAttributedString(attributedString: attIcon)
            text.append(attText)
            label.textAlignment = .center
            label.attributedText = text
        }
        
        label.backgroundColor = .white
        label.corner(radius: 5)
        label.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(40)
        }
        
        // bgView for wx contact
        let bgView = UIView()
        insertSubview(bgView, at: 0)
        bgView.backgroundColor = backgroundColor
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(400)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
