//
//  WXListModel.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/4.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/**
 微信聊天列表数据模型
 */

import UIKit

/// 可以用 struct, 但是此模型数据内容过多,并且频繁修改各种状态,在此使用 class
class WXListModel: Codable {
    /// 前三个来自 联系人,  -- 这里可以通过 ID 找到真实联系人
    var contactID: Int?
    var imageData: Data?
    var title: String?
    
    var time: TimeInterval = Date().timeIntervalSince1970
    var statusName: String?
    var isTop: Bool? = false
    /// 未读数, 此属性和静默通知的红点互斥
    var badgeInt: Int? = 0 {
        didSet{
            if (badgeInt ?? 0) > 0 {
                silenceNotify = false
            }
        }
    }
    /// 是否是免打扰状态
    var noDisturb: Bool? = false
    /// 是否有消息免打扰的静默通知, 显示为红点, 此属性和红点数字互斥
    var silenceNotify: Bool? = false{
        didSet{
            if silenceNotify == true {
                badgeInt = 0
            }
        }
    }
    var lsatMessage: String?
}

extension WXListModel {
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    var timeStr: String {
        TimeTool.timeString(from: time)
    }
}

extension WXListModel {
    
    /// 更新消息列表数据
    func updateListMemory() {
        saveArchive()
    }
    
    /// 保存到内存,并更新到文件,持久化存储
    func appendMemoryAndArchive() {
        // update memory
        DataSource_wxlist.listModel.append(self)
        
        saveArchive()
    }
    
    /// 持久化存储
    func saveArchive() {
        DispatchQueue.global().async {
            // update file
            DataSource_wxlist.update()
        }
    }
    
    /// 会话目标对象
    var targetContact: WXContact? {
        var targetContact: WXContact? = nil
        let contacts = ContactDataSource.contacts
        for contact in contacts {
            if contact.id == contactID, contact.title == title {
                targetContact = contact
            }
        }
        return targetContact
    }
}
