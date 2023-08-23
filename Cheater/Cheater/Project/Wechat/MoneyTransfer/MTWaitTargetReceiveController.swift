//
//  MTWaitTargetReceiveController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/22.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 等对方确认收款页面
 *
 */


import UIKit

class MTWaitTargetReceiveController: MTBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        updateUI()
        
        view.addTap {[weak self] sender in
            guard let self = self, let mtModel = self.mtModel else { return }
            
            let detail = EditMoneyTransferController2()
            self.push(detail, animated: true)
            detail.setModel(model: mtModel) {[weak self] mtModel in
                guard let self = self else { return }
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        updateIcon(img: UIImage(named: "scan_blue_info") ?? .init())
        updateStatusLabel(text: "待\(mtModel?.name ?? "")确认收款")
        updateMoney(amount: mtModel?.moneyAmount ?? "")
        
        let attrStr = "一天内对方未收款,将退还给你.提醒对方收款".addAttributes(attrs: [.foregroundColor: UIColor.C_wx_link_text, .font: UIFont.boldSystemFont(ofSize: 14)], withRegx: "提醒对方收款")
        
        updateTipsLabel(attrStr: attrStr)
        updateSection()
    }
    
    override func updateSection() {
        print("dd")
    }
}

