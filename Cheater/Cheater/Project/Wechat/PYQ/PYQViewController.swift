//
//  PYQViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/9/2.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 朋友圈页面
 *
 *  1. 朋友圈页面统一配置项, 页面内部共享信息类型封装协议了,朋友圈整个模块可用
 *  2. 仿写微信 —— UI & logic
 */

import Foundation
import UIKit
import XYUIKit
import XYInfomationSection

class PYQViewController: UIViewController {
    
    var navBar_bg: TimelineNavBar?
    var navBar: TimelineNavBar?
    let tableView = UITableView()
    private(set) var statusStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBar = navBar, let navBar_bg = navBar_bg {
            view.bringSubviewToFront(navBar_bg)
            view.bringSubviewToFront(navBar)
        }
    }
}

extension PYQViewController {
    
    func buildUI() {
        setupNav()
        setupContent()
    }
    
    func setupNav() {
        title = "朋友圈"
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        navBar_bg = TimelineNavBar(backAction: {[weak self] in
            self?.navLeftBtnClick()
        }, rightAction: {[weak self] in
            self?.navRightBtnClick()
        })
        if let navBar = navBar_bg {
            view.addSubview(navBar)
            navBar.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.equalTo(CGFloat.naviBar)
            }
        }
        
        navBar = TimelineNavBar(backAction: {[weak self] in
            self?.navLeftBtnClick()
        }, rightAction: {[weak self] in
            self?.navRightBtnClick()
        })
        if let navBar = navBar {
            view.addSubview(navBar)
            navBar.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.equalTo(CGFloat.naviBar)
            }
        }
    }
    
    @objc func navLeftBtnClick(){
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func navRightBtnClick(){
        // right item click
    }
    
    func setupContent() {
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineCell.indentifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = 44
        tableView.tableHeaderView = TimelineTableHeader()
        
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(-CGFloat.safeTop)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension PYQViewController: UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusStyle
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 { return }
        
        let ratio = (abs(scrollView.contentOffset.y) - 100) / 100
        navBar_bg?.tintColor = UIColor.white.withAlphaComponent(1-ratio)
        navBar?.tintColor = UIColor.black.withAlphaComponent(ratio)
        navBar?.backgroundColor = UIColor.C_wx_navbar_viewbgColor.withAlphaComponent(ratio)
        navBar?.updateTitle(title: self.title ?? "", textColor: UIColor.black.withAlphaComponent(ratio))
        
        if ratio > 0.1 {
            statusStyle = .darkContent
        }else{
            statusStyle = .lightContent
        }
        
        print(ratio)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TimelineCell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.indentifier) as? TimelineCell ?? .init()
        cell.backgroundColor = .random
        return cell
    }
}

extension PYQViewController {
    
    func loadData() {
        // refreshUI
    }
    
}

extension UIImage {
    static var nav_back_black = UIImage(named: "fanhui_black")?.withRenderingMode(.alwaysOriginal)
    static var nav_back_write = UIImage(named: "fanhui_black")?.withRenderingMode(.alwaysTemplate)
    
    static var nav_camera_black = UIImage(named: "timeline-icon1-black-new")?.withRenderingMode(.alwaysOriginal)
    static var nav_camera_white = UIImage(named: "timeline-icon1-black-new")?.withRenderingMode(.alwaysTemplate)
}

