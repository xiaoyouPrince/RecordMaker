//
//  SendVoipCpntroller.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/17.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit
import XYInfomationSection

class SendVoipCpntroller: BaseSendMsgController {
    var callback: ((MsgVoipModel)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            
            if cell.model.title == "视频封面" {
                ChoosePhotoController.choosePhoto { image in
                    cell.model.obj = image.pngData() as Any
                    let model = cell.model
                    cell.model = model
                }
            }
            if cell.model.title == "通话类型" {
                XYPickerView.showPicker { picker in
                    picker.title = cell.model.title
                    picker.dataArray = [
                        .model(withDict: ["title":"视频通话","code":"0"]),
                        .model(withDict: ["title":"语音通话","code":"1"])
                    ]
                } result: { chooseItem in
                    cell.model.value = chooseItem.title
                    cell.model.valueCode = chooseItem.code
                    cell.model = cell.model
                }
            }
        }
    }
}


extension SendVoipCpntroller {
    
    func voipModel() -> MsgVoipModel? {
        if isEdit {
            return msgModel!.data!.toModel()
        }
        return nil
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        var typeString = "视频通话"
        if (voipModel()?.voipType == 1) {
            typeString = "语音通话"
        }
        
        let section: [[String: Any]] = [
            [
                "title": "通话时长",
                "titleKey": "videoTime",
                "type": XYInfoCellType.input.rawValue,
                "value": voipModel()?.voipTime as Any,
                "placeholderValue": "时间用英文“:”分隔"
            ],
            [
                "title": "是否取消",
                "titleKey": "isCancel",
                "type": XYInfoCellType.switch.rawValue,
                "isOn": voipModel()?.isCancel as Any,
            ],
            [
                "title": "通话类型",
                "titleKey": "voipType",
                "type": XYInfoCellType.choose.rawValue,
                "value": typeString,
                "valueCode": typeString == "视频通话" ? "0" : "1"
            ]
        ]
        
        result.append(section)
        return result
    }
    
    @objc override func doneClick() {
        let params = totalParams
        let voipModel = MsgVoipModel()
        voipModel.voipTime = params["videoTime"] as? String
        voipModel.isCancel = (params["isCancel"] as? String) == "1" ? true : false
        voipModel.voipType = (params["voipType"] as? String)?.intValue
        
        callback?(voipModel)
        if isEdit {
            msgModel?.updateContent(voipModel)
        }
        
        super.doneClick()
    }
}
