//
//  TimelineTableHeader.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/9/4.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 朋友圈 header view
 *
 *  1. bgView
 *  2. userInfo
 */

import UIKit

class TimelineTableHeader: UIView {
    private let bgView = UIImageView()
    private let titleLabel = UILabel(title: "", font: .boldSystemFont(ofSize: 18), textColor: .white, textAlignment: .right)
    private let iconView = UIImageView()
    private let signLabel = UILabel(title: "", font: .systemFont(ofSize: 14), textColor: .C_wx_tip_text, textAlignment: .right)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        updateContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        addSubview(bgView)
        addSubview(signLabel)
        addSubview(iconView)
        addSubview(titleLabel)
        
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(CGFloat.width * 0.7)
        }
        
        iconView.corner(radius: 10)
        iconView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalTo(bgView).offset(20)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualToSuperview()
            make.top.equalTo(iconView.snp.top).offset(20)
            make.right.equalTo(iconView.snp.left).offset(-5)
        }
        
        signLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

extension TimelineTableHeader {
    func updateContent() {
        
        bgView.image = UIImage(named: "timeline-bg")
        iconView.image = .defaultHead
        titleLabel.text = "嗯嗯🤔️"
        signLabel.text = "弃我去者,昨日之日不可留.乱我心者,今日之日多烦忧"
        let textheight = signLabel.text?.heightOf(font: signLabel.font, size: CGSize(width: .width - 10, height: 200))
        self.bounds.size.height = CGFloat.width * 0.7 + 40 + (textheight ?? 0)
    }
}
