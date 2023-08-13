//
//  EditImageViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/13.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import Foundation

/*
 * - TODO -
 * 编辑图片消息控制器
 *
 */

import Foundation
import XYUIKit
import XYInfomationSection

class EditImageViewController: BaseSendMsgController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "编辑图片消息"
        
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            if cell.model.titleKey == "image" {
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
                "title": "图片",
                "titleKey": "image",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": PhotoCell.self,
                "obj": msgModel?.image ?? UIImage.defaultHead as Any
            ]
        ]
        
        result.append(section)
        return result
    }
    
    override func doneClick() {
        let allItems = totalModels
        var image: UIImage = UIImage()
        for model in allItems {
            if model.titleKey == "image" {
                image = (model.obj as? UIImage ?? UIImage())
            }
        }
        msgModel?.updateImage(image)
        
        super.doneClick()
    }
}

