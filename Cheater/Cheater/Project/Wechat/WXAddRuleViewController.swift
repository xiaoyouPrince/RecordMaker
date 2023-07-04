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
    
    let addHeadImage = UIImage(named: "add_head")
    private var saveCallback: (()->())?
    private var randomContact: WXContact?
    
    init(saveCallback: (()->())? = nil) {
        self.saveCallback = saveCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav(with: "添加角色")
        refreshContent()
        refreshBottom()
    }
}

extension WXAddRuleViewController {
    
    func setupNav(with navtitle: String) {
        title = navtitle
        view.backgroundColor = WXConfig.tableViewBgColor
        setNavbarWechat()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveAction))
        nav_setCustom(backImage: UIImage(named: "wechat_fanhui")?.withRenderingMode(.alwaysOriginal)) { true }
    }
    
    func refreshContent() {
        
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
    
    func refreshBottom() {
        
        let addRandomBtn = UIButton(type: .custom)
        addRandomBtn.backgroundColor = .C_587CF7
        addRandomBtn.setTitle("随机生成一个", for: .normal)
        addRandomBtn.corner(radius: 5)
        addRandomBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        addRandomBtn.addTap { [weak self] _ in
            self?.randomContact = WXContact.random
            self?.refreshContent()
        }
        
        setFooterView(addRandomBtn, edgeInsets: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    func contentData() -> [Any] {
        
        var image: UIImage?
        var title: String?
        if let randomContact = randomContact {
            image = randomContact.image
            title = randomContact.title
        }
        
        return [ // total
            [ // section 1
                [
                    "title": "头像",
                    "type": XYInfoCellType.other.rawValue,
                    "customCellClass": PhotoCell.self,
                    "value": image != nil ? "true" : "false",
                    "obj": image ?? addHeadImage as Any
                ],
                [
                    "title": "名字",
                    "type": XYInfoCellType.input.rawValue,
                    "value": title ?? ""
                ]
            ]
        ]
        
    }
    
    @objc func saveAction(){
        
        var result = [AnyHashable: Any]()
        var image = UIImage()
        for subview in contentView.subviews.first!.subviews {
            if let subView = subview as? XYInfomationSection {
                result = subView.contentKeyValues

                if let first = subView.dataArray.first, let obj = first.obj as? UIImage, obj != addHeadImage {
                    image = obj
                }
            }
        }
        
        if let image = result["头像"] as? String, image == "false" { // not choose icon
            Toast.make("请选择头像")
            return
        }
        if let title = result["名字"] as? String, title.isEmpty == true { // not input title
            Toast.make("请输入名字")
            return
        }
        
        //Toast.makeDebug(result.toString ?? "")
        let contact = WXContact(image: image, title: result["名字"] as! String)
        contact.save()

        //Toast.makeDebug("新建的联系人 - \(contact.title)")
        ContactDataSource.update()
        saveCallback?()
        navigationController?.popViewController(animated: true)
    }
}
