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
    
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(label)
        
        backgroundColor = .red
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CellContentText: WXDetailContentProtocol {
    var contentClass: UIView.Type {
        CellContentText.self
    }
    
    func setModel(_ data: Data) {
        label.text = String(data: data, encoding: .utf8)
    }
    
    var showIconImage: Bool { true }
    
    var showNamelable: Bool { true }
    
    var showReadLabel: Bool { true }
}
