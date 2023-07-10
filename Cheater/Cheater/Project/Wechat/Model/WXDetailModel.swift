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


protocol WXDetailContentProtocol: NSObjectProtocol {
    var showIconImage: Bool { get }
    var showNamelable: Bool { get }
    var contentEdges: UIEdgeInsets { get }
    var showReadLabel: Bool { get }
    var contentClass: UIView.Type { get }
    func setModel(_ data: WXDetailModel) // 有点儿不好组织
    init()
}

extension WXDetailContentProtocol {
    var showIconImage: Bool { true }
    var showNamelable: Bool { false }
    var contentEdges: UIEdgeInsets { .zero }
    var showReadLabel: Bool { true }
}

//
//class PictureModel: WXDetailContentProtocol {
//    func setModel(_ data: Data) {
//
//    }
//
//    var contentClass: UIView.Type {
//        return UIView.self
//    }
//}


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
    
    /// 真实存储的消息内容 - 由于前后端都在客户端,这里直接用属性先
    var data: Data?
}

extension WXDetailModel {
    
    convenience init(text: String) {
        self.init()
        self.text = text
        self.msgType = .text
        self.data = text.data(using: .utf8)
    }
    
    /// 消息内容真实类型
    var contentClass: WXDetailContentProtocol.Type {
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
        if from == WXUserInfo.shared.id {
            return true
        }
        
        return false
    }
}
