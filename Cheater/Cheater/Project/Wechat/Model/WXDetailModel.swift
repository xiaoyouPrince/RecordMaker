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

// MARK: - 消息内容 view 协议

protocol WXDetailContentProtocol: NSObjectProtocol {
    var showIconImage: Bool { get }
    var showNamelable: Bool { get }
    var contentEdges: UIEdgeInsets { get }
    var showReadLabel: Bool { get }
    var fullCustom: Bool { get }
    var contentClass: UIView.Type { get }
    func setModel(_ data: WXDetailModel) // 有点儿不好组织
    init()
}

extension WXDetailContentProtocol {
    var showIconImage: Bool { true }
    var showNamelable: Bool { false }
    var contentEdges: UIEdgeInsets { .zero }
    var showReadLabel: Bool { true }
    var fullCustom: Bool { false }
}


enum MsgType: Int, Codable {
    case time           // 时间戳
    case text           // 文本
    case voice          // 语音
    case image          // 图片
    case video          // 视频
    case voip           // 音视频通话
    case system         // 系统通知
    case red_packet     // 红包
    case money_transfer  // 转账
    case link           // 链接
    case file           // 文件
    case idCard         // 名片
}

class WXDetailModel: Codable {
    
    /// 消息类型
    var msgType: MsgType? = .text
    /// 消息发送者
    var from: Int?
    /// 只有是 .text 类型时候有效
    var text: String?
    /// 消息发送时间戳
    var timeInterval: TimeInterval? = Date().timeIntervalSince1970
    
    /// 真实存储的消息内容 - 由于前后端都在客户端,这里直接用属性先
    /// 根据真实的 megType, 此数据可以解析为真正的 content 类型
    var data: Data?
    
    /// 图片消息可以存储imageName 动态加载图片库图片
    var imageName: String?
}

extension WXDetailModel {
    
    /// 快速创建一个 名片 消息
    convenience init(idCard: MsgModelIDCard? = nil) {
        self.init()
        self.msgType = .idCard
        self.data = idCard.toData
    }
    
    /// 快速创建一个 文件类型消息
    convenience init(file: MsgModelFile? = nil) {
        self.init()
        self.msgType = .file
        self.data = file.toData
    }
    
    /// 快速创建一个 链接🔗 类型消息
    convenience init(link: MsgModelLink? = nil) {
        self.init()
        self.msgType = .link
        self.data = link.toData
    }
    
    /// 快速创建一个 转账 类型消息
    convenience init(systemMsg: MsgSystemModel? = nil) {
        self.init()
        self.msgType = .system
        self.data = systemMsg.toData
    }
    
    /// 快速创建一个 转账 类型消息
    convenience init(moneyTransfer: MsgMoneyTransferModel? = nil) {
        self.init()
        self.msgType = .money_transfer
        self.data = moneyTransfer.toData
    }
    
    /// 快速创建一个 红包 类型消息
    convenience init(redPacket: MsgRedPacketModel? = nil) {
        self.init()
        self.msgType = .red_packet
        self.data = redPacket.toData
    }
    
    /// 快速创建一个 Voip 类型消息
    convenience init(voip: MsgVoipModel? = nil) {
        self.init()
        self.msgType = .voip
        self.data = voip.toData
    }
    
    /// 快速创建一个图片类型消息
    convenience init(video: MsgVideoModel? = nil) {
        self.init()
        self.msgType = .video
        self.data = video.toData
    }
    
    /// 快速创建一个图片类型消息
    convenience init(image: UIImage? = nil) {
        self.init()
        self.msgType = .image
        
        self.data = image?.pngData()
    }
    
    /// 快速创建一个图片类型消息
    convenience init(imageName: String? = nil) {
        self.init()
        self.msgType = .image
        
        self.imageName = imageName
    }
    
    /// 快速创建一个时间戳消息
    convenience init(timeInterval: TimeInterval? = nil) {
        self.init()
        self.msgType = .time
        
        let realModel = MsgTimeModel()
        realModel.time = timeInterval ?? Date().timeIntervalSince1970
        
        self.data = realModel.toData
    }
    
    /// 快速创建一个文本消息
    /// - Parameter text: 文本消息体积
    convenience init(text: String) {
        self.init()
        self.text = text
        self.msgType = .text
        self.data = text.data(using: .utf8)
    }
    
    /// 快速创建一个语音消息
    /// - Parameter text: 文本消息体积
    convenience init(voice: MsgVoiceModel) {
        self.init()
        self.msgType = .voice
        self.data = voice.toData
    }
    
    /// 消息内容真实类型
    var contentClass: WXDetailContentProtocol.Type {
        switch msgType {
        case .text:
            return CellContentText.self
        case .voice:
            return CellContentVoice.self
        case .image:
            return CellContentPhoto.self
        case .video:
            return CellContentVideo.self
        case .voip:
            return CellContentVoip.self
        case .red_packet:
            return CellContentRedPacket.self
        case .money_transfer:
            return CellContentMoneyTransfer.self
        case .system:
            return CellContentSystemMsg.self
        case .link:
            return CellContentLink.self
        case .file:
            return CellContentFile.self
        case .idCard:
            return CellContentIDCard.self
        default:
            break
        }
        
        return CellContentTime.self
    }
    
    /// 是否是自己发出的消息
    var isOutGoingMsg: Bool {
        if from == WXUserInfo.shared.id {
            return true
        }
        
        return false
    }
    
    var image: UIImage? {
        if msgType == .image {
            if let imageName = imageName {
                return UIImage(named: imageName)
            }
            
            if let data = data {
                return UIImage(data: data)
            }
        }
        return nil
    }
}
