//
//  SendIDCardController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit
import XYInfomationSection

class SendIDCardController: BaseSendMsgController {
    
    var callback: ((MsgModelIDCard)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            if cell.model.titleKey == "iconData" {
                ChoosePhotoController.choosePhoto { image in
                    let model = cell.model
                    model.obj = image as Any
                    cell.model = model
                }
            }
        }
    }
    
    var idcardModel: MsgModelIDCard? {
        msgModel?.data?.toModel()
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        let section: [[String: Any]] = [
            [
                "title": "昵称",
                "titleKey": "name",
                "type": XYInfoCellType.input.rawValue,
                "value": idcardModel?.name ?? ""
            ],
            [
                "title": "头像",
                "titleKey": "iconData",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": PhotoCell.self,
                "obj": idcardModel?.icon ?? UIImage.defaultHead as Any
            ],
            [
                "title": "微信号",
                "titleKey": "wechatID",
                "type": XYInfoCellType.input.rawValue,
                "value": idcardModel?.wechatID ?? ""
            ],
            [
                "title": "是否是公众号名片",
                "titleKey": "isOfficial",
                "type": XYInfoCellType.switch.rawValue,
                "isOn": idcardModel?.isOfficial ?? false
            ]
        ]
        
        result.append(section)
        return result
    }

    override func doneClick() {
        super.doneClick()
        let params = totalParams
        let allItems = totalModels
        
        let idcard = MsgModelIDCard()
        idcard.name = params["name"] as? String
        idcard.wechatID = params["wechatID"] as? String
        let isOfficial = params["isOfficial"] as? String
        idcard.isOfficial = (isOfficial == "1")
        
        for model in allItems {
            if model.titleKey == "iconData" {
                idcard.iconData = (model.obj as? UIImage)?.pngData()
            }
        }
        
        if isEdit {
            msgModel?.updateContent(idcard)
        }
        
        callback?(idcard)
        // Toast.make(params.description)
    }
   
}
