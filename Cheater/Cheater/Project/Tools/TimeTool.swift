//
//  TimeTool.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/14.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 一个简单的时间字符串函数
 /// 显示时间文字
 /// 规则:
 ///     当天显示具体时间 egg: 09:30。上午 09:30
 ///     昨天显示具体时间 egg: 昨天 09:30。昨天 上午 09:30
 ///     前天显示星期几+时间 egg: 星期三 09:30 星期三 上午 09:30
 ///     前7天之外的时间显示几月几日 egg: 7月14日 09:30, 7月 14日 上午 09:30
 ///     非本年的显示年月日时间 egg: 2023年7月14日 09:30, 2023年 7月 14日 上午 09:30
 */
import Foundation

struct TimeTool {
    
    /// 展示完整的时间字符串
    /// - Parameter timeInterval: 时间戳
    /// - Returns: egg: 2020年9月29日 10:23:30
    static func fullTime(from timeInterval: TimeInterval) -> String {
        Date(timeIntervalSince1970: timeInterval).string(withFormatter: "yyyy年MM月dd日 HH:mm:ss")
    }
    
    static func timeString(from timeInterval: TimeInterval) -> String {
        return showDetailTime(msgTime: timeInterval)
    }
    
    private static func showDetailTime(msgTime: TimeInterval) -> String {
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
