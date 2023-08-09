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
        case voip = "视频通话"
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
        case .voip:
            let titles = ["添加语音/视频通话记录", "取消视频通话", "取消语音通话", "拒绝视频通话", "拒绝语音通话"]
            XYAlertSheetController.showDefault(on: forVC, title: "操作类型", subTitle: nil, actions: titles) { index in
                if index == -1 { return }
                
                if index == 0 { // 手动配置页面
                    forVC.push(SendVoipCpntroller.init(senderId: forVC.currentSenderID) { voipModel in
                        let model = WXDetailModel(voip: voipModel)
                        model.from = forVC.currentSenderID
                        forVC.dataArrayAppendMsg(model)
                    }, animated: true)
                } else {
                    let voipModel = MsgVoipModel()
                    voipModel.isCancel = false
                    voipModel.isRefuse = false
                    if index == 1 {
                        voipModel.isCancel = true
                        voipModel.voipType = 0
                    }else if index == 2 {
                        voipModel.isCancel = true
                        voipModel.voipType = 1
                    }else if index == 3 {
                        voipModel.isRefuse = true
                        voipModel.voipType = 0
                    }else if index == 4 {
                        voipModel.isRefuse = true
                        voipModel.voipType = 1
                    }
                    let msgModel = WXDetailModel(voip: voipModel)
                    msgModel.from = forVC.currentSenderID
                    forVC.dataArrayAppendMsg(msgModel)
                }
            }
        case .red_packet:
            let vc = SendRedpacketViewController()
            forVC.push(vc, animated: true)
            vc.callback = { msgRedPacketModel in
                let msgModel = WXDetailModel(redPacket: msgRedPacketModel)
                msgModel.from = forVC.currentSenderID
                forVC.dataArrayAppendMsg(msgModel)
            }
        case .monery_transfer:
            let vc = SendMoneyTransfertViewController()
            forVC.push(vc, animated: true)
            vc.callback = { msgMoneyTransferModel in
                let msgModel = WXDetailModel(moneyTransfer: msgMoneyTransferModel)
                msgModel.from = forVC.currentSenderID
                forVC.dataArrayAppendMsg(msgModel)
            }
        case .system_noti:
            let vc = SendSystemMsgController()
            forVC.push(vc, animated: true)
            vc.callback = { sysmsgModel in
                let msgModel = WXDetailModel(systemMsg: sysmsgModel)
                msgModel.from = forVC.currentSenderID
                forVC.dataArrayAppendMsg(msgModel)
            }
        case .add_time:
            let vc = SendTimeController()
            forVC.push(vc, animated: true)
            vc.callback = { timeInterval in
                let msgModel = WXDetailModel(timeInterval: timeInterval)
                msgModel.from = forVC.currentSenderID
                forVC.dataArrayAppendMsg(msgModel)
            }
        case .change_user:
            forVC.changeUser()
        case .link:
            let vc = SendLinkController()
            vc.msgTitle = action?.rawValue ?? ""
            forVC.push(vc, animated: true)
            vc.callback = { link in
                let msgModel = WXDetailModel(link: link)
                msgModel.from = forVC.currentSenderID
                forVC.dataArrayAppendMsg(msgModel)
            }
        case .file:
            let vc = SendFileController()
            vc.msgTitle = action?.rawValue ?? ""
            forVC.push(vc, animated: true)
            vc.callback = { file in
                let msgModel = WXDetailModel(file: file)
                msgModel.from = forVC.currentSenderID
                forVC.dataArrayAppendMsg(msgModel)
            }
        default:
            Toast.make("一个一个实现")
        }
    }
}

