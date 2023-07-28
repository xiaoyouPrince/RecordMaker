//
//  MineInfoView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/14.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import Foundation
import XYUIKit

class MineInfoView : UIControl {
    
    typealias CallBack = (()->())
    /// 添加状态按钮点击回调
    var addStatusCallback: ((CallBack)->())?
    /// 查看状态按钮点击回调
    var findStatusCallback: ((CallBack)->())?
    
    private var iconView = UIImageView()
    private var nameLabel = UILabel()
    private var wechatLabel = UILabel()
    private var qrCodeIcon = UIImageView()
    private var rightArrawIcon = UIImageView()
    private var addStatusBtn = UIButton()
    private var findStatusBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        [iconView,
         nameLabel,
         wechatLabel,
         qrCodeIcon,
         rightArrawIcon,
         addStatusBtn,
         findStatusBtn].forEach { subView in
            self.addSubview(subView)
        }
        
        iconView.image = WXUserInfo.shared.icon
        iconView.corner(radius: 5)
        iconView.snp.makeConstraints { make in
            make.left.top.equalTo(20)
            make.width.height.equalTo(60)
        }
        
        nameLabel.text = WXUserInfo.shared.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView).offset(5)
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-60)
        }
        
        wechatLabel.text = "微信号:" + (WXUserInfo.shared.wechatId ?? "")
        wechatLabel.font = UIFont.systemFont(ofSize: 14)
        wechatLabel.textColor = .lightGray
        wechatLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        addStatusBtn.setTitle("+ 状态", for: .normal)
        addStatusBtn.setTitleColor(.lightGray, for: .normal)
        addStatusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addStatusBtn.corner(radius: 10)
        addStatusBtn.border(color: UIColor.lightGray, width: 0.5)
        //addStatusBtn.setImage(UIImage(named: "zhuangtaijia"), for: .normal)
        addStatusBtn.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(wechatLabel.snp.bottom).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-35)
        }
        
        findStatusBtn.setImage(UIImage(named: "wxMine_dian"), for: .normal)
        findStatusBtn.border(color: UIColor.lightGray, width: 0.5)
        findStatusBtn.corner(radius: 10)
        findStatusBtn.snp.makeConstraints { make in
            make.left.equalTo(addStatusBtn.snp.right).offset(10)
            make.top.equalTo(addStatusBtn)
            make.width.height.equalTo(20)
        }
        
        rightArrawIcon.image = UIImage(named: "youjiantou")
        rightArrawIcon.snp.makeConstraints { make in
            make.centerY.equalTo(wechatLabel)
            make.right.equalToSuperview().offset(-15)
        }
        
        qrCodeIcon.image = UIImage(named: "wechat_mineewm")
        qrCodeIcon.snp.makeConstraints { make in
            make.centerY.equalTo(rightArrawIcon)
            make.right.equalTo(rightArrawIcon.snp.left).offset(-20)
        }
        
        // action
        addStatusBtn.addBlock(for: .touchUpInside) { [weak self] sender in
            guard let self = self else { return }
            self.addStatusCallback?(self.setFindStatusShow)
        }
        
        findStatusBtn.addBlock(for: .touchUpInside) { [weak self] sender in
            guard let self = self else { return }
            self.findStatusCallback?(self.setFindStatusHidden)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MineInfoView {
    
    func setFindStatusShow() {
        findStatusBtn.isHidden = false
    }
    
    func setFindStatusHidden() {
        findStatusBtn.isHidden = true
    }
    
    func updateUserInfo() {
        iconView.image = WXUserInfo.shared.icon
        nameLabel.text = WXUserInfo.shared.name
        wechatLabel.text = "微信号" + (WXUserInfo.shared.wechatId ?? "")
    }
}
