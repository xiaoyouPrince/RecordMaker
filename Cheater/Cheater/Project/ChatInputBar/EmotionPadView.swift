//
//  EmotionPadView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/15.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

class EmotionPadView: UIView {
    
    /// 所有表情
    let emotions = EmotionManager.shared.emotions
    private var callabck:((EmotionItem)->())?
    lazy var emotionViews = getEmotiionViews {[weak self] item in
        //print(item)
        self?.callabck?(item)
    }
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    init(_ callback: @escaping (EmotionItem)->(), deleteOrSend: @escaping(_ idx: Int)->()) {
        super.init(frame: .zero)
        backgroundColor = WXConfig.tableViewBgColor
        self.callabck = callback
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        XYTagsView.config.tagMargin = 15
        let view = XYTagsView(customView: emotionViews, maxWitdh: .width)
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width)
            make.height.equalTo(view.height)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
        
        if let last = contentView.subviews.last {
            contentView.snp.makeConstraints { make in
                make.height.equalTo(last)
                make.width.equalTo(CGFloat.width)
            }
        }
        
        // delete & sendBtn
        let sendBtn = UIButton(type: .system)
        addSubview(sendBtn)
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.setTitleColor(.C_FFFFFF, for: .normal)
        sendBtn.backgroundColor = WXConfig.wxGreen
        sendBtn.corner(radius: 5)
        sendBtn.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.bottom.equalToSuperview().offset(-CGFloat.safeBottom - 12)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        sendBtn.addTap { sender in
            deleteOrSend(1)
        }
        
        let deleteBtn = UIButton(type: .system)
        addSubview(deleteBtn)
        deleteBtn.setImage(.defaultHead, for: .normal)
        deleteBtn.backgroundColor = WXConfig.wxGreen
        deleteBtn.corner(radius: 5)
        deleteBtn.snp.makeConstraints { make in
            make.right.equalTo(sendBtn.snp.left).offset(-12)
            make.width.height.bottom.equalTo(sendBtn)
        }
        deleteBtn.addTap { sender in
            deleteOrSend(0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getEmotiionViews(_ callback:@escaping (EmotionItem)->()) -> [UIView] {
        var result = [UIView]()
        for emotion in emotions {
            let iconBtn = UIButton(type: .system)
            iconBtn.setImage(UIImage(named: emotion.imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
            iconBtn.bounds.size = .init(width: 35, height: 35)
            result.append(iconBtn)
            
            iconBtn.addTap { sender in
                callback(emotion)
            }
        }
        return result
    }
}
