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
    
    static func showMenu(onView sender: UIView, forMsg model: WXDetailModel, callBack:@escaping(_ title: String)->()){
        let items = MsgCellMenuManageer.menusFor(msg: model)
        
        //            // 删除
        //            let delete = UIMenuItem(title: "删除", action: #selector(self.deleteMsg))
        //
        //            // 复制
        //            let copy = UIMenuItem(title: "复制", action: #selector(self.copyText))
        //
        //            // 编辑
        //            let edit = UIMenuItem(title: "编辑", action: #selector(self.cellEdit))
        
        //            let mc = UIMenuController.shared
        //            mc.menuItems = menuItems
        //            mc.showMenu(from: sender, rect: sender.subviews.first?.frame ?? .zero)
        
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
            case .text:
                if msg.isUserBeingBlocked == true {
                    actionTitles = actionTitles.filter({ menuAction in
                        menuAction != .userBlocked
                    })
                }else{
                    actionTitles = actionTitles.filter({ menuAction in
                        menuAction != .cancelUserBlocked
                    })
                }
                if msg.isUserBeingDeleted == true {
                    actionTitles = actionTitles.filter({ menuAction in
                        menuAction != .userDeleted
                    })
                }else{
                    actionTitles = actionTitles.filter({ menuAction in
                        menuAction != .cancelUserDeleted
                    })
                }
            default:
                break
            }
        }else{
            switch msg.msgType {
            case .text:
                let todelete: [CellMenuAction] = [.userDeleted, .userBlocked, .cancelUserBlocked, .cancelUserDeleted]
                actionTitles = actionTitles.filter({ menuAction in
                    !todelete.contains(menuAction)
                })
            default:
                break
            }
        }
        
        return actionTitles
    }
    

}
