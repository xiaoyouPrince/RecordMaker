//
//  WXDataSource.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/18.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/**
 微信数据源
 消息列表和消息详情共需要三张表
 
 wx_table_list 会话列表数据, 默认生成,直接查询即可
 wx_table_detail 会话详情本身 - 通过对端 ID 来查询对应会话的详情数据
 wx_table_msg_record 会话历史记录 - 通过对端 ID 来查询对应会话的历史消息记录
 
 wx_table_list 保存消息列表展示 UI 所需要的所有 key: value. (按时间和置顶状态排序)
     初始化(Create): App 首次安装并查询数据源的时候, 默认生成一个引导会话的会话(作者的会话)
     更新(Update): 在消息列表的删除会话/置为未读等操作, 消息详情内(wx_table_detail)的数据更新操作
     读取(Read): 直接读取数据列表,并绘制 UI 即可
     删除(Delete): 理论上表本身不会被删除,存储数据可能为空
 
 wx_table_detail 保存会话信息(如 target 对端用户信息, 会话状态)
     初始化(Create): App 首次安装并查询数据源的时候, 默认生成一个引导会话的会话(作者的会话)
     更新(Update): 在消息列表的删除会话/置为未读等操作, 消息详情内(wx_table_detail)的数据更新操作(静音,拉黑等)
     读取(Read): 通过会话 ID 来读取目标会话的详情数据
     删除(Delete): 理论上表本身不会被删除,存储数据可能为空

 wx_table_msg_record 会话历史记录(本质是一个ID: Array) - 通过对端 ID 来查询对应会话的历史消息记录
     初始化(Create): App 首次安装并查询数据源的时候, 默认生成一个引导会话的会话(作者的会话)
     更新(Update): 消息详情内(wx_table_detail)的数据更新操作(删除/更新某条消息), 或者发消息触发了系统安全机制
     读取(Read): 通过会话 ID 来读取目标会话的历史消息数据
     删除(Delete): 理论上表本身不会被删除,存储数据可能为空, 在消息列表删除会话的时候,删除对应记录
 
 */

/**
 微信通讯录列表
 
 wx_table_contact
 
 展示已经添加为好友的列表数据
     初始化(Create): App 首次安装并查询数据源的时候, 默认创建一些联系人
     更新(Update): 添加/删除联系人的时候更新
     读取(Read): 直接读全表的联系人信息
     删除(Delete): 理论上表本身不会被删除,存储数据可能为空
 
 */

import Foundation

struct ContactDataSource {
    /// 所有联系人 - 无序的原始数据
    static var contacts = WXContact.createContactList()
    /// 每一组的首字母 IndexTitles 已经排好序
    static var sectionIndexTitles: [String] = []
    /// 安首字母顺序排好的联系人组
    static var sections: [[WXContact]] = []
    
    static func update() {
        contacts = WXContact.createContactList()
        sectionIndexTitles = updateSectionIndexTitles()
        sections = updateSections()
    }
    
    static private func updateSectionIndexTitles() -> [String] {
        var allPinyin = [String]()
        
        // all pinyin
        let contacts = ContactDataSource.contacts
        for contact in contacts {
            let pinyin = contact.title.firstCharacterToPinyin()
            allPinyin.append(pinyin)
        }
        
        // sort unique
        let sorted = Set(allPinyin).sorted()
        return sorted
    }
    
    static private func updateSections() -> [[WXContact]] {
        var result = [[WXContact]]()
        
        let contacts = ContactDataSource.contacts
        let indexTitles = ContactDataSource.sectionIndexTitles
        for (index,indexTitle) in indexTitles.enumerated() {
            var section = [WXContact]()
            for contact in contacts {
                if contact.title.firstCharacterToPinyin() == indexTitle {
                    section.append(contact)
                }
            }
            
            if index == indexTitles.count - 1 { // 最后一组数据手动添加一个总人数
                section.append(WXContact(title: "\(contacts.count)位联系人"))
            }
            result.append(section)
        }
        
        // 标记是否为最后一个
        for section in result {
            for (index, item) in section.enumerated() {
                item.isLast = (index == section.count - 1)
                if item.image == nil { // 总人数的 cell 特殊处理
                    item.isLast = false
                }
            }
        }
        
        return result
    }
}

