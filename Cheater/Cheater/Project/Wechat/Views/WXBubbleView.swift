//
//  WXBubbleView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/3.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 微信右上角点击加号按钮,弹出的气泡组件
 
 头部三角
 内容区域 - 点击事件处理
 点击事件 - 空白区点击关闭
 出场动画 && 关闭动画
 */

import UIKit
import XYUIKit

fileprivate class TriangleView: UIView {
    var fillColor: UIColor = .C_587CF7
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.beginPath()
        drawLines(with: context)
        context.closePath()
        context.setFillColor(fillColor.cgColor)
        context.setStrokeColor(UIColor.clear.cgColor)
        context.drawPath(using: .fillStroke)
    }
    
    func drawLines(with context: CGContext) {
        context.move(to: CGPoint(x: 7, y: 0))
        context.addLine(to: CGPoint(x: 0, y: 6))
        context.addLine(to: CGPoint(x: 14, y: 6))
    }
    
}

class WXBubbleView: UIView {

    private lazy var bgView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .C_587CF7
        contentView.corner(radius: 8)
        return contentView
    }()
    
    private lazy var triangleView: TriangleView = {
        let t = TriangleView(frame: .zero)
        t.backgroundColor = .clear
        return t
    }()
    
    /// 创建一个弹框
    /// - Parameters:
    ///   - actionTitles: 事件标题
    ///   - callback: 事件操作回调
    static func show(actionTitles: [String],  callback: ((Int)->())?) {
        let bubble = WXBubbleView.init(frame: .zero)
        
        bubble.backgroundColor = .clear
        
        bubble.setupContentView(actionTitles: actionTitles, callback: callback)
        
        bubble.show()
        
        bubble.addTap {sender in
            if let bubble = sender as? WXBubbleView {
                bubble.dismiss()
            }
        }
    }
}

private extension WXBubbleView {
    
    func setupContentView(actionTitles: [String],  callback: ((Int)->())?) {
        addSubview(bgView)
        bgView.addSubview(triangleView)
        bgView.addSubview(contentView)
        
        bgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(CGFloat.naviBar)
            make.width.greaterThanOrEqualTo(150)
        }
        
        triangleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(14)
            make.height.equalTo(6)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(triangleView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        var lastLabel: UIView?
        for (index, actionTitle) in actionTitles.enumerated() {
            let label = UILabel(frame: .zero)
            label.text = actionTitle
            label.textColor = .white
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .center
            contentView.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.left.equalTo(10)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(44)
                
                if index == 0 {
                    make.top.equalToSuperview()
                }else if let lastLabel = lastLabel {
                    make.top.equalTo(lastLabel.snp.bottom)
                }
                
                if index == actionTitles.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            
            label.addTap {[weak self] sender  in
                callback?(index)
                self?.dismiss()
            }
            
            lastLabel = label
            
            let line = UIView.line
            label.addSubview(line)
            line.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(CGFloat.line)
            }
        }
    }
}

private extension WXBubbleView {
    
    func setBeginTansform() {
        setNeedsLayout()
        layoutIfNeeded()
        let realFrame = self.bgView.frame
        
        #warning("此处位置和运行时size有关,无法写一个确定值,从这个角度看,此处目前无法自动适配")
        self.bgView.transform = .init(translationX: realFrame.size.width - 100, y: -realFrame.size.height + 100).scaledBy(x: 0.1, y: 0.1)
    }
    
    func show() {
        if let keyWindow = UIViewController.currentVisibleVC.view.window {
            keyWindow.addSubview(self)
            self.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            setBeginTansform()
            UIView.animate(withDuration: UINavigationController.hideShowBarDuration, delay: .zero) {
                self.bgView.transform = .identity
            }
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: UINavigationController.hideShowBarDuration, delay: .zero) {
            self.setBeginTansform()
            self.contentView.backgroundColor = .clear
        }completion: { finish in
            self.removeFromSuperview()
        }
    }
}
