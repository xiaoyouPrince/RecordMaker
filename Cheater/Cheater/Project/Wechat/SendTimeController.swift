//
//  SendTimeController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/8.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 自定义一个发送时间控制器
 *
 * 选择时间发送
 * 自定义发送一个系统消息
 */

import UIKit
import XYUIKit
import XYInfomationSection

class SendTimeController: XYInfomationBaseViewController {
    
    var callback: ((TimeInterval)->())?
    var msgModel: WXDetailModel?
    var senderId: Int = WXUserInfo.shared.id
    private var chooseTimeInterval: TimeInterval = .since1970

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navVCs = navigationController?.viewControllers ?? []
        if let msgVC: WXDetailViewController = navVCs.dropLast().last as? WXDetailViewController {
            senderId = msgVC.currentSenderID
        }
        
        buildUI()
    }
    
    func buildUI() {
        
        self.view.backgroundColor = WXConfig.navBarBgColor
        
        nav_setCustom(backImage: WXConfig.wx_backImag)
        title = isEdit ? "编辑时间" : "添加系统时间"
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(doneClick), title: isEdit ? "保存" : "添加")
        
        refreshContentUI()
        
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
    
    func refreshContentUI(_ content: String? = nil) {
        setContentWithData(contentData(content), itemConfig: { item in
            item.titleWidthRate = 0.5
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) {[weak self] index, cell in
            guard let self = self else { return }
            
            if cell.model.titleKey == "chooseTime" {
                DatePickerController.chooseDate { timeInterval in
                    if timeInterval == -1 { return }
                    
                    let model = cell.model
                    model.value = TimeTool.timeString(from: timeInterval)
                    cell.model = model
                    self.chooseTimeInterval = timeInterval
                }
            }
        }
    }

}

extension SendTimeController {
    
    var isEdit: Bool {  msgModel != nil }
    var isMeSpeaking: Bool {
        let from = WXUserInfo.shared.id
        return senderId == from
    }
    
    /// 当前发言者的 title 和 头像icon
    var speakerTitleIcon: (String, Data) {
        if !isMeSpeaking {
            return targetTitleIcon
        }
        
        let title = WXUserInfo.shared.name
        let imageData = WXUserInfo.shared.icon?.pngData()
        return (title ?? "", imageData ?? Data())
    }
    /// 当前会话对端用户 title 和 头像icon
    var targetTitleIcon: (String, Data) {
        let title = DataSource_wxDetail.targetContact?.title
        let imageData = DataSource_wxDetail.targetContact?.image?.pngData()
        return (title ?? "", imageData ?? Data())
    }
    
    func contentData(_ content: String? = nil) -> [Any] {
        var result = [Any]()
        
        let title = speakerTitleIcon.0
        let imageData = speakerTitleIcon.1
        
        let section: [[String: Any]] = [
            [
                "title": title,
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": SenderCell.self,
                "obj": imageData as Any
            ],
            [
                "title": "选择时间",
                "titleKey": "chooseTime",
                "type": XYInfoCellType.choose.rawValue,
                "value": content ?? ""
            ]
        ]
        
        result.append(section)
        return result
    }
    
    @objc func doneClick(){
        var params: [AnyHashable: Any] = [:]
        self.view.findSubViewRecursion { subview in
            if let section = subview as? XYInfomationSection {
                params = section.contentKeyValues
                return true
            }
            return false
        }
        let timeString = params["chooseTime"] as? String ?? ""
        if timeString.isEmpty {
            Toast.make("需要先选时间")
        }
        
        callback?(self.chooseTimeInterval)
        if isEdit {
            //msgModel?.data = systemModel.toData
        }
        navigationController?.popViewController(animated: true)
    }
}

