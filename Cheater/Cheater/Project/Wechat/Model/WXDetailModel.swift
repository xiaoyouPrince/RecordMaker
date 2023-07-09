//
//  WXDetailModel.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 微信聊天详情的cell数据模型
 * <#这里输入你要做的事情的一些思路#>
 *  <#1. ...#>
 *  <#2. ...#>
 */


import Foundation
import UIKit


protocol WXDetailContentProtocol {
    
}

class PictureModel: WXDetailContentProtocol {
    
}




enum MsgType: Int, Codable {
    case text           // 文本
    case image          // 图片
    case video          // 视频
    case system         // 系统通知
    case red_packet     // 红包
    case money_tansfor  // 转账
    case link           // 链接
}

class WXDetailModel: Codable {
    
    /// 消息类型
    var msgType: MsgType? = .text
    /// 消息发送者
    var from: Int?
    /// 只有是 .text 类型时候有效
    var text: String?
    
    /// 真实存储的消息内容
    var data: Data?
    
    var contentModel: WXDetailContentProtocol? {
        return PictureModel()
    }
}

extension WXDetailModel {
    
    /// 消息内容真实类型
    var contentClass: UIView.Type {
        switch msgType {
        case .text:
            return CellContentText.self
        default:
            break
        }
        
        return CellContentText.self
    }
    
    /// 是否是自己发出的消息
    var isOutGoingMsg: Bool {
        if from == DataSource_wxDetail.targetContact?.id {
            return true
        }
        
        return false
    }
}
