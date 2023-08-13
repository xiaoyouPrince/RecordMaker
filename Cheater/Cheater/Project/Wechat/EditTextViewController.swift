//
//  EditTextViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/13.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 编辑文本消息控制器
 *
 */

import Foundation
import XYUIKit
import XYInfomationSection

class EditTextViewController: BaseSendMsgController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "编辑文本消息"
        setHeaderView(UIView(), edgeInsets: .zero)
        
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            
        }
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        let section: [[String: Any]] = [
            [
                "title": "文本内容",
                "titleKey": "text",
                "type": XYInfoCellType.textView.rawValue,
                "cellHeight": 100,
                "value": msgModel?.text as? Any ?? ""
            ]
        ]
        
        result.append(section)
        return result
    }
    
    override func doneClick() {
        let params = totalParams
        let text = params["text"] as? String ?? ""
        msgModel?.updateText(text)
        super.doneClick()
    }
}
