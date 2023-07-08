//
//  DatePickerController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/8.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import Foundation
import XYUIKit

struct DatePickerController {
    
    static func chooseDate(_ callback:@escaping (TimeInterval)->()) {
        
        let datePicker = UIDatePicker()
        // 设置时间选择器的模式为日期和时间
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        // 设置时间选择器的本地化语言
        datePicker.locale = Locale.current
        
        // 设置时间选择器的日期范围（可选）
        let currentDate = Date()
        let twoYearBeforeNow = Calendar.current.date(byAdding: .year, value: -2, to: currentDate)
        datePicker.minimumDate = currentDate
        datePicker.maximumDate = twoYearBeforeNow
        
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(280)
        }
        
        XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customHeader: datePicker, actions: [.init(title: "确定")]) { index in
            
//            cell.resetInitialState()
//
            if index == 0 {
                let interval = datePicker.date.timeIntervalSince1970
//                cell.updateAndRefreshList { listModel in
//                    listModel.time = interval
//                }
                callback(interval)
            }
            callback(-1) // 仅仅取消
        }
    }
}
