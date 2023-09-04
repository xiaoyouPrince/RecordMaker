//
//  TimelineNavBar.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/9/4.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

class TimelineNavBar: UIView {
    private let contentView = UIView()
    private let backButton = UIImageView(image: .nav_back_write).boxView(left: 15, right: 15)
    private let titleLabel = UILabel(title: "", font: UIFont.boldSystemFont(ofSize: 18), textColor: .black, textAlignment: .center)
    private let rightButton = UIImageView(image: .nav_camera_white).boxView(left: 15, right: 15)
    
    typealias callBackAction = (()->())?
    private var leftCallBack: callBackAction
    private var rightCallBack: callBackAction
    
    init(backAction:  callBackAction, rightAction: callBackAction) {
        self.leftCallBack = backAction
        self.rightCallBack = rightAction
        super.init(frame: .zero)
        setupContent()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTitle(title: String, textColor: UIColor) {
        titleLabel.text = title
        titleLabel.textColor = textColor
    }

    private func setupContent() {
        tintColor = .white
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(CGFloat.naviHeight)
        }
        
        // left
        contentView.addSubview(backButton)
        backButton.addTap { sender in
            sender.viewController?.navigationController?.popViewController(animated: true)
        }
        backButton.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
        }
        backButton.view.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 10, height: 18))
        }
        
        // title
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        // right
        contentView.addSubview(rightButton)
        rightButton.addTap { sender in
            sender.viewController?.navigationController?.popViewController(animated: true)
        }
        rightButton.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
        }
        rightButton.view.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 16))
        }
    }
}

extension TimelineNavBar {
    
}
