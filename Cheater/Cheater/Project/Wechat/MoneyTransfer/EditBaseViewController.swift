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
    var value: String = ""
    var image: UIImage? = nil
    var type: XYInfoCellType = .input
    
    /// 快速创建一个基本类型的编辑项目
    /// - Parameters:
    ///   - title: 标题
    ///   - key: 标题Key
    ///   - value: 值
    ///   - type: 具体类型 input / choose / switch / textField / tip
    init(title: String, key: String, value: String?, type: XYInfoCellType = .input) {
        self.title = title
        self.key = key
        self.value = value ?? ""
        self.type = type
    }
    
    /// 快速创建一个图片类型的编辑项目
    /// - Parameters:
    ///   - title: 标题
    ///   - key: 标题Key
    ///   - image: 编辑的头像
    init(title: String, key: String, image: UIImage){
        self.title = title
        self.key = key
        self.image = image
        self.type = .other
    }
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
            if cell.model.customCellClass == PhotoCell.self {
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
                "type": item.type.rawValue as Any,
                "value": item.value
            ]
            
            if item.type == .switch {
                result["on"] = item.value.boolValue
            }
            
            if item.type == .other {
                result["customCellClass"] = PhotoCell.self
                result["obj"] = item.image ?? UIImage.defaultHead as Any
            }
            
            return result
        }
        result.append(section)
        return result
    }
   
    @objc
    func doneClick() {
        var params = totalParams
        let allItems = totalModels
        for item in allItems {
            if item.type == .other, item.customCellClass == PhotoCell.self {
                let key = item.titleKey
                params[key] = item.obj as? UIImage
            }
        }
        
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

protocol EditBaseViewControllerProtocal {
    /// 进入编辑页面
    /// - Parameters:
    ///   - items: 编辑条目
    ///   - callback: 参数返回值
    func pushEditVC(_ items: [EditItem], callback: (([AnyHashable: Any])->())?)
}

extension EditBaseViewControllerProtocal {
    /// 进入编辑页面
    func pushEditVC(_ items: [EditItem], callback: (([AnyHashable: Any])->())?) {
        let editVC = EditBaseViewController()
        editVC.setItems(items, callback: callback)
        UIViewController.currentVisibleVC.nav_push(editVC, animated: true)
    }
}


extension UIViewController: EditBaseViewControllerProtocal { }
