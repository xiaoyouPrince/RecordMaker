//
//  EditBaseViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/23.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit
import XYInfomationSection

struct EditItem {
    var title: String
    var key: String
    var value: String
    var type: XYInfoCellType = .input
}

class EditBaseViewController: XYInfomationBaseViewController {
    private var items: [EditItem]?
    private var callback: (([AnyHashable: Any])->())?
    func setItems(_ items: [EditItem], callback: (([AnyHashable: Any])->())?) {
        self.items = items
        self.callback = callback
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WXConfig.navBarBgColor
        title = "编辑"
        nav_setCustom(backImage: WXConfig.wx_backImag)
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(doneClick), title: "确定")

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
        
        let button = UIButton(type: .system)
        button.setTitle("保存" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = WXConfig.wxGreen
        button.corner(radius: 5)
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        button.addTap { [weak self] sender in
            guard let self = self else { return }
            self.doneClick()
        }
        setFooterView(button, edgeInsets: .init(top: 20, left: 10, bottom: 0, right: 10))
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        guard let items = items else { return result }
        
        let section: [[String: Any]] = items.map { item -> [String: Any] in
            var result = [
                "title": item.title,
                "titleKey": item.key,
                "type": item.type.rawValue,
                "value": item.value
            ]
            
            if item.type == .switch {
                result["on"] = item.value.boolValue
            }
            
            return result
        }
        result.append(section)
        return result
    }
   
    @objc
    func doneClick() {
        let params = totalParams
        //let allItems = totalModels
        
        callback?(params)
        navigationController?.popViewController(animated: true)
    }
    
    /// 获取当前页面编辑的所有参数
    var totalParams: [AnyHashable: Any] {
        var params: [AnyHashable: Any] = [:]
        self.view.findSubViewRecursion { subview in
            if let section = subview as? XYInfomationSection {
                params = section.contentKeyValues
                return true
            }
            return false
        }
        return params
    }
    
    /// 获取当前页面编辑的所有参数
    var totalModels: [XYInfomationItem] {
        var result: [XYInfomationItem] = []
        self.view.findSubViewRecursion { subview in
            if let section = subview as? XYInfomationSection {
                result.append(contentsOf: section.dataArray)
                return true
            }
            return false
        }
        return result
    }
    
}
