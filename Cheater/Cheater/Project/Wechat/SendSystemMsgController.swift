//
//  SendSystemMsgController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/8.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 发送系统消息的控制器,可以编辑
 *
 *  单聊 - 发送 / 编辑
 *  群聊 - 发送 / 编辑
 */

import UIKit
import XYUIKit
import XYInfomationSection

class SendSystemMsgController: XYInfomationBaseViewController {
    
    var callback: ((MsgSystemModel)->())?
    var msgModel: WXDetailModel?
    var senderId: Int = WXUserInfo.shared.id

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
        title = isEdit ? "编辑消息" : "添加系统消息"
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(doneClick), title: isEdit ? "保存" : "添加")
        
        refreshContentUI()
        
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
    
    func refreshContentUI(_ content: String? = nil) {
        setContentWithData(contentData(content), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) {[weak self] index, cell in
            guard let self = self else { return }
            if cell.model.customCellClass == BtnCell.self {
                var content = ""
                if cell.model.titleKey == "打招呼内容" {
                    content = "以上是打招呼内容"
                }
                if cell.model.titleKey == "添加好友消息" {
                    content = "你已经添加了\(self.targetTitleIcon.0),现在可以开始聊天了"
                }
                if cell.model.titleKey == "拍一拍" {
                    if self.isMeSpeaking {
                        content = "我拍了拍\"\(self.targetTitleIcon.0)\""
                    }else{
                        content = "\"\(self.targetTitleIcon.0)\"拍了拍我"
                    }
                }
                
                self.refreshContentUI(content)
            }
        }
    }

}

extension SendSystemMsgController {
    
    var isEdit: Bool {  msgModel != nil }
    var isMeSpeaking: Bool {
        let from = WXUserInfo.shared.id
        return senderId == from
    }
    
    /// 当前发言者的 title 和 头像icon
    var speakerTitleIcon: (String, Data) {
        if !isMeSpeaking {
            return targetTitleIcon
        }
        
        var title = WXUserInfo.shared.name
        var imageData = WXUserInfo.shared.icon?.pngData()
        return (title ?? "", imageData ?? Data())
    }
    /// 当前会话对端用户 title 和 头像icon
    var targetTitleIcon: (String, Data) {
        var title = DataSource_wxDetail.targetContact?.title
        var imageData = DataSource_wxDetail.targetContact?.image?.pngData()
        return (title ?? "", imageData ?? Data())
    }
    
    func contentData(_ content: String? = nil) -> [Any] {
        var result = [Any]()
        
        var title = speakerTitleIcon.0
        var imageData = speakerTitleIcon.1
        
        let section: [[String: Any]] = [
            [
                "title": title,
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": SenderCell.self,
                "obj": imageData as Any
            ],
            [
                "title": "消息内容",
                "titleKey": "contentString",
                "type": XYInfoCellType.textView.rawValue,
                "cellHeight": 100,
                "value": content ?? ""
            ],
            [
                "title": "打招呼内容",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": BtnCell.self
            ],
            [
                "title": "添加好友消息",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": BtnCell.self
            ],
            [
                "title": "拍一拍",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": BtnCell.self
            ],
        ]
        
        result.append(section)
        return result
    }
    
    @objc func doneClick(){
        var params: [AnyHashable: Any] = [:]
        self.view.findSubViewRecursion { subview in
            if let section = subview as? XYInfomationSection {
                params = section.contentKeyValues
                return true
            }
            return false
        }
        
        let systemModel = MsgSystemModel()
        systemModel.content = params["contentString"] as? String ?? ""
        
        callback?(systemModel)
        if isEdit {
            msgModel?.data = systemModel.toData
        }
        navigationController?.popViewController(animated: true)
    }
}

class BtnCell: XYInfomationCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(label)
        
        label.textAlignment = .center
        label.backgroundColor = .C_wx_red_button
        label.corner(radius: 17)
        label.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.height.equalTo(34)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model: XYInfomationItem{
        didSet {
            label.text = model.title
        }
    }
}
