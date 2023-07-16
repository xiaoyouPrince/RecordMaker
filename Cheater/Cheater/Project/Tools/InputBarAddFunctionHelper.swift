//
//  InputBarAddFunctionHelper.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/14.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import Foundation
import XYUIKit
import XYAlbum

class InputBarAddFunctionHelper: UIViewController {
    
    enum ActionName: String {
        case photo = "照片"
        case red_packet = "红包"
        case take_photo = "拍摄"
        case monery_transfer = "转账"
        case video = "视频通话"
        case voice = "语音输入"
        case location = "位置"
        case my_fav = "收藏"
        case system_noti = "添加系统消息"
        case file = "文件"
        case add_time = "添加时间"
        case profile = "个人名片"
        case change_user = "切换用户"
        case cards = "卡券"
        case link = "链接"
    }
    
    static var shared: InputBarAddFunctionHelper = InputBarAddFunctionHelper()
    weak var detailVC: WXDetailViewController?
    
    /// 处理详情的加号事件
    /// - Parameters:
    ///   - name: 事件名称
    ///   - forVC: 控制器
    static func dealAction(with name: String, forVC: WXDetailViewController) {
        Toast.make(name)
        shared.detailVC = forVC
        
        let action = ActionName.init(rawValue: name)
        switch action {
        case .photo:
            ChoosePhotoController.choosePhoto { image in
                // Toast.make("拿到图片")
                let model = WXDetailModel(image: image)
                model.from = forVC.currentSenderID
                forVC.dataArrayAppendMsg(model)
            }
        case .voice:
            let sendAudioVC = SendAudioViewController(senderId: forVC.currentSenderID) { voiceModel in
                let model = WXDetailModel(voice: voiceModel)
                model.from = forVC.currentSenderID
                forVC.dataArrayAppendMsg(model)
            }
            forVC.push(sendAudioVC, animated: true)
        case .take_photo:
            let sendAudioVC = SendVideoController(senderId: forVC.currentSenderID, callback: { videoModel in
                let model = WXDetailModel(video: videoModel)
                model.from = forVC.currentSenderID
                forVC.dataArrayAppendMsg(model)
            })
            forVC.push(sendAudioVC, animated: true)
        default:
            Toast.make("一个一个实现")
        }
    }
}

