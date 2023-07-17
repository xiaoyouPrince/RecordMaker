//
//  SendVoipCpntroller.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/17.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit
import XYInfomationSection

class SendVoipCpntroller: XYInfomationBaseViewController {

    var senderId: Int = WXUserInfo.shared.id
    var callback: ((MsgVoipModel)->())?
    var msgModel: WXDetailModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(senderId: Int, callback: @escaping (MsgVoipModel)->()) {
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
        title = isEdit ? "编辑视频" : "添加视频"
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(doneClick), title: isEdit ? "保存" : "添加")
        
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) { index, cell in
            
            if cell.model.title == "视频封面" {
                ChoosePhotoController.choosePhoto { image in
                    cell.model.obj = image.pngData() as Any
                    let model = cell.model
                    cell.model = model
                }
            }
            if cell.model.title == "通话类型" {
                XYPickerView.showPicker { picker in
                    picker.title = cell.model.title
                    picker.dataArray = [
                        .model(withDict: ["title":"视频通话","code":"0"]),
                        .model(withDict: ["title":"语音通话","code":"1"])
                    ]
                } result: { chooseItem in
                    cell.model.value = chooseItem.title
                    cell.model.valueCode = chooseItem.code
                    cell.model = cell.model
                }
            }
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


extension SendVoipCpntroller {
    
    func voipModel() -> MsgVoipModel? {
        if isEdit {
            return msgModel!.data!.toModel()
        }
        return nil
    }
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        let from = WXUserInfo.shared.id
        var title = WXUserInfo.shared.name
        var imageData = WXUserInfo.shared.icon?.pngData()
        if self.senderId != from {
            title = DataSource_wxDetail.targetContact?.title
            imageData = DataSource_wxDetail.targetContact?.image?.pngData()
        }
        
        var typeString = "视频通话"
        if (voipModel()?.voipType == 1) {
            typeString = "语音通话"
        }
        
        let section: [[String: Any]] = [
            [
                "title": title ?? "",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": SenderCell.self,
                "obj": imageData as Any
            ],
            [
                "title": "通话时长",
                "titleKey": "videoTime",
                "type": XYInfoCellType.input.rawValue,
                "value": voipModel()?.voipTime as Any,
                "placeholderValue": "时间用英文“:”分隔"
            ],
            [
                "title": "是否取消",
                "titleKey": "isCancel",
                "type": XYInfoCellType.switch.rawValue,
                "isOn": voipModel()?.isCancel as Any,
            ],
            [
                "title": "通话类型",
                "titleKey": "voipType",
                "type": XYInfoCellType.choose.rawValue,
                "value": typeString,
                "valueCode": typeString == "视频通话" ? "0" : "1"
            ]
        ]
        
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
        
        let voipModel = MsgVoipModel()
        voipModel.voipTime = params["videoTime"] as? String
        voipModel.isCancel = (params["isCancel"] as? String) == "1" ? true : false
        voipModel.voipType = (params["voipType"] as? String)?.intValue
        
        callback?(voipModel)
        if isEdit {
            msgModel?.data = voipModel.toData
        }
        navigationController?.popViewController(animated: true)
    }
}
