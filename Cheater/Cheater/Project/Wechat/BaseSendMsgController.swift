//
//  BaseSendMsgController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/8.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 发送/编辑消息的一个基类
 
 UI:
     当前发言者头部
     具体内容 - 需要自定义
     确定按钮
 
 function:
 回调
 */

import UIKit
import XYUIKit
import XYInfomationSection

class BaseSendMsgController: XYInfomationBaseViewController {
    var msgModel: WXDetailModel?
    var senderId: Int = WXUserInfo.shared.id
    var msgTitle: String = "消息" {
        didSet { updateTitle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navVCs = navigationController?.viewControllers ?? []
        if let msgVC: WXDetailViewController = navVCs.dropLast().last as? WXDetailViewController {
            senderId = msgVC.currentSenderID
        }
        
        buildUI()
    }
    
    func buildUI() {
        
        self.view.backgroundColor = WXConfig.navBarBgColor
        
        nav_setCustom(backImage: WXConfig.wx_backImag)
        updateTitle()
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(doneClick), title: isEdit ? "保存" : "添加")
        
        buildHeader()
        
        let button = UIButton(type: .system)
        button.setTitle(isEdit ? "保存" : "添加", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = WXConfig.wxGreen
        button.corner(radius: 5)
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        button.addTap { [weak self] sender in
            guard let self = self else { return }
            self.doneClick()
        }
        setFooterView(button, edgeInsets: .init(top: 20, left: 10, bottom: 0, right: 10))
    }
    
    func updateTitle(){
        title = isEdit ? "编辑" + msgTitle : "添加" + msgTitle
    }
    
    func buildHeader(){
        let title = speakerTitleIcon.0
        let imageData = speakerTitleIcon.1
        
        let section = XYInfomationSection()
        let tip = XYInfomationItem()
        tip.title = "当前消息发送方"
        tip.type = .tip
        tip.isHideSeparateLine = true
        
        let item = XYInfomationItem()
        item.title = title
        item.type = XYInfoCellType.other
        item.customCellClass = SenderCell.self
        item.obj = imageData as Any
        
        section.dataArray = [tip, item]
        self.setHeaderView(section, edgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10))
    }
}

extension BaseSendMsgController {
    
    var isEdit: Bool {  msgModel != nil }
    /// 当前是否我发言 - 指代发消息时
    var isMeSpeaking: Bool {
        let mineID = WXUserInfo.shared.id
        return mineID == senderId
    }
    
    /// 消息是否是由我发出的 - 指代消息编辑时
    var isMsgSendByMe: Bool {
        let mineID = WXUserInfo.shared.id
        return msgModel?.from == mineID
    }
    
    /// 消息是否是我方消息
    var isMsgBelongsToMe: Bool {
        if isEdit {
            return isMsgSendByMe
        }else{
            return isMeSpeaking
        }
    }
    
    /// 当前发言者的 title 和 头像icon
    var speakerTitleIcon: (String, Data) {
        if !isMsgBelongsToMe {
            return targetTitleIcon
        }
        
        let title = WXUserInfo.shared.name
        let imageData = WXUserInfo.shared.icon?.pngData()
        return (title ?? "", imageData ?? Data())
    }
    /// 当前会话对端用户 title 和 头像icon
    var targetTitleIcon: (String, Data) {
        let title = DataSource_wxDetail.targetContact?.title
        let imageData = DataSource_wxDetail.targetContact?.image?.pngData()
        return (title ?? "", imageData ?? Data())
    }
    
    /// 获取当前页面编辑的所有参数
    var totalParams: [AnyHashable: Any] {
        var params: [AnyHashable: Any] = [:]
        self.view.findSubViewRecursion { subview in
            if let section = subview as? XYInfomationSection {
                params = section.contentKeyValues
                return true
            }
            return false
        }
        return params
    }
    
    /// 获取当前页面编辑的所有参数
    var totalModels: [XYInfomationItem] {
        var result: [XYInfomationItem] = []
        self.view.findSubViewRecursion { subview in
            if let section = subview as? XYInfomationSection {
                result.append(contentsOf: section.dataArray)
                return true
            }
            return false
        }
        return result
    }
    
    @objc func doneClick(){
        navigationController?.popViewController(animated: true)
    }
}

