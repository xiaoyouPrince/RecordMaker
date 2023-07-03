//
//  WXAddRuleViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/22.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 微信主页 - 通讯录 - 右上角点击,添加角色页面
 */

import XYUIKit
import XYInfomationSection

class WXAddRuleViewController: XYInfomationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "添加角色"
        view.backgroundColor = WXConfig.tableViewBgColor
        setNavbarWechat()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveAction))
        nav_setCustom(backImage: UIImage(named: "wechat_fanhui")?.withRenderingMode(.alwaysOriginal)) { true }
        
        setContentWithData(contentData(), itemConfig: { item in
            item.titleFont = UIFont.systemFont(ofSize: 17)
            item.titleColor = UIColor.black
            item.accessoryView = UIImageView(image: UIImage(named: "youjiantou"))
            item.cellHeight = 60
        }, sectionConfig: {section in
            section.corner(radius: 0)
        }, sectionDistance: 10, contentEdgeInsets: .zero) { index, cell in
            Toast.make("\(cell.model.title)")
        }
    }
    
    func contentData() -> [Any] {
        return [ // total
            [ // section 1
                [
                    "title": "头像",
                    "type": XYInfoCellType.other.rawValue,
                    "customCellClass": PhotoCell.self,
                    "value": "",
                    "obj": UIImage(named: "add_head") as Any
                ],
                [
                    "title": "名字",
                    "type": XYInfoCellType.input.rawValue,
                    //"value": WXUserInfo.shared.name as Any
                ]
            ]
        ]
        
    }
    
    @objc func saveAction(){
        Toast.make("保存")
        
        var result = [AnyHashable: Any]()
        for subview in contentView.subviews.first!.subviews {
            if let subView = subview as? XYInfomationSection {
                result = subView.contentKeyValues
            }
        }
        
        Toast.makeDebug(result.toString ?? "")

        
        let contact = WXContact.random
        contact.save()
        
        Toast.makeDebug("新建的联系人 - \(contact.title)")
        
        ContactDataSource.update()
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
