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
    /// 点击了哪个Item
    /// - Parameter item: 对应信息
    func didSeletedItem(item: TabbarItemInfo)
}

enum WechatTabarItemName: String {
    case wechat = "微信"
    case contact = "通讯录"
    case discover = "发现"
    case me = "我"
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

private
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
        
        badge.font = UIFont.boldSystemFont(ofSize: 13)
        badge.textColor = .white
        badge.backgroundColor = .red
        badge.text = item.badge
        badge.sizeToFit()
        badge.textAlignment = .center
        badge.corner(radius: (badge.bounds.size.height + 5) / 2)
        badge.isHidden = badge.text?.isEmpty ?? false
        
        let width = max(badge.bounds.width + 10, badge.bounds.height + 5)
        badge.snp.makeConstraints { make in
            make.right.equalTo(iconImage).offset(15)
            make.top.equalTo(iconImage.snp.top).offset(-8)
            make.width.equalTo(width)
            make.height.equalTo(badge.bounds.size.height + 5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.iconImage.image = UIImage(named: item.icon_sel)
                self.titleLabel.textColor = WXConfig.tabBarItemSelelectedColor
            } else {
                self.iconImage.image = UIImage(named: item.icon_normal)
                self.titleLabel.textColor = WXConfig.tabBarItemNormalColor
            }
        }
    }
}

class WechatTabbar: UIView {
    
    var delegate: WechatTabbarProtocol? {
        didSet {
            delegate?.didSeletedItem(item: home)
        }
    }
    
    private var contentView: UIView = UIView()
    private let home = TabbarItemInfo(title: "微信", icon_normal: "tabbar_mainframe1_24x22_", icon_sel: "tabbar_mainframeHL1_24x22_", badge: "")
    private let contact = TabbarItemInfo(title: "通讯录", icon_normal: "tabbar_contacts_new_26x21_", icon_sel: "tabbar_contactsHL_new_26x21_", badge: "1")
    private let find = TabbarItemInfo(title: "发现", icon_normal: "tabbar_discover_24x24_", icon_sel: "tabbar_discoverHL_24x24_", badge: "")
    private let me = TabbarItemInfo(title: "我" , icon_normal: "tabbar_me_new_24x21_", icon_sel: "tabbar_meHL_new_23x21_", badge: "")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addBlurEffect()
        
        var realFrame: CGRect = .zero
        if self.isIPhoneX() {
            realFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 49 + 34)
        } else {
            realFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 49)
        }
        
        self.frame = realFrame
        self.backgroundColor = WXConfig.tabBarBgColor
        
        let items = [home, contact, find, me]
        addSubview(contentView)
        
        contentView.frame = .init(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: 49))
        
        let margin = 0
        let colum = 4
        let width = (Int(UIScreen.main.bounds.width - CGFloat(margin*2)) - (colum - 1) * margin) / colum
        let height = 49
        
        var index = -1
        for item in items {
            index += 1
            let itemView = TabbarItemView(item: item)
            contentView.addSubview(itemView)
            if index == 0 {
                itemView.isSelected = true
            }
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
            itemView.addBlock(for: UIControl.Event.touchUpInside) {[weak self] sender in
                if let itemView = sender as? TabbarItemView {
                    
                    // selecte / unselecte
                    itemView.isSelected = true
                    if let superView = itemView.superview {
                        for subView in superView.subviews {
                            if itemView == subView {
                                continue
                            } else {
                                if let itemV = subView as? TabbarItemView {
                                    itemV.isSelected = false
                                }
                            }
                        }
                    }
                    
                    // delegate
                    if let delegate = self?.delegate {
                        delegate.didSeletedItem(item: itemView.item)
                    }
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
    
    /// 当前选中的是否是微信首页
    var isSelectedHome: Bool {
        isSelectedItem(with: .wechat)
    }
    
    /// 当前选中的是否是微信通讯录
    var isSelectedContact: Bool {
        isSelectedItem(with: .contact)
    }
    
    private func isSelectedItem(with name: WechatTabarItemName) -> Bool {
        for subview in contentView.subviews {
            if let itemView = subview as? TabbarItemView {
                if itemView.isSelected && itemView.item.title == name.rawValue {
                    return true
                }
            }
        }
        return false
    }
}
