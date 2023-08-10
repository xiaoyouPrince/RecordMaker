//
//  CellContentTime.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/14.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

/// 时间戳数据模型
class MsgTimeModel: Codable {
    var time: TimeInterval? = Date().timeIntervalSince1970
    var is24hous: Bool? = true
    
    /// 显示时间文字
    /// 规则:
    ///     当天显示具体时间 egg: 09:30。上午 09:30
    ///     昨天显示具体时间 egg: 昨天 09:30。昨天 上午 09:30
    ///     前天显示星期几+时间 egg: 星期三 09:30 星期三 上午 09:30
    ///     前7天之外的时间显示几月几日 egg: 7月14日 09:30, 7月 14日 上午 09:30
    ///     非本年的显示年月日时间 egg: 2023年7月14日 09:30, 2023年 7月 14日 上午 09:30
    var timeString: String {
        if is24hous == true { // 是 24 小时格式
            
        }
        else
        { // 12 小时格式 展示上午/下午
            
        }
        
        return TimeTool.timeString(from: time ?? Date().timeIntervalSince1970)
    }
}


class CellContentTime: UIView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(label)
        
        label.textAlignment = .center
        label.textColor = .C_wx_tip_text
        label.font = UIFont.systemFont(ofSize: 15)
    }
}

extension CellContentTime: WXDetailContentProtocol {
    var contentClass: UIView.Type {
        CellContentTime.self
    }
    
    var fullCustom: Bool { true }
    
    func setModel(_ model: WXDetailModel) {
        guard let data: MsgTimeModel = model.data?.toModel() else { return }
        setModel(data)
    }
    
    func setModel(_ data: MsgTimeModel) {
        
        let timeSting = data.timeString
        label.text = timeSting
        let stringHeight = timeSting.heightOf(font: label.font, size: .init(width: .width, height: .height))
        
        label.snp.remakeConstraints { make in
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.top.equalTo(15)    // top 距离大一些
            make.bottom.equalTo(-8)
            make.height.equalTo(stringHeight)
        }
    }
}
