//
//  SendVideoController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/17.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 发送视频编辑页面
 *
 *  1. 发送视频
 *  2. 编辑已经发送的视频
 */

import UIKit
import XYUIKit
import XYInfomationSection

class SendVideoController: XYInfomationBaseViewController {

    var senderId: Int = WXUserInfo.shared.id
    var callback: ((MsgVideoModel)->())?
    var msgModel: WXDetailModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(senderId: Int, callback: @escaping (MsgVideoModel)->()) {
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

extension SendVideoController {
    
    func videoModel() -> MsgVideoModel? {
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
        
        let section: [[String: Any]] = [
            [
                "title": title ?? "",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": SenderCell.self,
                "obj": imageData as Any
            ],
            [
                "title": "视频封面",
                "titleKey": "videoPhoto",
                "type": XYInfoCellType.other.rawValue,
                "customCellClass": ChoosePhotoCell.self,
                "obj": videoModel()?.imageData as Any
            ],
            [
                "title": "视频时长",
                "titleKey": "videoTime",
                "type": XYInfoCellType.input.rawValue,
                "value": videoModel()?.videoTime as Any,
                "placeholderValue": "时间用英文“:”分隔"
            ]
        ]
        
        result.append(section)
        return result
    }
    
    @objc func doneClick() {
        let videoModel = MsgVideoModel()
        var params: [AnyHashable: Any] = [:]
        self.view.findSubViewRecursion { subview in
            if let section = subview as? XYInfomationSection {
                params = section.contentKeyValues
                
                let item = section.dataArray[1]
                videoModel.imageData = item.obj as? Data
                return true
            }
            return false
        }
        
        videoModel.videoTime = params["videoTime"] as? String
        
        callback?(videoModel)
        if isEdit {
            msgModel?.data = videoModel.toData
        }
        navigationController?.popViewController(animated: true)
    }
}

class ChoosePhotoCell: XYInfomationCell {
    
    let titleLabel = UILabel()
    let imageView = UIImageView(image: .defaultHead)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(imageView)
        
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model: XYInfomationItem {
        didSet{
            if let imageData = model.obj as? Data {
                imageView.image = UIImage(data: imageData)
            }
            titleLabel.text = model.title
        }
    }
}

