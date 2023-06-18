//
//  WechatHomeViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/13.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import XYUIKit
import XYInfomationSection

class WechatHomeViewController: XYInfomationBaseViewController {
    
    var tabbar: WechatTabbar = WechatTabbar()
    var tableView = UITableView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    func buildUI(){
        setupNavBar()
        addTabbar()
    }
    
    func setupNavBar() {
        view.backgroundColor = WXConfig.listBgColor
        setNavbarWechat()
        nav_hideDefaultBackBtn()
    }
    
    func addTabbar() {
        tabbar.frame.origin = CGPoint(x: 0, y: view.bounds.height - tabbar.bounds.height)
        tabbar.delegate = self
        view.addSubview(tabbar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nav_hideBarBottomLine()
        addScrollDelegate()
        
        // 刷新消息列表最后一句话 - 简单说就是如果当前选中的是[微信]直接刷新一下
        if tabbar.isSelectedHome {
            didSelectedWechat()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nav_hideBarBottomLine(false)
    }
    
    func refreshUI(data: [Any]) {
        setContentWithData(data, itemConfig: { item in
            item.value = ""
            item.cellHeight = 60
            item.accessoryView = UIImageView(image: UIImage(named: "youjiantou"))
        }, sectionConfig: { section in
            section.corner(radius: 0)
        }, sectionDistance: 10, contentEdgeInsets: .zero) { index, cell in
            Toast.make("\(cell.model.title)")
            
            if cell.model.titleKey == "wechat_chat" {
                self.push(MineViewController(), animated: true)
            }
        }
    }
}

extension WechatHomeViewController: UIScrollViewDelegate {
    
    func addScrollDelegate() {
        scrollView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {// 1.5 是恰好的一个值
        nav_hideBarBottomLine((scrollView.contentOffset.y + kNavHeight - 1.5) < 0)
    }
}

extension WechatHomeViewController: WechatTabbarProtocol {
    func didSeletedItem(item: TabbarItemInfo) {
        Toast.make("选择了 -- \(item.title)")
        self.title = item.title
        
        if tabbar.isSelectedContact == false {
            tableView.isHidden = true
        }
        
        if title == "我" {
            didSelectedMine()
        }else
        if title == "发现" {
            didSelectedDiscover()
        }else
        if title == "微信" {
            didSelectedWechat()
        }else
        if title == "通讯录" {
            didSelectedContact()
        }else
        {
            setHeaderView(UIView(), edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
            
            view.backgroundColor = WXConfig.listBgColor
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}

// MARK: - 微信
extension WechatHomeViewController {
    
    func didSelectedWechat() {
        
        let image = UIImage(named: "wechat_mnq_jia")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.wechatAddAction))
        
        setHeaderView(WechatSearchBarView(), edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        view.backgroundColor = WXConfig.tableViewBgColor
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        refreshUI(data: getWechatData())
    }
    
    func getWechatData() -> [Any] {
        let result: [[[String: Any]]] =
        [ // totoal
            [ // section 1
                [ // cell 1
                    "imageName": "discover_IconShowAlbum_22x22_",
                    "title": "朋友圈",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_chat",
                ]
            ]
        ]
        return result
    }
    
    @objc
    func wechatAddAction() {
        Toast.make("首页添加 --- ")
    }
}

// MARK: - 通讯录
extension WechatHomeViewController {
    
    func didSelectedContact() {
        
        let image = UIImage(named: "wechat_mnq_addren")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.contactNavRightItemAction))
        
        view.backgroundColor = WXConfig.tableViewBgColor
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        //setHeaderView(WechatSearchBarView(), edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        //refreshUI(data: getContactData())
        setHeaderView(.init(), edgeInsets: .zero)
        setContentView(.init(), edgeInsets: .zero)
        
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.remakeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(self.tabbar.snp.top)
        }
        tableView.isHidden = false
    }
    
    func getContactData() -> [Any] {
        let result: [[[String: Any]]] =
        [ // totoal
            [ // section 1
                [ // cell 1
                    "imageName": "discover_IconShowAlbum_22x22_",
                    "title": "朋友圈",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_chat",
                ]
            ]
        ]
        return result
    }
    
    @objc
    func contactNavRightItemAction() {
        Toast.make("联系人添加 --- ")
    }
}

extension WechatHomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID") ?? UITableViewCell(style: .default, reuseIdentifier: "cellID")
        
        cell.textLabel?.text = "\(indexPath)"
        cell.backgroundColor = UIColor.random
          
        return cell
    }
    
    
}

// MARK: - 发现
extension WechatHomeViewController {
    
    func didSelectedDiscover() {
        
        navigationItem.rightBarButtonItem = nil
        setHeaderView(UIView(), edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        view.backgroundColor = WXConfig.tableViewBgColor
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        refreshUI(data: getDiscoverData())
    }
    
    func getDiscoverData() -> [Any] {
        let result: [[[String: Any]]] =
        [ // totoal
            [ // section 1
                [ // cell 1
                    "imageName": "discover_IconShowAlbum_22x22_",
                    "title": "朋友圈",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ],
            [ // section 2
                [ // cell 1
                    "imageName": "t_icons_video_22x22_",
                    "title": "视频号",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ],
                [ // cell 1
                    "imageName": "t_icons_nearbyzb",
                    "title": "直播",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ],
            [// section3
                [ // cell 1
                    "imageName": "discover_IconQRCode_22x22_",
                    "title": "扫一扫",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ],
                [ // cell 1
                    "imageName": "discover_IconShake_22x22_",
                    "title": "摇一摇",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ],
            [ // section 4
                [ // cell 1
                    "imageName": "wxSeeNew_22x22_",
                    "title": "看一看",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ],
                [ // cell 1
                    "imageName": "wxSearchNew_22x22_",
                    "title": "搜一搜",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ],
            [ // section 5
                [ // cell 1
                    "imageName": "t_icons_nearby",
                    "title": "附近",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ],
            [ // section 6
                [ // cell 1
                    "imageName": "ff_Iconshop_22x22_",
                    "title": "购物",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ],
                [ // cell 1
                    "imageName": "discover_IconMoreGame_22x22_",
                    "title": "游戏",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ],
            [ // section 7
                [ // cell 1
                    "imageName": "miniapps_22x22_",
                    "title": "小程序",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ]
        ]
        
        return result
    }
    
}

// MARK: - 我
extension WechatHomeViewController {
    
    func didSelectedMine() {
        
        let top = UIView()
        top.backgroundColor = WXConfig.listBgColor
        top.snp.makeConstraints { make in
            make.height.equalTo(500)
        }
        
        let infoView = MineInfoView(frame: .zero)
        top.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        infoView.addStatusCallback = { showFindStatusFunc in
            showFindStatusFunc()
        }
        infoView.findStatusCallback = { hideFindStatusFunc in
            hideFindStatusFunc()
        }
        infoView.addBlock(for: .touchUpInside) {[weak self] sender in
            guard let infoView = sender as? MineInfoView else { return }
            
            let detail = WXPersonInfoViewController()
            detail.popCallback = {
                Toast.make("设置个人信息完成,回调")
                infoView.updateUserInfo()
            }
            self?.push(detail, animated: true)
        }
        
        setHeaderView(top, edgeInsets: .init(top: -300, left: 0, bottom: 10, right: 0))
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        refreshUI(data: getMineData())
        view.backgroundColor = WXConfig.navBarBgColor.withAlphaComponent(1)
    }
    
    func getMineData() -> [Any] {
        let result: [[[String: Any]]] =
        [ // totoal
            [ // section 1
                [ // cell 1
                    "imageName": "MoreMyBankCard_22x22_",
                    "title": "支付",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ],
            [ // section 2
                [ // cell 1
                    "imageName": "MoreMyFavorites_22x22_",
                    "title": "收藏",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ],
                [ // cell 1
                    "imageName": "MoreMyAlbum_22x22_",
                    "title": "朋友圈",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ],
                [ // cell 1
                    "imageName": "MoreCardbag_22x22_",
                    "title": "卡包",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ],
                [ // cell 1
                    "imageName": "MoreExpressionShops_22x22_",
                    "title": "表情",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ],
            [ // section 3
                [ // cell 1
                    "imageName": "MoreSetting_22x22_",
                    "title": "设置",
                    "type": XYInfoCellType.choose.rawValue,
                    "titleKey": "wechat_tool",
                ]
            ],
        ]
        
        return result
    }
}
