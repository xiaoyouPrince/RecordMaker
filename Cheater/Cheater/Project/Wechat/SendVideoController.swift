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

class SendVideoController: BaseSendMsgController {
    var callback: ((MsgVideoModel)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let section: [[String: Any]] = [
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
    
    @objc override func doneClick() {
        let params = totalParams
        let items = totalModels
        
        let videoModel = MsgVideoModel()
        videoModel.videoTime = params["videoTime"] as? String
        for item in items {
            if item.title == "视频封面" {
                videoModel.imageData = item.obj as? Data
            }
        }
        
        callback?(videoModel)
        if isEdit {
            msgModel?.updateContent(videoModel)
        }
        
        super.doneClick()
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

