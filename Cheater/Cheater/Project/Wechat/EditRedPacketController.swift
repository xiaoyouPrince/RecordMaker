//
//  EditRedPacketController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/13.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import Foundation

/*
 * - TODO -
 * 编辑红包控制器
 *
 */

import Foundation
import XYUIKit
import XYInfomationSection

class EditRedPacketController: BaseSendMsgController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "编辑红包"
        
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
        }
    }
    
    var redpacketModel: MsgRedPacketModel? {
        msgModel?.data?.toModel()
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        let section: [[String: Any]] = [
            [
                "title": "金额",
                "titleKey": "money",
                "type": XYInfoCellType.input.rawValue,
                "value": redpacketModel?.amountOfMoney ?? ""
            ],
             [
                "title": "红包祝福语",
                "titleKey": "text",
                "type": XYInfoCellType.textView.rawValue,
                "cellHeight": 100,
                "value": redpacketModel?.sayingWords ?? ""
             ]
        ]
        
        result.append(section)
        return result
    }
    
    override func doneClick() {
        guard let model = redpacketModel else { return }
        let params = totalParams
        
        model.amountOfMoney = params["money"] as? String
        model.sayingWords = params["text"] as? String
        
        msgModel?.updateContent(model)
        super.doneClick()
    }
}


class EditMoneyTransferController: BaseSendMsgController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "编辑转账"
        
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
        }
    }
    
    var redpacketModel: MsgMoneyTransferModel? {
        msgModel?.data?.toModel()
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        let section: [[String: Any]] = [
            [
                "title": "金额",
                "titleKey": "money",
                "type": XYInfoCellType.input.rawValue,
                "value": redpacketModel?.amountOfMoney ?? ""
            ],
            [
                "title": "转账留言",
                "titleKey": "text",
                "type": XYInfoCellType.textView.rawValue,
                "cellHeight": 100,
                "value": redpacketModel?.transferInstructions ?? ""
            ]
        ]
        
        result.append(section)
        return result
    }
    
    override func doneClick() {
        guard let model = redpacketModel else { return }
        let params = totalParams
        
        model.amountOfMoney = params["money"] as? String
        model.transferInstructions = params["text"] as? String
        
        msgModel?.updateContent(model)
        super.doneClick()
    }
}
