//
//  MTSuccessViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/22.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 转账成功页面
 */

import UIKit
import XYInfomationSection
import XYUIKit

class MTSuccessViewController: XYInfomationBaseViewController {
    
    private var icon: PaySuccessView = .shared
    private var titleLabel: UILabel = .init()
    private var moneyView: MoneyView = .init(with: "")
    
    var mtModel: MTModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        buildUI()
        setData()
    }
    
    func buildUI() {
        
        // icon
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(CGFloat.naviBar)
            make.centerX.equalToSuperview()
        }
        
        // titleLabel
        titleLabel = UILabel(title: "XYInfomationSection", font: .systemFont(ofSize: 15), textColor: .C_000000, textAlignment: .center)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
        
        // moneyView
        moneyView = MoneyView(with: "100")
        view.addSubview(moneyView)
        moneyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        // okBtn
        let okBtn = UIButton(type: .system)
        okBtn.setTitle("完成", for: .normal)
        view.addSubview(okBtn)
        okBtn.corner(radius: 5)
        okBtn.backgroundColor = .C_wx_keyboard_bgcolor
        okBtn.setTitleColor(WXConfig.wxGreen, for: .normal)
        okBtn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        okBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(220)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-CGFloat.naviBar-CGFloat.safeBottom)
        }
        
        okBtn.addTap {[weak self] sender in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setData() {
        guard let mtModel = mtModel else { return }
        
        titleLabel.text = "待" + (mtModel.name ?? "") + "确认收款"
        moneyView.moneyStr = mtModel.moneyAmount ?? "0.00"
    }

}
