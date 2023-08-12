//
//  WXListCellLeftSwiptHelper.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/7.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 微信列表 cell 左滑动事件处理工具
 * 协助Controller处理cell滑动相关功能,减轻负担
 *  1. 设置微信状态
 *  2. cell 内容编辑
 *  3. cell 删除
 */

import Foundation
import UIKit
import XYUIKit
import XYInfomationSection

extension XYInfomationCell {
    
    /// 获取 微信 列表的数据模型
    var wxListModel: WXListModel? {
        guard let obj = model.obj as? WXListModel else { return nil }
        return obj
    }
    
    /// 获取当前所在组
    var sectionView: XYInfomationSection? {
        superview as? XYInfomationSection
    }
    
    /// 获取微信聊天列表
    var chatListVC: WechatHomeViewController? {
        viewController as? WechatHomeViewController
    }
    
    /// 更新cell.真实模型
    /// - Parameter configurationHandler: 更新内容
    func remove() {
        guard let listModel = wxListModel else { return }
        self.model.isFold = true
        model = self.model
        
        // 更新列表持久化数据
        DataSource_wxlist.remove(model: listModel)
    }
    
    /// 更新cell.真实模型
    /// - Parameter configurationHandler: 更新内容
    func update(_ configurationHandler: ((_ listModel: WXListModel) -> Void)) {
        guard let listModel = wxListModel else { return }
        configurationHandler(listModel)
        model = self.model
        
        // 更新完之后归位
        resetInitialState()
        
        // 更新列表持久化数据
        DataSource_wxlist.update()
    }
    
    /// 更新cell.真实模型, 完成之后刷新Cell所在列表
    /// - Parameter configurationHandler: 更新内容
    func updateAndRefreshList(_ configurationHandler: ((_ listModel: WXListModel) -> Void)) {
        update(configurationHandler)
        chatListVC?.refreshWXListUI()
    }
}

struct CellSwipeHelper {
    
    /// 添加微信列表cell滑动功能
    func addSwipeFeature(for item: XYInfomationItem) {
        
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
    
    /// Cell 左滑设置状态
    /// - Parameter cell: cell
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
            
            cell.update { listModel in
                listModel.statusName = iconName
            }
        }
    }
    
    /// Cell 左滑编辑功能
    /// - Parameter cell: cell
    func cellEditAction(cell: XYInfomationCell) {
        
        let listModel = cell.wxListModel
        var topTitle = "置顶聊天"
        if listModel?.isTop == true {
            topTitle = "取消置顶"
        }
        
        XYAlertSheetController.showDefault(on: UIViewController.currentVisibleVC, title: "设置消息状态", subTitle: nil, actions: [topTitle, "标记未读", "修改时间", "消息免打扰", "消息红点未读(免打扰状态)"]) { index in
            
            if index == 0 { // 置顶/取消置顶 - 需刷新列表
                cell.updateAndRefreshList { listModel in
                    listModel.isTop = !(listModel.isTop ?? false)
                }
            }
            
            if index == 1 { // 标记未读
                AlertController.showInputCountAlert { text in
                    cell.update { listModel in
                        listModel.badgeInt = Int(text)
                    }
                    
                    cell.chatListVC?.refreshWXTabbarTotalCount()
                    
                    /*
                     * - TODO -
                     * 标记未读数,需要同时修改底部 tabbar 数量
                     * 当用户点击进入某个会话,
                     *  1. 消除当前会话本身未读数
                     *  2. 底部 tabbar 未读数同步减少
                     */
                }
            }
            
            if index == 2 { // change time
                DatePickerController.chooseDate { timeInterval in
                    if timeInterval >= 0 {
                        cell.updateAndRefreshList { listModel in
                            listModel.time = timeInterval
                        }
                    }else{
                        cell.resetInitialState()
                    }
                }
            }
            
            if index == 3 { // 消息免打扰
                cell.update { listModel in
                    listModel.noDisturb = !(listModel.noDisturb ?? false)
                }
            }
            
            if index == 4 { // 消息红点未读(免打扰状态)
                cell.updateAndRefreshList { listModel in
                    listModel.silenceNotify = !(listModel.silenceNotify ?? false)
                }
            }
        }
        
        /*
         * TODO - 删除文件,内容
         *
         */
    }
    
    /// Cell 左滑删除
    /// - Parameter cell: cell
    func cellDeleteAction(cell: XYInfomationCell) {
        cell.remove()
        
        /*
         * TODO - 删除文件,内容
         *
         */
    }
    
}
