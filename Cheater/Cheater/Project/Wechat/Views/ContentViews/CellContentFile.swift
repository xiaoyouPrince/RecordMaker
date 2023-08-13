//
//  CellContentFile.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 微信消息,文件类型
 * 连接消息
 */

import UIKit

class MsgModelFile: WXDetailContentModelProtocol {
    /// 文件类型
    var type: String?
    /// 文件标题
    var title: String?
    /// 大小
    var size: String?
    /// 文件大小单位 - B / KB / MB
    var sizeType: String?
    /// 是否是电脑版
    var pcVersion: Bool?
}

extension MsgModelFile {
    /// 文件字典
    static var iconDict: [[String: String]] {[
        ["word文档": "chat-file-icon2"],
        ["excel文档": "chat-file-icon1"],
        ["pdf文档": "chat-file-icon3"],
        ["ppt文档": "chat-file-icon4"],
        ["音乐文件": "chat-file-icon5"],
        ["txt文档": "chat-file-icon7"],
        ["其他文件": "chat-file-icon6"],
        ["zip文件": "chat-file-icon8"]
    ]}
    /// 文件大小类型字典
    static var sizeTypeDict: [[String: String]] {[
        ["B": "B"],
        ["KB": "KB"],
        ["MB": "MB"]
    ]}
    
    /// 返回完整的文件大小 egg: 25KB
    var subTitle: String {
        return (size ?? "") + (sizeType ?? "")
    }
    
    /// 返回文件icon
    var fileIcon: UIImage {
        let dict: [String: String] = [
            "word文档": "chat-file-icon2",
            "excel文档": "chat-file-icon1",
            "pdf文档": "chat-file-icon3",
            "ppt文档": "chat-file-icon4",
            "音乐文件": "chat-file-icon5",
            "txt文档": "chat-file-icon7",
            "其他文件": "chat-file-icon6",
            "zip文件": "chat-file-icon8"
        ]
        if let type = type, let imageName = dict[type], let icon = UIImage(named: imageName) {
            return icon
        }
        return UIImage()
    }
}

class CellContentFile: CellContentRedPacket {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBubbleTintColor(.white)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setModel(_ model: WXDetailModel) {
        bubbleView.addSubview(line)
        bubbleView.addSubview(appIcon)
        bubbleView.addSubview(bottomLabel)
        super.setModel(model)
        
        guard let data = model.data, let subModel: MsgModelFile = data.toModel() else { return }
        setData(data: subModel, isOutMsg: model.isOutGoingMsg)
    }
}

extension CellContentFile {
    
    func setData(data: MsgModelFile, isOutMsg: Bool) {
        
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
        iconView.image = data.fileIcon
        
        relayoutSubview(isOutMsg)
        
        // deal with pc_version
        if data.pcVersion == true { // 展示 pc 版本
            bottomLabel.textColor = .C_wx_tip_text
            line.backgroundColor = .line
            appIcon.image = UIImage(named: "file-bottom-icon")
            bottomLabel.text = "微信电脑版"
            
            line.snp.remakeConstraints { make in
                make.left.equalTo(10)
                make.right.equalTo(-15)
                make.height.equalTo(CGFloat.line)
                make.top.greaterThanOrEqualTo(iconView.snp.bottom).offset(10)
                make.top.greaterThanOrEqualTo(subTitleLabel.snp.bottom).offset(10)
            }
            
            appIcon.snp.remakeConstraints { make in
                make.width.height.equalTo(10)
                make.left.equalTo(line)
                make.centerY.equalTo(bottomLabel)
            }
            
            bottomLabel.snp.remakeConstraints { make in
                make.left.equalTo(appIcon.snp.right).offset(5)
                make.right.equalTo(-15)
                make.top.equalTo(line.snp.bottom).offset(3)
                make.bottom.equalToSuperview().offset(-3)
                make.height.equalTo(15)
            }
            
        }else{
            
            [line, appIcon, bottomLabel].forEach { subView in
                subView.removeFromSuperview()
            }
            
            subTitleLabel.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel)
                make.right.equalTo(iconView.snp.left).offset(-10)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.bottom.lessThanOrEqualTo(-10)
            }
        }
    }
    
    func relayoutSubview(_ isOutMsg: Bool) {
        // title
        // desc
        // fileIcon
        // appIcon
        // appName
        titleLabel.numberOfLines = 2
        subTitleLabel.numberOfLines = 1
        subTitleLabel.textColor = .C_wx_tip_text
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        if isOutMsg {
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(10)
                make.top.equalTo(13)
                make.right.equalTo(iconView.snp.left).offset(-8)
            }
            
            iconView.snp.remakeConstraints { make in
                make.right.equalTo(-15)
                make.top.equalTo(10)
                make.width.equalTo(40)
                make.height.equalTo(50)
                make.bottom.lessThanOrEqualTo(-10)
            }
            
            subTitleLabel.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel)
                make.right.equalTo(iconView.snp.left).offset(-8)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
            }
        }else{
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(15)
                make.top.equalTo(13)
                make.right.equalTo(iconView.snp.left).offset(-8)
            }
            
            iconView.snp.remakeConstraints { make in
                make.right.equalTo(-10)
                make.top.equalTo(10)
                make.width.equalTo(40)
                make.height.equalTo(50)
                make.bottom.lessThanOrEqualTo(-10)
            }
            
            subTitleLabel.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel)
                make.right.equalTo(iconView.snp.left).offset(-8)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
            }
        }
    }
}

