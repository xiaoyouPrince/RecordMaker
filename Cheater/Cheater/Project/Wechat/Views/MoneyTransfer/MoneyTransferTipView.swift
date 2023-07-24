//
//  MoneyTransferTipView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/24.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 发转账页面中间的输入金额提示金额级别的view
 */

import UIKit
import XYUIKit

class MoneyTransferTipView: UIView {
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(label)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .C_wx_tip_text
        label.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(_ text: String? = nil) {
        label.text = text
    }
    
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.beginPath()
        drawLines(with: context, max: rect.width)
        context.closePath()
        context.setLineWidth(.line)
        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.line.cgColor)
        context.drawPath(using: .fillStroke)
    }
    
    func drawLines(with context: CGContext, max width: CGFloat) {
        let triWidth: CGFloat = 14
        let height: CGFloat = 6
        let start: CGPoint = CGPoint(x: width/2, y: 0)
        let left: CGPoint = CGPoint(x: start.x - triWidth/2, y: height)
        let right: CGPoint = CGPoint(x: start.x + triWidth/2, y: height)
        
        context.move(to: start)
        context.addLine(to: left)
        context.addLine(to: CGPoint(x: 0, y: height))
        context.move(to: start)
        context.addLine(to: right)
        context.move(to: right)
        context.addLine(to: CGPoint(x: width, y: height))
    }
}
