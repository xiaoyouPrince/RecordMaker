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

class SendSystemMsgController: BaseSendMsgController {
    
    var callback: ((MsgSystemModel)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshContentUI()
    }
    
    func refreshContentUI() {
        setContentWithData(contentData(), itemConfig: { item in
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
                
                // real update ui
                if let cells = cell.superview?.subviews{
                    for theCell in cells {
                        if let theCell_ = theCell as? XYInfomationCell,
                           theCell_.model.title == "消息内容" {
                            let model = theCell_.model
                            model.value = content
                            theCell_.model = model
                        }
                    }
                }
            }
        }
    }
}

extension SendSystemMsgController {
    
    var systemModel: MsgSystemModel? {
        msgModel?.data?.toModel()
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        let section: [[String: Any]] = [
            [
                "title": "消息内容",
                "titleKey": "contentString",
                "type": XYInfoCellType.textView.rawValue,
                "cellHeight": 100,
                "value": systemModel?.content ?? ""
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
    
    @objc override func doneClick(){
        var params = totalParams
        let systemModel = MsgSystemModel()
        systemModel.content = params["contentString"] as? String ?? ""
        
        callback?(systemModel)
        if isEdit {
            msgModel?.updateContent(systemModel)
        }
        
        super.doneClick()
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
