//
//  MsgCellMenuManageer.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/11.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 管理 cell 点击时候菜单的一个工具
 * 比如某个cell被长按的时候有哪些菜单由此控制
 *
 *  因为cell类型较多,需要一个专门处理的工具,如果去哪都写到cell内部处理,会造成逻辑混乱,代码难以维护
 */

import Foundation
import UIKit
import XYUIKit

enum CellMenuAction: String, CaseIterable {
    case userDeleted = "被对方删除"
    case cancelUserDeleted = "取消被对方删除"
    case userBlocked = "被拉黑"
    case cancelUserBlocked = "取消被拉黑"
    case copy = "复制内容"
    case edit = "编辑"
    case recall = "撤回"
    case msgDelete = "删除消息"
    case changeUser = "切换发送方"
    case refer = "引用"
}

struct MsgCellMenuManageer {
    
    /// 展示菜单
    /// - Parameters:
    ///   - sender: 来源view, 在哪个 view 上展示菜单
    ///   - model: 消息数据模型
    ///   - callBack: 菜单按钮点击回调, 返回被点击 item.title
    static func showMenu(onView sender: UIView, forMsg model: WXDetailModel, callBack:@escaping(_ title: String)->()){
        let items = MsgCellMenuManageer.menusFor(msg: model)
        
        if let window = sender.window {
            for subV in window.subviews.reversed() {
                if subV is XYTagsView { return }
            }
            
            XYTagsView.config.tagBackgroundColor = .clear
            XYTagsView.config.tagMargin = .line
            XYTagsView.config.tagCornerRadius = 0
            let tagsView = XYTagsView(titles: items.map{$0.rawValue}, maxWitdh: .width - 130)
            tagsView.corner(radius: 5)
            tagsView.backgroundColor = UIColor.black.withAlphaComponent(0.95)
            
            window.addSubview(tagsView)
            let bubbleRect = sender.convert(sender.frame, to: window)
            tagsView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                var top = bubbleRect.minY - tagsView.height - 10
                if top < .naviBar {
                    top += 10 + bubbleRect.height + tagsView.height
                }
                make.top.equalTo(top)
                make.size.equalTo(tagsView.contentSize)
            }
            
            let cover = UIView()
            window.addSubview(cover)
            window.bringSubviewToFront(tagsView)
            cover.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            tagsView.tagClickCallback = {[weak tagsView, cover] title in
                tagsView?.removeFromSuperview()
                cover.removeFromSuperview()
                callBack(title)
            }
            
            cover.addTap {[weak tagsView] sender in
                tagsView?.removeFromSuperview()
                sender.removeFromSuperview()
            }
        }
    }
    
    /// 获取当前 msg 可以展示的所有菜单
    /// - Parameter msg: 消息对象本身
    /// - Returns: 菜单数组
    private static func menusFor(msg: WXDetailModel) -> [CellMenuAction] {
        var actionTitles: [CellMenuAction] = CellMenuAction.allCases
        
        if msg.isOutGoingMsg {
            switch msg.msgType {
            case .time:
                actionTitles = [.edit, .copy, .msgDelete]
                break
            case .text:
                break
            case .image:
                actionTitles = actionTitles.removeElement(.copy)
                break
            case .voice:
                actionTitles = actionTitles.removeElements([.copy, .refer])
                break
            case .video:
                actionTitles = actionTitles.removeElement(.copy)
                break
            case .voip:
                actionTitles = actionTitles.removeElements([.copy, .recall, .refer])
                break
            case .system:
                actionTitles = [.edit, .copy, .msgDelete]
                break
            case .red_packet:
                break
            case .money_transfer:
                break
            case .link:
                actionTitles = actionTitles.removeElements([.copy, .recall])
                break
            case .file:
                actionTitles = actionTitles.removeElements([.copy, .recall])
                break
            case .idCard:
                actionTitles = actionTitles.removeElements([.copy, .recall, .refer])
                break
            case .location:
                actionTitles = actionTitles.removeElements([.copy, .recall])
                break
            default:
                break
            }
            
            // 对于删除 / 拉黑处理
            if msg.isUserBeingBlocked == true {
                actionTitles = actionTitles.removeElement(.userBlocked)
            }else{
                actionTitles = actionTitles.removeElement(.cancelUserBlocked)
            }
            if msg.isUserBeingDeleted == true {
                actionTitles = actionTitles.removeElement(.userDeleted)
            }else{
                actionTitles = actionTitles.removeElement(.cancelUserDeleted)
            }
        }else{
            switch msg.msgType {
            case .time:
                actionTitles = [.edit, .copy, .msgDelete]
                break
            case .text:
                break
            case .image:
                actionTitles = actionTitles.removeElement(.copy)
                break
            case .voice:
                actionTitles = actionTitles.removeElements([.copy, .refer])
                break
            case .video:
                actionTitles = actionTitles.removeElement(.copy)
                break
            case .voip:
                actionTitles = actionTitles.removeElements([.copy, .recall, .refer])
                break
            case .system:
                actionTitles = [.edit, .copy, .msgDelete]
                break
            case .red_packet:
                break
            case .money_transfer:
                break
            case .link:
                actionTitles = [.edit, .msgDelete, .changeUser, .refer]
                break
            case .file:
                actionTitles = [.edit, .msgDelete, .changeUser, .refer]
                break
            case .idCard:
                actionTitles = [.edit, .msgDelete, .changeUser]
                break
            case .location:
                actionTitles = [.edit, .msgDelete, .changeUser, .refer]
                break
            default:
                break
            }
            
            let todelete: [CellMenuAction] = [.userDeleted, .userBlocked, .cancelUserBlocked, .cancelUserDeleted]
            actionTitles = actionTitles.removeElements(todelete)
        }
        
        return actionTitles
    }
}

extension Array {
    /// 删除某个元素
    /// - Parameter ele: 指定被删除的元素
    /// - Returns: 返回一个新数组
    func removeElement(_ ele: Element) -> [Element] where Element: Equatable {
        removeElements([ele])
    }
    
    /// 删除某些元素
    /// - Parameter ele: 指定被删除的元素
    /// - Returns: 返回一个新数组
    func removeElements(_ eles: [Element]) -> [Element] where Element: Equatable {
        let todelete: [Element] = eles
        return self.filter { oldEle in
            !todelete.contains(oldEle)
        }
    }
}
