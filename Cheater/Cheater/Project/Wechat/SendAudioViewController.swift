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
 * <#这里输入你要做的事情的一些思路#>
 *  <#1. ...#>
 *  <#2. ...#>
 */

import UIKit
import XYUIKit
import XYInfomationSection

class SendAudioViewController: XYInfomationBaseViewController {
    var senderId: Int = WXUserInfo.shared.id
    var callback: ((MsgVoiceModel)->())?
    var msgModel: WXDetailModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(senderId: Int, callback: @escaping (MsgVoiceModel)->()) {
        self.senderId = senderId
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    init(msgModel: WXDetailModel) {
        super.init(nibName: nil, bundle: nil)
        self.msgModel = msgModel
        self.senderId = msgModel.from ?? 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        
    }
    
    /// 是否是编辑
    var isEdit: Bool { msgModel != nil }
    
    func buildUI() {
        
        self.view.backgroundColor = WXConfig.navBarBgColor
        
        nav_setCustom(backImage: WXConfig.wx_backImag)
        title = isEdit ? "编辑语音" : "添加语音"
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(doneClick), title: isEdit ? "保存" : "添加")
        
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            
        }
        
        let button = UIButton(type: .system)
        button.setTitle(isEdit ? "保存" : "添加", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = WXConfig.wxGreen
        button.corner(radius: 5)
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        button.addTap { [weak self] sender in
            guard let self = self else { return }
            self.doneClick()
        }
        setFooterView(button, edgeInsets: .init(top: 20, left: 10, bottom: 0, right: 10))
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
        
        var from = WXUserInfo.shared.id
        var title = WXUserInfo.shared.name
        var imageData = WXUserInfo.shared.icon?.pngData()
        if self.senderId != from {
            title = DataSource_wxDetail.targetContact?.title
            imageData = DataSource_wxDetail.targetContact?.image?.pngData()
        }
        
//        var voiceTime: Int = 0
//        var showText: Bool = false
//        var textContent: String = ""
//        var hasRead: Bool = false
        
        var section: [[String: Any]] = [
            [
                "title": title ?? "",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": SenderCell.self,
                "obj": imageData as Any
            ],
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
        
        if self.senderId != from {
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
    
    @objc func doneClick() {
        var params: [AnyHashable: Any] = [:]
        self.view.findSubViewRecursion { subview in
            if let section = subview as? XYInfomationSection {
                params = section.contentKeyValues
                return true
            }
            return false
        }
        
        let voiceModel = MsgVoiceModel()
        voiceModel.voiceTime = (params["voiceTime"] as? String)?.intValue
        voiceModel.showText = (params["showText"] as? String) == "1" ? true : false
        voiceModel.textContent = params["textContent"] as? String
        voiceModel.hasRead = (params["hasRead"] as? String) == "1" ? true : false
        
        callback?(voiceModel)
        if isEdit {
            msgModel?.data = voiceModel.toData
        }
        navigationController?.popViewController(animated: true)
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
