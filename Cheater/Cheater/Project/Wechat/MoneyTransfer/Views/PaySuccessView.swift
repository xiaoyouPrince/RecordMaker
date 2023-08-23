//
//  PaySuccessView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/22.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 支付成功 view
 * 参考转账成功页面头部的: [ icon + 支付成功 ]
 */

import UIKit

class PaySuccessView: UIView {
    static var shared: PaySuccessView = PaySuccessView()
    static func getInstance() -> PaySuccessView {
        PaySuccessView()
    }
    
    private init() {
        super.init(frame: .zero)
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PaySuccessView {
    func setupContentView() {
        
        let icon = UIImageView(image: UIImage(named: "share_poster_wechat_pay_tag_small_new"))
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.left.top.centerY.equalToSuperview()
        }
        
        let titleLabel = UILabel(title: "支付成功", font: .boldSystemFont(ofSize: 16), textColor: WXConfig.wxGreen, textAlignment: .center)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(8)
        }
    }
}
