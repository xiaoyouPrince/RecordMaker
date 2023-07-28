//
//  CellContentMoneyTransfer.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/17.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit

/// 转账数据模型 - 此 UI 和 数据模型与红包高度重用
class MsgMoneyTransferModel: MsgRedPacketModel {
    /// 转账说明
    var transferInstructions: String?
}

class CellContentMoneyTransfer: CellContentRedPacket {
    override func setModel(_ model: WXDetailModel) {
        super.setModel(model)
        bottomLabel.text = "微信转账"
        
        guard let data = model.data, let subModel:MsgMoneyTransferModel = data.toModel() else { return }
        setData(data: subModel, isOutMsg: model.isOutGoingMsg)
    }
}

extension CellContentMoneyTransfer {
    
    func setData(data: MsgMoneyTransferModel, isOutMsg: Bool) {
        titleLabel.text = data.amountOfMoney
        
        if data.isHandled == true {
            // 已被接收
            iconView.image = UIImage(named: "wechat_zhuanzhangYes")
        }else{
            // 请收款
            iconView.image = UIImage(named: "wechat_zhuanzhang")
        }
        
        if isOutMsg {
            
        }
    }
}



