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
    var sessionInputView = UIView()
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WXDetailCell.self, forCellReuseIdentifier: WXDetailCell.indentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func setupSessionInputView() {
        view.addSubview(sessionInputView)
    }
    
    func layoutSubviews(){
        
        tableView.snp.makeConstraints { make in
            make.left.left.right.top.equalToSuperview()
            make.bottom.equalTo(sessionInputView.snp.top)
        }
        
        sessionInputView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(CGFloat.tabBar)
        }
    }
    
    
}

extension WXDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    }
}
