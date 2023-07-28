//
//  WXPayHUD.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/25.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 微信支付的 HUD
 *
 *  1. 可指定 hud 时长
 *  2. 指定时长之后, 回调完成
 */

import UIKit

class WXPayHUD: UIView {
    
    private let icon = UIImage(named: "Wechatpay_Loading_Icon_40x35_")
    
    private let bgView = UIView()
    private let iconView = UIImageView()
    private let label = UILabel(title: "微信支付", font: .boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .center)
    private let dotView = UIImageView()
    
    override private init(frame: CGRect) {
        super.init(frame: .zero)
        buildUI()
        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func show(_ duration: TimeInterval = 2, callBack: @escaping ()->()){
        if let keyWindow = UIViewController.currentVisibleVC.view.window {
            let hud = WXPayHUD()
            keyWindow.addSubview(hud)
            hud.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            // 所有内容暂停第一响应者,理论上调用方做比较合适,但是感觉这个工具应该也做一下
            keyWindow.findSubViewRecursion { subView in
                subView.resignFirstResponder()
                return false
            }
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + duration, execute: {
                hud.dismiss()
                callBack()
            })
        }
    }
}

private extension WXPayHUD {
    func buildUI() {
        backgroundColor = .clear
        
        addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(label)
        bgView.addSubview(dotView)
        
        bgView.corner(radius: 15)
        bgView.backgroundColor = .C_666666
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(134)
            make.height.equalTo(134)
        }
        
        iconView.image = icon
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(15)
        }
        
        dotView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(12)
        }
    }
    
    func startAnimation() {
        dotView.animationImages = [drawDotImage(type: 3), drawDotImage(type: 2), drawDotImage(type: 1)]
        dotView.animationDuration = 1.25
        dotView.startAnimating()
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    /// 绘制一个点动画图片, 没有找到资源,费力找资源太耗时,直接绘制吧
    /// - Parameter type: 1/2/3 分贝代表左中右
    /// - Returns: 一个图片
    func drawDotImage(type: Int) -> UIImage {
        
        let width: CGFloat = 40
        let height: CGFloat = 20
        let imageSize = CGSize.init(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        // Set the background color
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: imageSize))
        
        // Draw a circle in the left
        let circleRect = CGRect(x: width/2 - 4, y: height/2 - 4, width: 8, height: 8)
        context.setFillColor(UIColor.white.withAlphaComponent(0.2).cgColor)
        if type == 1 {
            context.setFillColor(UIColor.white.cgColor)
        }
        context.fillEllipse(in: circleRect)
        
        // Draw a circle in the center
        let circleRect2 = CGRect(x: width/2 - 4 - 16, y: height/2 - 4, width: 8, height: 8)
        context.setFillColor(UIColor.white.withAlphaComponent(0.2).cgColor)
        if type == 2 {
            context.setFillColor(UIColor.white.cgColor)
        }
        context.fillEllipse(in: circleRect2)
        
        // Draw a circle in the right
        let circleRect3 = CGRect(x: width/2 - 4 + 16, y: height/2 - 4, width: 8, height: 8)
        context.setFillColor(UIColor.white.withAlphaComponent(0.2).cgColor)
        if type == 3 {
            context.setFillColor(UIColor.white.cgColor)
        }
        context.fillEllipse(in: circleRect3)
        
        // Get the final image from the context
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        
        // End the context
        UIGraphicsEndImageContext()
        
        return image
    }
}
