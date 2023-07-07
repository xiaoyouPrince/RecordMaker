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
    var tableView = UITableView(frame: .zero, style: .plain)
    let indexBar = XYIndexBar(frame: .init(origin: .init(x: .width - 30, y: 0), size: .init(width: 30, height: .height)))
    var hasSetupTableView = false // 用来标记 tableView 是否被设置过,避免重复设置,提升性能

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
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func addTabbar() {
        tabbar.delegate = self
        view.addSubview(tabbar)
        tabbar.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(tabbar.bounds.height)
        }
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
        if let first = data.first as? [[String: Any]], first.isEmpty {return} // 空数据不加载
        
        setContentWithData(data, itemConfig: { item in
            if self.tabbar.isSelectedHome == false {
                item.value = ""
                item.cellHeight = 60
                item.accessoryView = UIImageView(image: UIImage(named: "youjiantou"))
            }else
            {
                let swipe = XYInfomationItemSwipeConfig()
                swipe.canSwipe = true
                swipe.actionBtns = { cell in
                    let statusBtn = UIButton(frame: .init(origin: .zero, size: .init(width: 70, height: 0)))
                    statusBtn.setTitle("状态", for: .normal)
                    statusBtn.backgroundColor = .C_222222
                    
                    let editBtn = UIButton(frame: .init(origin: .zero, size: .init(width: 70, height: 0)))
                    editBtn.setTitle("编辑", for: .normal)
                    editBtn.backgroundColor = .C_587CF7
                    
                    let deletebtn = UIButton(frame: .init(origin: .zero, size: .init(width: 70, height: 0)))
                    deletebtn.setTitle("删除", for: .normal)
                    deletebtn.backgroundColor = .red
                    
                    let btns = [statusBtn, editBtn, deletebtn]
                    btns.forEach { btn in
                        btn.addBlock(for: .touchUpInside, block: { sender in
                            guard let actionBtn = sender as? UIButton else { return }
                            if actionBtn.currentTitle == "状态" {
                                self.cellStatusAction(cell: cell)
                            }
                            
                            if actionBtn.currentTitle == "编辑" {
                                self.cellEditAction(cell: cell)
                            }
                            
                            if actionBtn.currentTitle == "删除" {
                                self.cellDeleteAction(cell: cell)
                            }
                        })
                    }
                    
                    return btns
                }
                
                item.swipeConfig = swipe
            }
        }, sectionConfig: { section in
            section.corner(radius: 0)
            if self.tabbar.isSelectedHome == false {
                section.separatorInset = .init(top: 0, left: 47, bottom: 0, right: 0)
            }else{
                section.separatorInset = .init(top: 0, left: 77, bottom: 0, right: 0)
            }
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
        nav_hideBarBottomLine((scrollView.contentOffset.y < 1.5))
        
        if scrollView == tableView {
            if let indexpath = tableView.indexPathsForVisibleRows?.first {
                indexBar?.setSelectedLabel(indexpath.section)
            }
        }
    }
}

extension WechatHomeViewController: WechatTabbarProtocol {
    func didSeletedItem(item: TabbarItemInfo) {
        Toast.make("选择了 -- \(item.title)")
        self.title = item.title
        
        tableView.isHidden = !tabbar.isSelectedContact
        indexBar?.isHidden = !tabbar.isSelectedContact
        
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
        
        let listModels: [WXListModel] = XYFileManager.readFile(with: WXConfig.chatListFile)
//        listModels.map { model in // transform to xyinfotmationitem
//            model.
//        }
        
        var section: [[String: Any]] = []
        for listModel in listModels {
            let item = [
                "title": listModel.title ?? "",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": WXListCell.self,
                "obj": listModel
            ] as [String : Any]
            section.append(item)
        }
        
        let result: [[[String: Any]]] =
        [ // totoal
            section
//            [ // section 1
//                [ // cell 1
//                    "imageName": "discover_IconShowAlbum_22x22_",
//                    "title": "朋友圈",
//                    "type": XYInfoCellType.choose.rawValue,
//                    "titleKey": "wechat_chat",
//                ]
//            ]
        ]
        return result
    }
    
    @objc func wechatAddAction() {
        Toast.make("首页添加 --- ")
        
        let actionTitles: [String] = [
            "添加单聊",
            "添加群聊",
            "清空列表",
            "退出模拟器"]
        WXBubbleView.show(actionTitles: actionTitles) {[weak self] index in
            Toast.makeDebug("第\(index)被点击")
            
            if index == 0 {
                self?.push(WXAddSingleChatViewController(saveCallback: { [weak self] contact in
                    // 刷新会话列表
                    Toast.makeDebug("刷新会话列表 - 添加单聊")
                    
                    let model = WXListModel()
                    model.imageData = contact.imageData
                    model.title = contact.title
                    
                    XYFileManager.creatFile(with: WXConfig.chatListFile)
                    let models = XYFileManager.appendFile(with: WXConfig.chatListFile, model: model)
                    models.forEach { mo in
                        print(mo.timeStr)
                    }
                    
                    // update list
                    self?.refreshUI(data: self?.getWechatData() ?? [])
                    
                }), animated: true)
            }
            
            if index == 1 {
                self?.navigationController?.popViewController(animated: true)
            }
            
            if index == 2 {
                self?.navigationController?.popViewController(animated: true)
            }
            
            if index == 3 {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func cellStatusAction(cell: XYInfomationCell) {
        /*
         * - TODO -
         * 选择状态,返回状态的 iconName
         * 通过 iconName 修改数据源,刷新 Cell UI
         *  1. 当下只刷新内存中的 数据 / UI
         *  2. 当页面销毁/ App本身被销毁的时候,统一处理持久化数据
         */
        WXChooseStatusController.chooseStatus { iconName in
            if iconName.isEmpty {
                cell.resetInitialState()
                return
            }
            
            guard let obj = cell.model.obj as? WXListModel else { return }
            obj.statusName = iconName
            cell.model.obj = obj
            let model = cell.model
            cell.model = model
            cell.resetInitialState()
        }
    }
    
    func cellEditAction(cell: XYInfomationCell) {
        XYAlertSheetController.showDefault(on: self, title: "设置消息状态", subTitle: nil, actions: ["置顶聊天", "标记未读", "修改时间", "消息免打扰", "消息红点未读(免打扰状态)"]) { index in
            
            if (index >= 0) {
                cell.resetInitialState()
            }
            
            let a = UIView()
            let b = a
            if a == b {
                print("a == b")
            }
            
        }
        
        /*
         * TODO - 删除文件,内容
         *
         */
    }
    
    func cellDeleteAction(cell: XYInfomationCell) {
        let mode = cell.model
        mode.isFold = true
        cell.model = mode
        
        /*
         * TODO - 删除文件,内容
         *
         */
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
        
        // 每次进入通讯录刷新一下联系人数据源
        // ContactDataSource.update()

        if hasSetupTableView == true {
            return
        }else{
            hasSetupTableView = true
            setupTableView()
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = WXConfig.tableViewBgColor
        tableView.tableHeaderView = WechatSearchBarView()
        tableView.snp.remakeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(self.tabbar.snp.top)
        }
        //tableView.separatorInset = .init(top: 0, left: 70, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.isHidden = false
        tableView.reloadData()
        if #available(iOS 15.0, *) { // 移除系统组间距
            tableView.sectionHeaderTopPadding = 0
        } else { }
        
        
        indexBar?.delegate = self
        //indexBar?.setIndexes(["A","B","C"])
        indexBar?.selectedBackgroundColor = WXConfig.wxGreen
        indexBar?.setIndexes(sectionIndexTitles())
        view.addSubview(indexBar!)
        indexBar?.center.y = (CGFloat.height - .naviHeight - .tabBar) / 2
        
    }
    
    @objc
    func contactNavRightItemAction() {
        //Toast.make("联系人添加 --- ")
        push(WXAddRuleViewController(saveCallback: {[weak self] _ in
            self?.tableView.reloadData()
        }), animated: true)
    }
}

extension WechatHomeViewController : XYIndexBarDelegate {
    func indexDidChanged(_ indexBar: XYIndexBar!, index: Int, title: String!) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: false)
    }
}

extension WechatHomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getContactData().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getContactData()[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WXContactCell = (tableView.dequeueReusableCell(withIdentifier: "cellID") as? WXContactCell) ?? WXContactCell(style: .default, reuseIdentifier: "cellID")
        
        cell.model = getContactData()[indexPath.section][indexPath.row]
        
        return cell
    }
    
    var headerViewHeight: CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 { //
            return headerViewHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header: WXContactTableHaderFooterView = (tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? WXContactTableHaderFooterView) ?? WXContactTableHaderFooterView(reuseIdentifier: "header")
        
        header.label.text = ContactDataSource.sectionIndexTitles[section - 1]
        
        
        let result = header
        //let result = UIView()
        if section > 0 { // 第 0 组, 默认组,没有header
            result.backgroundColor = .random
        }
        return result
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return .line
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return .line
//    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return [UITableView.indexSearch ,"A", "B"]
//    }
    
    /// 返回所有联系人的首字符拼音
    /// - Returns: 字符串数组
    func sectionIndexTitles() -> [String] { // 🔍
        [""] + ContactDataSource.sectionIndexTitles
    }
    
    
    func getContactData() -> [[WXContact]]{
        var result = [[WXContact]]()
        let sction1 = [
            WXContact(image: UIImage(named: "wechat_lxr1") ?? .init(), title: "新的朋友"),
            WXContact(image: UIImage(named: "wechat_lxr2") ?? .init(), title: "群聊"),
            WXContact(image: UIImage(named: "wechat_lxr3")  ?? .init(), title: "标签"),
            WXContact(image: UIImage(named: "wechat_lxr4")  ?? .init(), title: "公众号")
        ]
        result.append(sction1)
        
        // sections
        for section in ContactDataSource.sections {
            result.append(section)
        }
//        let contacts = ContactDataSource.contacts
//        let indexTitles = sectionIndexTitles()
//        for (index,indexTitle) in indexTitles.enumerated() {
//            var section = [WXContact]()
//            for contact in contacts {
//                if contact.title.firstCharacterToPinyin() == indexTitle {
//                    section.append(contact)
//                }
//            }
//            result.append(section)
//
////            if index == indexTitles.count - 1 { // 最后一组数据手动添加一个总人数
////                section.append(WXContact(title: "\(contacts.count)位联系人"))
////            }
//        }
        
        // 简单看整体数据
        // var section2 = WXContact.createContactList()
        // section2.append(WXContact(title: "\(section2.count)位联系人"))
        // result.append(section2)
        return result
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
