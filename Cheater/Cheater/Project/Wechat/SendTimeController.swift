//
//  SendTimeController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/8.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 自定义一个发送时间控制器
 *
 * 选择时间发送
 * 自定义发送一个系统消息
 */

import UIKit
import XYUIKit
import XYInfomationSection

class SendTimeController: BaseSendMsgController {
    
    var callback: ((TimeInterval)->())?
    private var chooseTimeInterval: TimeInterval = .since1970

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
            
            if cell.model.titleKey == "chooseTime" {
                DatePickerController.chooseDate { timeInterval in
                    if timeInterval == -1 { return }
                    
                    let model = cell.model
                    model.value = TimeTool.timeString(from: timeInterval)
                    model.valueCode = model.value
                    cell.model = model
                    self.chooseTimeInterval = timeInterval
                }
            }
        }
    }

}

extension SendTimeController {
    
    func contentData() -> [Any] {
        let cuttentTimeStr = TimeTool.timeString(from: .since1970)
        
        var result = [Any]()
        let section: [[String: Any]] = [
            [
                "title": "选择时间",
                "titleKey": "chooseTime",
                "type": XYInfoCellType.choose.rawValue,
                "value": cuttentTimeStr,
                "valueCode": cuttentTimeStr
            ]
        ]
        
        result.append(section)
        return result
    }
    
    @objc override func doneClick(){
        let params = totalParams
        let timeString = params["chooseTime"] as? String ?? ""
        if timeString.isEmpty {
            Toast.make("需要先选时间")
            return
        }
        
        callback?(self.chooseTimeInterval)
        if isEdit {
            let timeModel = MsgTimeModel()
            timeModel.time = chooseTimeInterval
            msgModel?.updateContent(timeModel)
        }
        
        super.doneClick()
    }
}

