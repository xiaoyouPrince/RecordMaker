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
    
}

class CellContentMoneyTransfer: CellContentRedPacket {
    override func setModel(_ model: WXDetailModel) {
        super.setModel(model)
    }
}

extension CellContentMoneyTransfer {
    
    func setData(data: MsgMoneyTransferModel, isOutMsg: Bool) {
        
    }
}



