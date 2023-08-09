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

class SendFileController: BaseSendMsgController {
    
    var callback: ((MsgModelFile)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            if cell.model.titleKey == "type" {
                XYPickerView.showPicker { picker in
                    var dataArr: [XYPickerViewItem] = []
                    MsgModelFile.iconDict.forEach { kv in
                        let item = XYPickerViewItem()
                        item.title = kv.keys.first ?? "undifine"
                        item.code = kv.keys.first ?? "undifine"
                        dataArr.append(item)
                    }
                    picker.dataArray = dataArr
//                    picker.defaultSelectedRow = dataArr.firstIndex(where: { item in
//                        item.title == cell.model.value
//                    }) as? UInt ?? 0
                } result: { result in
                    let model = cell.model
                    model.value = result.title
                    model.valueCode = result.code
                    cell.model = model
                }
            }
            
            if cell.model.titleKey == "sizeType" {
                XYPickerView.showPicker { picker in
                    var dataArr: [XYPickerViewItem] = []
                    MsgModelFile.sizeTypeDict.forEach { kv in
                        let item = XYPickerViewItem()
                        item.title = kv.keys.first ?? "undifine"
                        item.code = kv.keys.first ?? "undifine"
                        dataArr.append(item)
                    }
                    picker.dataArray = dataArr
                    //                    picker.defaultSelectedRow = dataArr.firstIndex(where: { item in
                    //                        item.title == cell.model.value
                    //                    }) as? UInt ?? 0
                } result: { result in
                    let model = cell.model
                    model.value = result.title
                    model.valueCode = result.code
                    cell.model = model
                }
            }
        }
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        let section: [[String: Any]] = [
            [
                "title": "文件类型",
                "titleKey": "type",
                "type": XYInfoCellType.choose.rawValue,
            ],
            [
                "title": "文件名称",
                "titleKey": "title",
                "type": XYInfoCellType.input.rawValue,
            ],
            [
                "title": "文件大小",
                "titleKey": "size",
                "type": XYInfoCellType.input.rawValue,
            ],
            [
                "title": "文件大小单位",
                "titleKey": "sizeType",
                "type": XYInfoCellType.choose.rawValue
            ],
            [
                "title": "微信电脑版本",
                "titleKey": "pcVersion",
                "type": XYInfoCellType.switch.rawValue
            ]
        ]
        
        result.append(section)
        return result
    }

    override func doneClick() {
        super.doneClick()
        let params = totalParams
        
        let link = MsgModelFile()
        link.type = params["type"] as? String
        link.title = params["title"] as? String
        link.size = params["size"] as? String
        link.sizeType = params["sizeType"] as? String
        let pcVersion = params["pcVersion"] as? String
        link.pcVersion = (pcVersion == "1")
        
        if isEdit {
            
        }
        
        callback?(link)
        // Toast.make(params.description)
    }
   
}
