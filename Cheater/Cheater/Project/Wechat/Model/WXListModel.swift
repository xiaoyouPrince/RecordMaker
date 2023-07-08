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
}

extension WXListModel {
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    var timeStr: String {
        showDetailTime(msgTime: time)
    }
    
    private func showDetailTime(msgTime: TimeInterval) -> String {
        let nowDate = Date()
        let msgDate = Date(timeIntervalSince1970: msgTime)
        var result = ""
        
        let components: Set<Calendar.Component> = [.year, .month, .day, .weekday, .hour, .minute, .second]
        let nowDateComponents = Calendar.current.dateComponents(components, from: nowDate)
        let msgDateComponents = Calendar.current.dateComponents(components, from: msgDate)
        
        let hour = msgDateComponents.hour ?? 0
        
        let nowDateTime = Int(nowDate.timeIntervalSince1970) - (nowDateComponents.hour ?? 0) * 3600 - (nowDateComponents.minute ?? 0) * 60 - (nowDateComponents.second ?? 0)
        let msgDateTime = Int(msgTime) - (msgDateComponents.hour ?? 0) * 3600 - (msgDateComponents.minute ?? 0) * 60 - (msgDateComponents.second ?? 0)
        let isDataInWeek = (nowDateTime - msgDateTime) < 7 * 24 * 3600
        
        if Calendar.current.isDateInToday(msgDate) { // 当天,显示时间
            result = "\(result) \(hour):\(msgDateComponents.minute ?? 0)"
        } else if Calendar.current.isDateInYesterday(msgDate) { // 昨天,显示昨天
            result = "昨天\(result) \(hour):\(msgDateComponents.minute ?? 0)"
        } else if isDataInWeek { // 同一周内, 显示星期N
            let weekday = msgDateComponents.weekday ?? 0
            let weekArray = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
            if weekday - 1 >= 0 && weekday - 1 <= 6 {
                result = "\(weekArray[weekday-1]) \(hour):\(msgDateComponents.minute ?? 0)"
            } else {
                result = "\(msgDateComponents.month ?? 0)月\(msgDateComponents.day ?? 0)日 \(hour):\(msgDateComponents.minute ?? 0)"
            }
        } else if nowDateComponents.year == msgDateComponents.year { // 当年,不显示年
            result = "\(msgDateComponents.month ?? 0)月\(msgDateComponents.day ?? 0)日 \(hour):\(msgDateComponents.minute ?? 0)"
        } else { // 非当年,显示日期
            result = "\(msgDateComponents.year ?? 0)年\(msgDateComponents.month ?? 0)月\(msgDateComponents.day ?? 0)日 \(hour):\(msgDateComponents.minute ?? 0)"
        }
        
        return result
    }
}
