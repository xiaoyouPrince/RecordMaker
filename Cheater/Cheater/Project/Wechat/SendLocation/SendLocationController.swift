//
//  SendLocationController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/10.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 发送定位VC
 

 */
import UIKit
import XYUIKit
import XYInfomationSection

class SendLocationController: BaseSendMsgController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContentWithData(contentData(), itemConfig: { item in
            
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            
        }
    }
    
    var locationModel: MsgModelLocation? {
        msgModel?.data?.toModel()
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        let section: [[String: Any]] = [
            [
                "title": "地点名称",
                "titleKey": "url",
                "type": XYInfoCellType.input.rawValue,
                "value": locationModel?.poiname ?? ""
            ],
            [
                "title": "详细地址",
                "titleKey": "title",
                "type": XYInfoCellType.input.rawValue,
                "value": locationModel?.poiaddress ?? ""
            ]
        ]
        
        result.append(section)
        return result
    }
    
    override func doneClick() {
        guard let link = locationModel else {
            super.doneClick()
            return
        }
        
        let params = totalParams
        link.poiname = params["url"] as? String
        link.poiaddress = params["title"] as? String
        if isEdit {
            msgModel?.updateContent(link)
        }
        
        super.doneClick()
    }
}
