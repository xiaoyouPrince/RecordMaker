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


class WXDetailViewController: UIViewController {
    
    var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    var sessionInputView = ChatInputView()
    var lsitModel: WXListModel
    var dataArray: [WXDetailModel]
    
    init(listModel: WXListModel) {
        self.lsitModel = listModel
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
        titleViewCoverView.addTap { sender in
            // guard let corverView as
            Toast.make("切换发言者 - 给个震动反馈")
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
    }
    
    func layoutSubviews(){
        
        tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(sessionInputView.snp.top)
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
