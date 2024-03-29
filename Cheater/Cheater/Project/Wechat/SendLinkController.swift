//
//  SendLinkController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit
import XYInfomationSection

class SendLinkController: BaseSendMsgController {
    
    var callback: ((MsgModelLink)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            if cell.model.title == "连接图标" || cell.model.title == "应用图标" {
                ChoosePhotoController.choosePhoto { image in
                    let model = cell.model
                    model.obj = image as Any
                    cell.model = model
                }
            }
        }
    }
    
    var linkModel: MsgModelLink? {
        msgModel?.data?.toModel()
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        let section: [[String: Any]] = [
            [
                "title": "连接地址",
                "titleKey": "url",
                "type": XYInfoCellType.input.rawValue,
                "value": linkModel?.url ?? ""
            ],
            [
                "title": "连接标题",
                "titleKey": "title",
                "type": XYInfoCellType.input.rawValue,
                "value": linkModel?.title ?? ""
            ],
            [
                "title": "连接描述",
                "titleKey": "desc",
                "type": XYInfoCellType.input.rawValue,
                "value": linkModel?.desc ?? ""
            ],
            [
                "title": "连接图标",
                "titleKey": "linkIcon",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": PhotoCell.self,
                "obj": linkModel?.linkIconImage ?? UIImage.defaultHead as Any
            ],
            [
                "title": "应用图标",
                "titleKey": "appIcon",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": PhotoCell.self,
                "obj": linkModel?.appIconImage ?? UIImage.defaultHead as Any
            ],
            [
                "title": "应用名字",
                "titleKey": "appName",
                "type": XYInfoCellType.input.rawValue,
                "value": linkModel?.appName ?? ""
            ]
        ]
        
        result.append(section)
        return result
    }

    override func doneClick() {
        super.doneClick()
        let params = totalParams
        let allItems = totalModels
        
        let link = MsgModelLink()
        link.url = params["url"] as? String
        link.title = params["title"] as? String
        link.desc = params["desc"] as? String
        link.appName = params["appName"] as? String
        
        for model in allItems {
            if model.titleKey == "linkIcon" {
                link.linkIcon = (model.obj as? UIImage)?.pngData()
            }
            
            if model.titleKey == "appIcon" {
                link.appIcon = (model.obj as? UIImage)?.pngData()
            }
        }
        
        if isEdit {
            msgModel?.updateContent(link)
        }
        
        callback?(link)
        // Toast.make(params.description)
    }
   
}
