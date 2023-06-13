//
//  WechatTabbar.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/13.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/**
 一个自定义的微信 tabbar
 */

import XYUIKit

protocol WechatTabbarProtocol {
    /// 点击了第几个Item
    /// - Parameter atIndex: 位置信息
    func didSeletedItem(atIndex: Int)
}

class TabbarItemInfo: NSObject {
    var title: String
    var icon_normal: String
    var icon_sel: String
    var badge: String
    
    init(title: String, icon_normal: String, icon_sel: String, badge: String) {
        self.title = title
        self.icon_normal = icon_normal
        self.icon_sel = icon_sel
        self.badge = badge
    }
}

class TabbarItemView: UIControl {
    
    var iconImage = UIImageView()
    var titleLabel = UILabel()
    var badge = UILabel()
    var item: TabbarItemInfo
    
    init(item: TabbarItemInfo) {
        self.item = item
        super.init(frame: .zero)
        
        iconImage.contentMode = .center
        titleLabel.textAlignment = .center
        
        addSubview(iconImage)
        addSubview(titleLabel)
        addSubview(badge)
        
        iconImage.image = UIImage(named: item.icon_normal)
        iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 22))
        }
        
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(iconImage.snp.bottom).offset(6)
            make.height.equalTo(10)
        }
        
        badge.font = UIFont.systemFont(ofSize: 10)
        badge.textColor = .white
        badge.backgroundColor = .red
        badge.text = item.badge
        badge.sizeToFit()
        badge.textAlignment = .center
        badge.corner(radius: 7)
        badge.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(-10)
            make.top.equalTo(iconImage.snp.top).offset(-10)
            make.width.equalTo(badge.bounds.size.width + 10)
            make.height.equalTo(badge.bounds.size.height + 5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WechatTabbar: UIView {
    
    private var contentView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        var realFrame: CGRect = .zero
        if self.isIPhoneX() {
            realFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 49 + 34)
        } else {
            realFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 49)
        }
        
        self.frame = realFrame
        self.backgroundColor = WXConfig().tabBarBgColor
        
        let home = TabbarItemInfo(title: "微信", icon_normal: "tabbar_mainframe1_24x22_", icon_sel: "tabbar_mainframeHL1_24x22_", badge: "旧版")
        let contact = TabbarItemInfo(title: "通讯录", icon_normal: "tabbar_contacts_new_26x21_", icon_sel: "tabbar_contactsHL_new_26x21_", badge: "新版")
        let find = TabbarItemInfo(title: "发现", icon_normal: "tabbar_discover_24x24_", icon_sel: "tabbar_discoverHL_24x24_", badge: "火热")
        let me = TabbarItemInfo(title: "我" , icon_normal: "tabbar_me_new_24x21_", icon_sel: "tabbar_meHL_new_23x21_", badge: "教程")
        let items = [home, contact, find, me]
        
        addSubview(contentView)
        
        contentView.frame = .init(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: 49))
        //contentView.backgroundColor = .yellow
        
        let margin = 0
        let colum = 4
        let width = (Int(UIScreen.main.bounds.width - CGFloat(margin*2)) - (colum - 1) * margin) / colum
        let height = 49
        
        var index = -1
        for item in items {
            index += 1
            let itemView = TabbarItemView(item: item)
            contentView.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                
                make.left.equalToSuperview().offset((width + margin) * (index % colum))
                make.top.equalToSuperview().offset((height + margin) * (index / colum))
                make.width.equalTo(width)
                make.height.equalTo(height)
                
                if index == items.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            
            // action
            itemView.addBlock(for: UIControl.Event.touchUpInside) { sender in
                if let itemView = sender as? ItemView {
                    
                    var detail: UIViewController!
                    if itemView.item.title == "微信首页" {
                        detail = WechatHomeViewController()
                    }else{
                        detail = MineViewController()
                    }
                    detail.title = itemView.item.title
                    itemView.viewController?.push(detail, animated: true)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
}

extension WechatTabbar {
    func navHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? UIApplication.shared.statusBarFrame.height
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    func tabbarSafeHeight() -> CGFloat {
        isIPhoneX() ? 34 : 0
    }
    
    func isIPhoneX() -> Bool {
        navHeight() != 20
    }
}
