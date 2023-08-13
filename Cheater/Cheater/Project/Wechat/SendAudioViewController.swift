//
//  SendAudioViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/13.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 输入框发送语音按钮点击后,添加语音功能
 *
 *  1. 发送语音
 *  2. 发送语音编辑页面
 */

import UIKit
import XYUIKit
import XYInfomationSection

class SendAudioViewController: BaseSendMsgController {
    var callback: ((MsgVoiceModel)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            
        }
    }
}

extension SendAudioViewController {
    
    func voiceModel() -> MsgVoiceModel? {
        if isEdit {
            return msgModel!.data!.toModel()
        }
        return nil
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
//        var voiceTime: Int = 0
//        var showText: Bool = false
//        var textContent: String = ""
//        var hasRead: Bool = false
        
        var section: [[String: Any]] = [
            [
                "title": "语音时间(最大60秒)",
                "titleKey": "voiceTime",
                "type": XYInfoCellType.input.rawValue,
                "placeholderValue": "请输入时长",
                "value": voiceModel()?.voiceTime?.toString as Any
            ],
            [
                "title": "显示转文字",
                "titleKey": "showText",
                "type": XYInfoCellType.switch.rawValue,
                "isOn": voiceModel()?.showText as Any
            ],
            [
                "title": "语音转文字内容",
                "titleKey": "textContent",
                "type": XYInfoCellType.textView.rawValue,
                "cellHeight": 100,
                "value": voiceModel()?.textContent as Any
            ]
        ]
        
        if !isMsgBelongsToMe { // 不是我发的
            let hasRead: [String : Any] = [
                "title": "是否已读",
                "titleKey": "hasRead",
                "type": XYInfoCellType.switch.rawValue,
                "isOn": voiceModel()?.hasRead as Any
            ]
            section.append(hasRead)
        }
        
        result.append(section)
        return result
    }
    
    @objc override func doneClick() {
        let params = totalParams
        let voiceModel = MsgVoiceModel()
        voiceModel.voiceTime = (params["voiceTime"] as? String)?.intValue
        voiceModel.showText = (params["showText"] as? String) == "1" ? true : false
        voiceModel.textContent = params["textContent"] as? String
        voiceModel.hasRead = (params["hasRead"] as? String) == "1" ? true : false
        
        callback?(voiceModel)
        if isEdit {
            msgModel?.updateContent(voiceModel)
        }
        
        super.doneClick()
    }
}

class SenderCell: XYInfomationCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.corner(radius: 5)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model: XYInfomationItem{
        didSet {
            guard let obj = model.obj as? Data else { return }
            imageView.image = UIImage(data: obj)
            titleLabel.text = model.title
        }
    }
}
