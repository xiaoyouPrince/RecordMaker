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
import XYUIKit


extension Encodable {
    
    /// 此方法只能保证遵守 Encodable 协议的 类型被转换为 data, 其子类独有属性不能转换
    /**
     
     class Parent: Encodable {
         var name: String
         init(name: String) {
             self.name = name
         }
     }
     
     class Child: Parent {
         var age: Int
         init(name: String, age: Int) {
         self.age = age
             super.init(name: name)
         }
     }
     
     示例:
     let child = Child(name: "Child", age: 10)
     child.toString => { "name": ”Child“}
     child.toString => { "name": ”Child“}
     */
    var toData: Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            return data
        } catch {
            // error
            return nil
        }
    }
    
    var toString: String? {
        if let data = toData {
            return String(data: data, encoding: .utf8)
        }else{
            return ""
        }
    }
}

extension Data {
    func toModel<T: Decodable>() -> T? {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(T.self, from: self)
            return model
        } catch {
            // error
            return nil
        }
    }
}



/**
 *联系人数据源
 */
struct ContactDataSource {
    /// 所有联系人 - 无序的原始数据
    static var contacts: [WXContact] = WXContact.createContactList()
    /// 每一组的首字母 IndexTitles 已经排好序
    static var sectionIndexTitles: [String] = updateSectionIndexTitles()//[]
    /// 安首字母顺序排好的联系人组
    static var sections: [[WXContact]] = updateSections()//[]
    
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

/**
 *聊天列表
 */
struct DataSource_wxlist {
    
    static var listModel: [WXListModel] = XYFileManager.readFile(with: WXConfig.chatListFile)
    
    /// 经过排好序的
    static var listModels_sorted: [WXListModel] {
        sortListModels(with: DataSource_wxlist.listModel)
    }
    
    /// 对指定列表数组进行排序
    /// - Parameter models: 指定数据源
    /// - Returns: 排好序的数据源
    static func sortListModels(with models: [WXListModel]) -> [WXListModel] {
        var listModels: [WXListModel] = models
        listModels = listModels.sorted { m1, m2 in
            if m1.isTop == true {
                if m2.isTop == true {
                    return m1.time > m2.time
                }else{
                    return true
                }
            }else
            {
                if m2.isTop == true {
                    return false
                }else
                {
                    return m1.time > m2.time
                }
            }
        }
        return listModels
    }
    
    /*
     * - TODO -
     * 更新持久化微信列表数据
     *
     *  1. 只需要更新文件即可,内存中依旧使用内存数据,下次进入的时候才会对去文件
     */
    static func update() {
        DispatchQueue.global().async {
            XYFileManager.writeFile(with: WXConfig.chatListFile, models: listModel)
        }
    }
    
    /*
     * - TODO -
     * 删除指定数据
     */
    static func remove(model: WXListModel) {
        DispatchQueue.global().async {
            listModel = listModel.filter { item in
                !(item.contactID == model.contactID && item.title == model.title)
            }
            XYFileManager.writeFile(with: WXConfig.chatListFile, models: listModel)
        }
    }
}

/*
 * - TODO -
 * 聊天详情数据源
 *
 *  1. 获取列表数据 - 按时间排序
 *  2. 用户手动修改顺序, 这里方案暂定为: 修改两者时间,并持久化存储
 */
class DataSource_wxDetail {
    
    /// 当前会话聊天目标对象数据源归档文件路径
    static var targetDB_filePath: String {
        let db_fileName = targetContact!.title + "\(targetContact?.id ?? 0)"
        return db_fileName
    }
    
    /// 当前会话目标对象 - 整个会话是通用的
    static var targetContact: WXContact? {
        didSet {
            guard let targetContact = targetContact else { return }
            let db_fileName = targetContact.title + "\(targetContact.id ?? 0)"
            allMessages = XYFileManager.readFile(with: db_fileName)
            
            // 如果初次进入会话,没有数据,手动加一个系统数据
            if allMessages?.isEmpty == true {
                let msg = WXDetailModel(timeInterval: .since1970)
                allMessages?.append(msg)
                // save
                guard let allMsgs = allMessages else { return }
                XYFileManager.writeFile(with: db_fileName, models: allMsgs)
            }
        }
    }
    
    /// 当前会话所有的消息数据的数组
    static var allMessages: [WXDetailModel]?
    
    /// 当前会话的当前发言人, 是用户自己还是对端用户
    static var currentSpeaker: WXContact?
    /// 当前被发言的人, 单聊中就是用户自己或者 targetContact, 群聊中就是更具体的对方
    static var currentUserBeingSpoken: WXContact? {
        if currentSpeaker == nil { // 默认没有设置的时候就是对方<当前仅为单聊,群聊后续处理>
            return targetContact ?? WXContact.init(userInfo: WXUserInfo.shared)
        }
        
        if currentSpeaker?.userInfo.wechatId == WXUserInfo.shared.wechatId {
            return targetContact
        }else{
            return WXContact.init(userInfo: WXUserInfo.shared)
        }
    }
    
}
