//
//  WXDetailCell.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

class WXDetailCell: UITableViewCell {
    
    static let indentifier = "WXDetailCell"
    var model: WXDetailModel? {
        didSet {
            guard let model = model else { return }
        
            if model.isOutGoingMsg {
                iconImage.image = WXUserInfo.shared.icon
            }else{
                iconImage.image = DataSource_wxDetail.targetContact?.image
            }
            
            nameLabel.text = DataSource_wxDetail.targetContact?.title
            statusBtn.setTitle("哈", for: . normal)
            
            guard let innerView = lastContent else { // not create, create and save it
                let innerView = model.contentClass.init() as! UIView
                bubbleView.addSubview(innerView)
                lastContent = innerView
                innerView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                setupInnerView(model: model, innerView: innerView)
                return
            }

            if type(of: innerView) == model.contentClass { // can reuse
                lastContent = innerView
                setupInnerView(model: model, innerView: innerView)
            }else{ // can not reuse, nedd remove the old one, and create a new one
                lastContent?.removeFromSuperview()
                
                let innerView = model.contentClass.init() as! UIView
                bubbleView.addSubview(innerView)
                lastContent = innerView
                innerView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                setupInnerView(model: model, innerView: innerView)
            }
        }
    }
    
    func setupInnerView(model: WXDetailModel, innerView: UIView) {
        guard let contentView = innerView as? WXDetailContentProtocol else { return }
        contentView.setModel(model)
        
        iconImage.isHidden = !contentView.showIconImage
        nameLabel.isHidden = !contentView.showNamelable
        statusBtn.isHidden = !contentView.showReadLabel
        
        if contentView.fullCustom {
            iconImage.isHidden = true
            nameLabel.isHidden = true
            statusBtn.isHidden = true
            
            layoutForFullCustom()
            return
        }
        
        // real layout
        if model.isOutGoingMsg {
            nameLabel.textAlignment = .right
            layoutForMeSend()
        }else{
            nameLabel.textAlignment = .left
            layoutForOtherSend()
        }
    }
    
    var iconImage: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var bubbleView = UIControl()
    var statusBtn: UIButton = UIButton(type: .system)
    var lastContent: UIView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)
        
    }
    
    func buildUI() {
        backgroundColor = WXConfig.navBarBgColor
        contentView.addSubview(iconImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bubbleView)
        contentView.addSubview(statusBtn)
        
        bubbleView.addLongPress { sender in
            guard let sender = sender as? UIControl else { return }
            
            // 复制
            let copy = UIMenuItem(title: "复制", action: #selector(self.copyText))
            
            // 编辑
            let edit = UIMenuItem(title: "编辑", action: #selector(self.cellEdit))
            
            
            let mc = UIMenuController.shared
            mc.menuItems = [copy, edit]
            mc.showMenu(from: sender, rect: sender.subviews.first?.frame ?? .zero)
        }
    }
    
    @objc func copyText(){
        Toast.make("复制 -- 细节功能较多,主要架子完成后一点点细化")
    }
    
    @objc func cellEdit(){
        Toast.make("复制 -- 细节功能较多,主要架子完成后一点点细化")
        
        if model?.msgType == .voice, let model = self.model {
            viewController?.push(SendAudioViewController(msgModel: model), animated: true) 
        }
    }
}

extension WXDetailCell {
    
    struct Margin {
        static let leftMargin = 12
        static let topMargin = 8
        static let iconSize = 50
    }
    
    /// 我发送消息的布局
    func layoutForMeSend() {
        
        if iconImage.isHidden { // 默认 iconHidden, name 一定是 hidden
            bubbleView.snp.remakeConstraints { make in
                make.right.equalTo(-Margin.leftMargin)
                make.left.equalTo((Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                make.top.equalTo(Margin.topMargin)
                make.bottom.lessThanOrEqualToSuperview().offset(-Margin.topMargin)
            }
            
            if statusBtn.isHidden {
                // nothing
            } else {
                statusBtn.snp.remakeConstraints { make in
                    make.right.equalTo(bubbleView.snp.left).offset(-3)
                    make.bottom.equalTo(bubbleView)
                    make.size.equalTo(CGSize.init(width: 40, height: 30))
                }
            }
            
        } else {
            
            iconImage.snp.remakeConstraints { make in
                make.width.height.equalTo(Margin.iconSize)
                make.right.equalTo(-Margin.leftMargin)
                make.top.equalTo(Margin.topMargin)
                make.bottom.lessThanOrEqualTo(-Margin.topMargin)
            }
            
            if nameLabel.isHidden {
                bubbleView.snp.remakeConstraints { make in
                    make.right.equalTo(iconImage.snp.left).offset(-5)
                    make.left.equalTo((Margin.leftMargin * 2 + Margin.iconSize)) // 左边留一个边距
                    make.top.equalTo(iconImage)
                    make.bottom.lessThanOrEqualTo(-Margin.topMargin)
                }
                
                if statusBtn.isHidden {
                    // nothing
                } else {
                    statusBtn.snp.remakeConstraints { make in
                        make.right.equalTo(bubbleView.snp.left).offset(-3)
                        make.bottom.equalTo(bubbleView)
                        make.size.equalTo(CGSize.init(width: 40, height: 30))
                    }
                }
            }else
            {
                nameLabel.snp.remakeConstraints { make in
                    make.right.equalTo(iconImage.snp.left).offset(-5)
                    make.top.equalTo(iconImage)
                }
                
                bubbleView.snp.remakeConstraints { make in
                    make.right.equalTo(nameLabel)
                    make.left.equalTo((Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                    make.top.equalTo(nameLabel.snp.bottom).offset(5)
                    make.bottom.lessThanOrEqualTo(-Margin.topMargin)
                }

                if statusBtn.isHidden {
                    // nothing
                } else {
                    statusBtn.snp.remakeConstraints { make in
                        make.right.equalTo(bubbleView.snp.left).offset(-3)
                        make.bottom.equalTo(bubbleView)
                        make.size.equalTo(CGSize.init(width: 40, height: 30))
                    }
                }
            }
        }
    }
    
    
    /// 对方发送消息的布局
    func layoutForOtherSend() {
        
        if iconImage.isHidden { // 默认 iconHidden, name 一定是 hidden
            bubbleView.snp.remakeConstraints { make in
                make.left.equalTo(Margin.leftMargin)
                make.right.equalTo(-(Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                make.top.equalTo(Margin.topMargin)
                make.bottom.lessThanOrEqualToSuperview().offset(-Margin.topMargin)
            }
            
            if statusBtn.isHidden {
                // nothing
            } else {
                statusBtn.snp.remakeConstraints { make in
                    make.left.equalTo(bubbleView.snp.right).offset(3)
                    make.bottom.equalTo(bubbleView)
                    make.size.equalTo(CGSize.init(width: 40, height: 30))
                }
            }
            
        } else {
            
            iconImage.snp.remakeConstraints { make in
                make.width.height.equalTo(Margin.iconSize)
                make.left.equalTo(Margin.leftMargin)
                make.top.equalTo(Margin.topMargin)
                make.bottom.lessThanOrEqualTo(-Margin.topMargin)
            }
            
            if nameLabel.isHidden {
                bubbleView.snp.remakeConstraints { make in
                    make.left.equalTo(iconImage.snp.right).offset(5)
                    make.right.equalTo(-(Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                    make.top.equalTo(iconImage)
                    make.bottom.lessThanOrEqualTo(-Margin.topMargin)
                }
                
                if statusBtn.isHidden {
                    // nothing
                } else {
                    statusBtn.snp.remakeConstraints { make in
                        make.left.equalTo(bubbleView.snp.right).offset(3)
                        make.bottom.equalTo(bubbleView)
                        make.size.equalTo(CGSize.init(width: 40, height: 30))
                    }
                }
            }else
            {
                nameLabel.snp.remakeConstraints { make in
                    make.left.equalTo(iconImage.snp.right).offset(5)
                    make.top.equalTo(iconImage)
                }
                
                bubbleView.snp.remakeConstraints { make in
                    make.left.equalTo(nameLabel)
                    make.right.equalTo(-(Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                    make.top.equalTo(nameLabel.snp.bottom).offset(5)
                    make.bottom.lessThanOrEqualTo(-Margin.topMargin)
                }
                
                if statusBtn.isHidden {
                    // nothing
                } else {
                    statusBtn.snp.remakeConstraints { make in
                        make.left.equalTo(bubbleView.snp.right).offset(3)
                        make.bottom.equalTo(bubbleView)
                        make.size.equalTo(CGSize.init(width: 40, height: 30))
                    }
                }
            }
        }
    }
    
    /// 完全自定义的布局
    /// 整个cell区域,都是自定义区域,不展示默认所有内容
    func layoutForFullCustom() {
        bubbleView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
