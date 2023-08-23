//
//  EditMoneyTransferController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/23.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 微信转账页面的编辑 - 这里是直接从App首页进入的微信转账页面的编辑
 */

import UIKit
import XYUIKit
import XYInfomationSection

class EditMoneyTransferController2: BaseSendMsgController {
    private var mtModel: MTModel?
    private var callback: ((MTModel)->())?
    
    func setModel(model: MTModel, callback: ((MTModel)->())?) {
        self.mtModel = model
        self.callback = callback
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderView(.init(), edgeInsets: .zero)
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            if cell.model.titleKey == "icon" {
                ChoosePhotoController.choosePhoto { image in
                    let model = cell.model
                    model.obj = image as Any
                    cell.model = model
                }
            }
        }
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        let section: [[String: Any]] = [
            [
                "title": "头像",
                "titleKey": "icon",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": PhotoCell.self,
                "obj": mtModel?.icon ?? UIImage.defaultHead as Any
            ],
            [
                "title": "昵称",
                "titleKey": "name",
                "type": XYInfoCellType.input.rawValue,
                "value": mtModel?.name ?? ""
            ],
            [
                "title": "真实姓名",
                "titleKey": "realName",
                "type": XYInfoCellType.input.rawValue,
                "value": mtModel?.realName ?? ""
            ],
            [
                "title": "微信号",
                "titleKey": "wechatId",
                "type": XYInfoCellType.input.rawValue,
                "value": mtModel?.wechatId ?? ""
            ],
            [
                "title": "转账说明",
                "titleKey": "desc",
                "type": XYInfoCellType.input.rawValue,
                "value": mtModel?.transferDesc ?? ""
            ],
            [
                "title": "转账限额文字",
                "titleKey": "transferLimitTip",
                "type": XYInfoCellType.textView.rawValue,
                "cellHeight": 100,
                "value": mtModel?.transferLimitTip ?? ""
            ]
        ]
        
        result.append(section)
        return result
    }
    
    override func doneClick() {
        super.doneClick()
        let params = totalParams
        let allItems = totalModels
        
        mtModel?.name = params["name"] as? String
        mtModel?.realName = params["realName"] as? String
        mtModel?.wechatId = params["wechatId"] as? String
        mtModel?.transferDesc = params["desc"] as? String
        mtModel?.transferLimitTip = params["transferLimitTip"] as? String
        
        for model in allItems {
            if model.titleKey == "icon" {
                mtModel?.iconData = (model.obj as? UIImage)?.pngData()
            }
        }

        if let mtModel = mtModel {
            callback?(mtModel)
        }
    }
}
