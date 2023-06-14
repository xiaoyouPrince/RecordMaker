//
//  WXPersonInfoViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/14.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import XYInfomationSection
import XYUIKit

class WXPersonInfoViewController: XYInfomationBaseViewController {
    
    var popCallback: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = WXConfig.navBarBgColor.withAlphaComponent(1)
        
        title = "个人信息"
        setNavbarWechat()
        nav_setCustom(backImage: UIImage(named: "wechat_fanhui")) {[weak self] in
            self?.popCallback?()
            return true
        }
        navigationController?.navigationBar.tintColor = .black

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
                    "obj": WXUserInfo.shared.icon as Any
                ],
                [
                    "title": "名字",
                    "type": XYInfoCellType.choose.rawValue,
                    "value": WXUserInfo.shared.name as Any
                ],
                [
                    "title": "拍一拍",
                    "type": XYInfoCellType.choose.rawValue,
                    "value": ""
                ],
                [
                    "title": "微信号",
                    "type": XYInfoCellType.choose.rawValue,
                    "value": WXUserInfo.shared.wechatId as Any
                ],
                [
                    "title": "我的二维码",
                    "type": XYInfoCellType.other.rawValue,
                    "customCellClass": PhotoCell.self,
                    "value": "",
                    "obj": UIImage(named: "wechat_mineewm") as Any
                ],
                [
                    "title": "更多",
                    "type": XYInfoCellType.choose.rawValue,
                    "value": ""
                ]
            ],
            [ // section 2
                [
                    "title": "微信豆",
                    "type": XYInfoCellType.choose.rawValue,
                    "value": ""
                ]
            ],
            [ // section 3
                [
                    "title": "我的地址",
                    "type": XYInfoCellType.choose.rawValue,
                    "value": ""
                ]
            ]
        ]
    }
}

class PhotoCell: XYInfomationCell {
    var titleLabel = UILabel()
    var photoView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(photoView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        photoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(8)
            make.width.height.lessThanOrEqualTo(60)
            make.right.equalToSuperview().offset(-40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model: XYInfomationItem {
        didSet {
            titleLabel.text = model.title
            photoView.image = model.obj as? UIImage
            
            if model.title == "头像" {
                photoView.corner(radius: 5)
            }
        }
    }
}
