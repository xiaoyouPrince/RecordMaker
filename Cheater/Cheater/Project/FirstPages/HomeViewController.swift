//
//  HomeViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/11.
//

import UIKit
import XYInfomationSection
import XYUIKit

public extension UIViewController {
    
    enum NavType {
    case Wechat, Alipay
    }
    
    func setNavbarWechat() {
        setNavbar(type: .Wechat)
    }
    
    func setNavbarAlipay() {
        setNavbar(type: .Alipay)
    }
    
    private func setNavbar(type: NavType) {
        var color: XYColor? = XYColor.xy_getColor(hex: 0)
        switch type {
        case .Wechat:
            color = WXConfig.navBarBgColor
        default:
            color = .blue
        }
        navigationController?.navigationBar.barTintColor = color
    }
}

class HomeViewController: XYInfomationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = XYColor.xy_getColor(red: 246, green: 246, blue: 246)
        setNavbarWechat()
        navigationController?.navigationBar.isTranslucent = false
        
        setContentWithData(getContentData(), itemConfig: { item in
            item.type = .other
            item.customCellClass = HomeCell.self
        }, sectionConfig: { section in
            
        }, sectionDistance: 10, contentEdgeInsets: .zero) { index, cell in
            Toast.make("cell.title - \(cell.model.title)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func getContentData() -> [Any] {
        var result = [[[String: Any]]]()
        
        var wechat = [[String: Any]]()
        let wechatItem = [
            "title": "微信工具",
            "titleKey": "wechat_tool",
            "obj": getWechatItems()
        ] as [String : Any]
        wechat.append(wechatItem)
        result.append(wechat)
        
        var alipay = [[String: Any]]()
        let alipayItem = [
            "title": "支付宝工具",
            "titleKey": "alipay_tool",
            "obj": getWechatItems()
        ] as [String : Any]
        alipay.append(alipayItem)
        result.append(alipay)
        
        return result
    }
    
    func getWechatItems() -> [ItemInfo] {
        var result = [ItemInfo]()
        
        let home = ItemInfo(title: "微信首页", icon: "scan_samll_wechat", badge: "")
        let home2 = ItemInfo(title: "微信(单聊)", icon: "scan_samll_wechat", badge: "")
        let home3 = ItemInfo(title: "微信(群聊)", icon: "scan_samll_wechat", badge: "")
        let home4 = ItemInfo(title: "微信转账", icon: "scan_samll_wechat", badge: "")
        let home5 = ItemInfo(title: "微信钱包", icon: "scan_samll_wechat", badge: "旧版")
        let home6 = ItemInfo(title: "微信钱包", icon: "scan_samll_wechat", badge: "新版")
        let home7 = ItemInfo(title: "新的朋友", icon: "scan_samll_wechat", badge: "")
        let home8 = ItemInfo(title: "微信红包", icon: "scan_samll_wechat", badge: "")
        let home9 = ItemInfo(title: "零钱", icon: "scan_samll_wechat", badge: "")
        let home10 = ItemInfo(title: "零钱明细", icon: "scan_samll_wechat", badge: "旧版")
        let home11 = ItemInfo(title: "零钱明细", icon: "scan_samll_wechat", badge: "新版")
        let home12 = ItemInfo(title: "零钱提现", icon: "scan_samll_wechat", badge: "")
        let home13 = ItemInfo(title: "朋友圈", icon: "scan_samll_wechat", badge: "")
        let home14 = ItemInfo(title: "账单", icon: "scan_samll_wechat", badge: "旧版")
        let home15 = ItemInfo(title: "账单", icon: "scan_samll_wechat", badge: "新版")
        let home16 = ItemInfo(title: "微信支付", icon: "scan_samll_wechat", badge: "")
        let home17 = ItemInfo(title: "微粒贷", icon: "scan_samll_wechat", badge: "")
        let home18 = ItemInfo(title: "收款助手", icon: "scan_samll_wechat", badge: "")
        let home19 = ItemInfo(title: "月统计", icon: "scan_samll_wechat", badge: "")
        let home20 = ItemInfo(title: "年账单", icon: "scan_samll_wechat", badge: "火热")
        let home21 = ItemInfo(title: "群发助手", icon: "scan_samll_wechat", badge: "")
        let home22 = ItemInfo(title: "微信个人信息", icon: "scan_samll_wechat", badge: "")
        let home23 = ItemInfo(title: "转账助手", icon: "scan_samll_wechat", badge: "")
        let home24 = ItemInfo(title: "我的朋友圈", icon: "scan_samll_wechat", badge: "")
        
        result.append(home)
        result.append(home2)
        result.append(home3)
        result.append(home4)
        result.append(home5)
        result.append(home6)
        result.append(home7)
        result.append(home8)
        result.append(home9)
        result.append(home10)
        result.append(home11)
        result.append(home12)
        result.append(home13)
        result.append(home14)
        result.append(home15)
        result.append(home16)
        result.append(home17)
        result.append(home18)
        result.append(home19)
        result.append(home20)
        result.append(home21)
        result.append(home22)
        result.append(home23)
        result.append(home24)
        
        return result
    }
}

class ItemInfo: NSObject {
    var title: String
    var icon: String
    var badge: String
    
    init(title: String, icon: String, badge: String) {
        self.title = title
        self.icon = icon
        self.badge = badge
    }
}

class ItemView: UIControl {
    
    var iconImage = UIImageView()
    var titleLabel = UILabel()
    var badge = UILabel()
    var item: ItemInfo
    
    init(item: ItemInfo) {
        self.item = item
        super.init(frame: .zero)
        
        backgroundColor = .white
        iconImage.contentMode = .center
        titleLabel.textAlignment = .center
        
        addSubview(iconImage)
        addSubview(titleLabel)
        addSubview(badge)
        
        iconImage.image = UIImage(named: item.icon)
        iconImage.backgroundColor = .clear
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset( -15)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        titleLabel.text = item.title
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(iconImage.snp.bottom).offset(10)
            //.height.equalTo(15)
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
        badge.isHidden = item.badge.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HomeCell: XYInfomationCell {
    
    let titleLabel = UILabel()
    var chooseThemeView: XYInfomationCell?
    var itemsView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(itemsView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func chooseThemeAction(_ tap: UITapGestureRecognizer) {
        
        let cell = tap.view as? XYInfomationCell
        let title = cell?.model.title
        
        XYPickerView.showPicker { picker in
            picker.title = title ?? ""
            let light = XYPickerViewItem()
            light.title = "浅色模式"
            let dark = XYPickerViewItem()
            dark.title = "深色模式"
            picker.dataArray = [light, dark]
            picker.defaultSelectedRow = cell?.model.value == light.title ? 0 : 1
        } result: { item in
            cell?.model.value = item.title
            if let model = cell?.model {
                cell?.model = model
            }
        }
    }
    
    override var model: XYInfomationItem {
        didSet {
            
            titleLabel.text = model.title
            
            if (model.titleKey == "wechat_tool") {
                let model = XYInfomationItem.model(withTitle: "设置显示模式", titleKey: "set_theme", type: .choose, value: "light", placeholderValue: "light", disableUserAction: false)
                chooseThemeView = XYInfomationCell(model: model)
                if let chooseView = chooseThemeView {
                    addSubview(chooseView)
                }
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.chooseThemeAction(_:)))
                chooseThemeView?.addGestureRecognizer(tap)
            }
            
            // 九宫格展示子类 items
            let margin = 10
            if let items = model.obj as? [ItemInfo],
               items.isEmpty == false {
                
                let colum = 4
                let width = (Int(UIScreen.main.bounds.width - CGFloat(margin*2)) - (colum - 1) * margin) / colum
                let height = 100
                
                var index = -1
                for item in items {
                    index += 1
                    let itemView = ItemView(item: item)
                    itemsView.addSubview(itemView)
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
                            }else if itemView.item.title == "微信转账" {
                                let mtVC = SendMoneyTransfertViewController()
                                mtVC.isFromHome = true
                                detail = mtVC
                            }else if itemView.item.title == "微信红包" {
                                let mtVC = SendRedpacketViewController()
                                detail = mtVC
                            }else if itemView.item.title == "零钱" {
                                let mtVC = WXChargesController()
                                detail = mtVC
                            }else if itemView.item.title == "零钱提现" {
                                let mtVC = WXChargesWithdrawController()
                                detail = mtVC
                            }else if itemView.item.title == "朋友圈" {
                                detail = PYQViewController()
                            }else{
                                detail = MineViewController()
                            }
                            detail.title = itemView.item.title
                            itemView.viewController?.push(detail, animated: true)
                        }
                    }
                }
            }
            
            // layout
            titleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(10)
                make.height.equalTo(20)
            }
            
            if let chooseView = chooseThemeView {
                chooseView.snp.makeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(50)
                }
                
                itemsView.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-margin)
                    make.left.equalToSuperview().offset(margin)
                    make.top.equalTo(chooseView.snp.bottom).offset(10)
                    make.bottom.equalToSuperview().offset(-20)
                }
                
            } else {
                itemsView.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-margin)
                    make.left.equalToSuperview().offset(margin)
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.bottom.equalToSuperview().offset(-20)
                }
            }
        }
    }
}
