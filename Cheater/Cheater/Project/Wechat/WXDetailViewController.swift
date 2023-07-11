//
//  WXDetailViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 微信聊天详情页面
 *
 *  1. UI -> (navBar + tableView + inputView)
 *  2. Data -> (暂时用文件, 后续使用数据库改造)
 */

import Foundation
import XYUIKit
import AudioToolbox

/// 微信消息有更新的协议
protocol WXMessageDidupdateProtocol: AnyObject {
    /// 最后一条消息有更新, 列表需要刷新, 内部做持久化操作
    func lastMessageDidupdate()
}


class WXDetailViewController: UIViewController {
    
    var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    var sessionInputView = ChatInputView()
    var lsitModel: WXListModel
    var dataArray: [WXDetailModel]
    /// 当前发送者id, 默认是自己,后续可以随时调整
    var currentSenderID: Int = WXUserInfo.shared.id
    weak var delegate: WXMessageDidupdateProtocol?
    
    init(listModel: WXListModel, delegate: WXMessageDidupdateProtocol) {
        self.lsitModel = listModel
        self.delegate = delegate
        /*
         * - TODO -
         * 进入详情的参数,目的是知道找哪个目标聊天记录的文件
         */
        guard let targetContact = listModel.targetContact else { fatalError("无目标对象,数据异常") }
        DataSource_wxDetail.targetContact = targetContact
        self.dataArray = DataSource_wxDetail.allMessages ?? []
        
        super.init(nibName: nil, bundle: nil)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
    func setupUI() {
        view.backgroundColor = WXConfig.navBarBgColor
        
        setupNav()
        setupTableView()
        setupSessionInputView()
        layoutSubviews()
    }
    
    func setupNav() {
        setNavbarWechat()
        nav_setCustom(backImage: WXConfig.wx_backImag)
        
        // right
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(rightBtnClick), image: .wx_right_3dot, imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: -20))
        
        // titleView + aciton
        let titleViewCoverView = UIView(frame: .init(origin: .init(x: 100, y: 0), size: CGSize(width: .width - 200, height: 44)))
        navigationController?.navigationBar .addSubview(titleViewCoverView)
        titleViewCoverView.backgroundColor = .red.withAlphaComponent(0.5)
        titleViewCoverView.addTap { [weak self] sender in
            // guard let corverView as
            Toast.make("切换发言者 - 给个震动反馈 (群聊特殊处理)")
            guard let self = self, let targetId = DataSource_wxDetail.targetContact?.id else{ return }
            let mineId = WXUserInfo.shared.id
            
            if self.currentSenderID == targetId {
                self.currentSenderID = mineId
            } else
            {
                self.currentSenderID = targetId
            }
            
            
            
            
            
            // 震动一下
            //AudioServicesPlaySystemSound(0)
            
            /*
             * - TODO -
             * 切换当前发言者 && 震动反馈
             * 如果是群聊,需要特殊处理,可以弹框手动选择发言人
             */
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WXDetailCell.self, forCellReuseIdentifier: WXDetailCell.indentifier)
        tableView.estimatedRowHeight = 20 + 8 + 8 //UITableView.automaticDimension
    }
    
    func setupSessionInputView() {
        view.addSubview(sessionInputView)
        sessionInputView.deledate = self
    }
    
    func layoutSubviews(){
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(sessionInputView.snp.top)
            make.height.equalTo(CGFloat.height - CGFloat.tabBar)
        }
        
        sessionInputView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(CGFloat.tabBar)
        }
    }
    
    
}

extension WXDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //sessionInputView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: WXDetailCell.indentifier) as? WXDetailCell
        if cell == nil {
            cell = WXDetailCell.init(style: .default, reuseIdentifier: WXDetailCell.indentifier)
        }
        
        // cell config
        // ...
        cell?.model = self.dataArray[indexPath.row]
        
        return cell!
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.scrollToRow(at: .init(row: dataArray.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    
}

// MARK: - 输入框的代理回调

extension WXDetailViewController: ChatInputViewCallBackProtocal {
    func sendBtnClick(text: String) {
        // Toast.make("发送 - \(text)")
        let model = WXDetailModel.init(text: text)
        model.from = currentSenderID
        
        self.dataArray.append(model)
        XYFileManager.writeFile(with: DataSource_wxDetail.targetDB_filePath, models: self.dataArray)
        
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count-1, section: 0), at: .bottom, animated: true)
        }
        
        // 更新消息列表最后一句话和时间
        self.lsitModel.time = Date().timeIntervalSince1970
        self.lsitModel.lsatMessage = text
        self.lsitModel.updateListMemory()
        self.delegate?.lastMessageDidupdate()
    }
    
    func keyboardWillShow(_ noti: Notification) {
        let cover = UIView()
        cover.tag = 711 // date of create
        view.insertSubview(cover, aboveSubview: tableView)
        cover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cover.addTap {[weak self] sender in
            self?.sessionInputView.resignFirstResponder()
        }
    }
    
    func keyboardWillHide(_ noti: Notification) {
        view.findSubView { cover in
            if cover.tag == 711 {
                cover.removeFromSuperview()
                return true
            }
            return false
        }
    }
}

extension WXDetailViewController {
    
    @objc func leftBtnClick(){
        Toast.make("leftBtnClick")
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnClick(){
        Toast.make("rightBtnClick")
        
        /*
         * - TODO -
         * 随机生成一条文本消息,并放入UI
         * <#这里输入你要做的事情的一些思路#>
         *  <#1. ...#>
         *  <#2. ...#>
         */
        
        
        let titles = [
            "你好",
            "随机生成一条文本消息,并放入UI",
            "随机生成一条文本消息,并放入UI随机生成一条文本消息,并放入UI随机生成一条文本消息,并放入UI",
            "ZTC晋升申请表-202206月ZTC晋升申请表-202206月"
        ]
        
        let model = WXDetailModel.init(text: titles[Int(arc4random())%4])
        if (arc4random() % 2) == 0 {
            model.from = WXUserInfo.shared.id
        }
        self.dataArray.append(model)
        XYFileManager.writeFile(with: DataSource_wxDetail.targetDB_filePath, models: self.dataArray)
        
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count-1, section: 0), at: .bottom, animated: true)
        }
    }
}
