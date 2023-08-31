//
//  WithdrawEditViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/30.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit
import XYInfomationSection

class WithdrawEditViewController: XYInfomationBaseViewController {
    
    /// 回调,告知外界最终所选内容
    var callback: ((_ allParams: [AnyHashable : Any])->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        loadData()
    }

}

extension WithdrawEditViewController {
    
    func buildUI() {
        setupNav()
        setupContent()
    }
    
    func setupNav() {
         title = "编辑"
         nav_setCustom(backImage: WXConfig.wx_backImag)
        
         navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(navRightBtnClick), title: "确定")
    }
    
    @objc func goBack(){
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func navRightBtnClick(){
        // right item click
        var params = totalParams
        let allItems = totalModels
        for item in allItems {
            if item.type == .other, item.customCellClass == PhotoCell.self {
                let key = item.titleKey
                params[key] = item.obj as? UIImage
            }
        }
        
        callback?(params)
        goBack()
    }
    
    func doneClick(){
        navRightBtnClick()
    }
    
    func setupContent() {
        view.backgroundColor = .white
        
        // header
        setHeaderView(.line, edgeInsets: .zero)
        
        // content
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
        
        // footer
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
        
        let section: [[String: Any]] = [
            [
                "title": "银行",
                "titleKey": "bank",
                "type": XYInfoCellType.choose.rawValue,
                "value": "value"
            ],
            [
                "title": "银行卡尾号",
                "titleKey": "bankCardNumber",
                "type": XYInfoCellType.input.rawValue,
                "value": "value"
            ],
            [
                "title": "",
                "titleKey": "3",
                "type": XYInfoCellType.switch.rawValue,
                "on": "true".boolValue
            ],
            [
                "title": "",
                "titleKey": "4",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": PhotoCell.self,
                "obj": UIImage.defaultHead ?? UIImage.init() as Any
            ],
        ]
        
        result.append(section)
        return result
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

extension WithdrawEditViewController {
    
    func loadData() {
        // refreshUI
    }
    
}
