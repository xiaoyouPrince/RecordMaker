//
//  WXDetailCell.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

protocol WXDetailCellDelegate: AnyObject {
    
    /// 设置为用户被删除
    /// - Parameter model: 当前 model
    func deleteUserForMsg(_ model: WXDetailModel)
    
    /// 取消用户被删除
    /// - Parameter model: 当前 model
    func cancelDeleteUserForMsg(_ model: WXDetailModel)
    
    /// 设置为用户被删除
    /// - Parameter model: 当前 model
    func blockUserForMsg(_ model: WXDetailModel)
    
    /// 取消用户被删除
    /// - Parameter model: 当前 model
    func cancelBlockUserForMsg(_ model: WXDetailModel)
    
    /// 复制内容
    /// - Parameter model: 当前 model
    func copyTextForMsg(_ model: WXDetailModel)
    
    /// 编辑消息
    /// - Parameter model: 当前 model
    func editForMsg(_ model: WXDetailModel)
    
    /// 撤回消息
    /// - Parameter model: 当前 model
    func recallForMsg(_ model: WXDetailModel)
    
    /// 消息被删除
    /// - Parameter model: 当前 cemodelll
    func deleteMsg(_ model: WXDetailModel)
    
    /// 切换用户
    /// - Parameter model: 当前 model
    func changeSenderForMsg(_ model: WXDetailModel)
    
    /// 引用消息
    /// - Parameter model: 当前 cemodelll
    func referenceMsg(_ model: WXDetailModel)
}

class WXDetailCell: UITableViewCell {
    
    static let indentifier = "WXDetailCell"
    weak var delegate: WXDetailCellDelegate?
    var model: WXDetailModel? {
        didSet { modelDidSet() }
    }
    
    private var iconImage: UIImageView = UIImageView()
    private var nameLabel: UILabel = UILabel()
    private lazy var deletetBtn = getDeleteBtn()
    private var bubbleView = UIControl()
    private var bottomView = UIControl()
    private var statusBtn: UIButton = UIButton(type: .system)
    private var lastContent: UIView?
    
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
        iconImage.corner(radius: 5)
        contentView.addSubview(iconImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bubbleView)
        contentView.addSubview(deletetBtn)
        contentView.addSubview(bottomView)
        contentView.addSubview(statusBtn)
        
        bubbleView.addLongPress {[weak self] sender in
            guard let self = self,
                  let sender = sender as? UIControl,
                  let model = self.model else { return }
            
            MsgCellMenuManageer.showMenu(onView: sender, forMsg: model) {[weak self] title in
                self?.cellAction(title: title)
            }
        }
    }
}

extension WXDetailCell {
    
    /// Cell 本身的事件处理
    /// - Parameter title: 事件名称
    func cellAction(title: String) {
        guard let model = self.model else { return }
        
        let cellAction: CellMenuAction? = CellMenuAction(rawValue: title)
        switch cellAction {
        case .userDeleted:
            delegate?.deleteUserForMsg(model)
        case .cancelUserDeleted:
            delegate?.cancelDeleteUserForMsg(model)
        case .userBlocked:
            delegate?.blockUserForMsg(model)
        case .cancelUserBlocked:
            delegate?.cancelBlockUserForMsg(model)
        case .copy:
            delegate?.copyTextForMsg(model)
        case .edit:
            delegate?.editForMsg(model)
        case .recall:
            delegate?.recallForMsg(model)
        case .msgDelete:
            delegate?.deleteMsg(model)
        case .changeUser:
            delegate?.changeSenderForMsg(model)
        case .refer:
            delegate?.referenceMsg(model)
        default:
            break
        }
    }
}

extension WXDetailCell {
    
    func modelDidSet() {
        guard let model = model else { return }
        
        if model.isOutGoingMsg {
            iconImage.image = WXUserInfo.shared.icon
        }else{
            iconImage.image = DataSource_wxDetail.targetContact?.image
        }
        
        nameLabel.text = DataSource_wxDetail.targetContact?.title
        statusBtn.setTitle("哈", for: . normal)
        
        setupDeleteByUserOrNot()
        
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
        }else{ // can not reuse, need remove the old one, and create a new one
            lastContent?.removeFromSuperview()
            removeAllContraints()
            
            let innerView = model.contentClass.init() as! UIView
            bubbleView.addSubview(innerView)
            lastContent = innerView
            innerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            setupInnerView(model: model, innerView: innerView)
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
        
        layoutBottomView()
    }
}

extension WXDetailCell {
    
    struct Margin {
        static let leftMargin = 12
        static let topMargin = 8
        static let iconSize = 46
    }
    
    /// 我发送消息的布局
    func layoutForMeSend() {
        
        if iconImage.isHidden { // 默认 iconHidden, name 一定是 hidden
            bubbleView.snp.remakeConstraints { make in
                make.right.equalTo(-Margin.leftMargin)
                make.left.greaterThanOrEqualTo((Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                make.top.equalTo(Margin.topMargin)
                //make.bottom.lessThanOrEqualToSuperview().offset(-Margin.topMargin)
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
                    make.left.greaterThanOrEqualTo((Margin.leftMargin * 2 + Margin.iconSize)) // 左边留一个边距
                    make.top.equalTo(iconImage)
                    //make.bottom.lessThanOrEqualTo(-Margin.topMargin)
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
                    make.left.greaterThanOrEqualTo((Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                    make.top.equalTo(nameLabel.snp.bottom).offset(5)
                    //make.bottom.lessThanOrEqualTo(-Margin.topMargin)
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
        
        
        deletetBtn.snp.remakeConstraints { make in
            make.right.equalTo(bubbleView.snp.left).offset(-5)
            make.centerY.equalTo(bubbleView)
        }
        
    }
    
    /// 对方发送消息的布局
    func layoutForOtherSend() {
        
        if iconImage.isHidden { // 默认 iconHidden, name 一定是 hidden
            bubbleView.snp.remakeConstraints { make in
                make.left.equalTo(Margin.leftMargin)
                make.right.lessThanOrEqualTo(-(Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                make.top.equalTo(Margin.topMargin)
                //make.bottom.lessThanOrEqualToSuperview().offset(-Margin.topMargin)
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
                    make.right.lessThanOrEqualTo(-(Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                    make.top.equalTo(iconImage)
                    //make.bottom.lessThanOrEqualTo(-Margin.topMargin)
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
                    make.right.lessThanOrEqualTo(-(Margin.leftMargin * 2 + Margin.iconSize)) // 右边留一个边距
                    make.top.equalTo(nameLabel.snp.bottom).offset(5)
                    //make.bottom.lessThanOrEqualTo(-Margin.topMargin)
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
        
        deletetBtn.snp.remakeConstraints { make in
            make.left.equalTo(bubbleView.snp.right).offset(5)
            make.centerY.equalTo(bubbleView)
        }
    }
    
    /// 完全自定义的布局
    /// 整个cell区域,都是自定义区域,不展示默认所有内容
    func layoutForFullCustom() {
        bubbleView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 移除所有的约束,当复用cell,但是其content无法复用的时候,就需要移除旧的约束,完全使用新约束
    func removeAllContraints() {
        contentView.snp.removeConstraints()
        contentView.subviews.forEach { subV in
            subV.snp.removeConstraints()
        }
    }
    
    private func getDeleteBtn() -> UIButton{
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "buddle-msg-error")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }
    
    /// 对底部内容布局
    func layoutBottomView() {
        var topMargin = 0
        if model?.isUserBeingDeleted == true {
            topMargin = Margin.topMargin
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(bubbleView.snp.bottom).offset(topMargin)
            make.bottom.lessThanOrEqualToSuperview().offset(-Margin.topMargin)
        }
    }
    
    /// 设置是否被对方删除
    func setupDeleteByUserOrNot() {
        guard let model = self.model else { return }
        
        if model.isUserBeingDeleted == true {
            let targetname = DataSource_wxDetail.targetContact?.title ?? "对方"
            let str = targetname + "开启了朋友验证,你还不是他(她)朋友.请先发送朋友验证请求,对方通过后才能聊天. 发送朋友验证"
            let label = UILabel(title: str, font: .systemFont(ofSize: 15), textColor: .C_wx_tip_text, textAlignment: .center)
            label.numberOfLines = 0
            label.attributedText = str.addAttributes(attrs: [.foregroundColor: UIColor.C_wx_link_text], withRegx: " 发送朋友验证")
            bottomView.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.bottom.equalToSuperview()
                make.top.equalTo(8)
            }
        }else{
            bottomView.subviews.forEach { subV in
                subV.removeFromSuperview()
            }
        }
        
        if model.isUserBeingBlocked == true {
            deletetBtn.isHidden = false
        }else{
            deletetBtn.isHidden = true
        }
    }
}
