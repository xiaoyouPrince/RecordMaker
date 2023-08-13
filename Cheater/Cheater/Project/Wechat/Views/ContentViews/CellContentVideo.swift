//
//  CellContentVideo.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/16.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

/// 时间戳数据模型
class MsgVideoModel: WXDetailContentModelProtocol {
    /// 视频封面
    var imageData: Data?
    /// 视频时长 egg: 10:20
    var videoTime: String?
}


class CellContentVideo: UIView {
    let contentView = UIView()
    let imageView = UIImageView()
    let playIcon = UIImageView()
    let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(playIcon)
        contentView.addSubview(timeLabel)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.contentMode = .center
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        playIcon.image = UIImage(named: "play_video_icon2")
        playIcon.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
        
        timeLabel.textColor = .C_FFFFFF
        timeLabel.snp.makeConstraints { make in
            make.right.equalTo(imageView.snp.right).offset(-10)
            make.bottom.equalTo(imageView.snp.bottom).offset(-10)
        }
    }
}

extension CellContentVideo: WXDetailContentProtocol {
    var contentClass: UIView.Type {
        CellContentPhoto.self
    }
    
    var showIconImage: Bool { true }
    var showNamelable: Bool { false }
    var showReadLabel: Bool { false }
    
    func setModel(_ model: WXDetailModel) {
        guard let videoModel: MsgVideoModel = model.data?.toModel(),
              let imageData = videoModel.imageData,
              let image = UIImage(data: imageData) else { return } // 图片累类型,必须有图片
        
        let size = image.size
        let maxWH: CGFloat = 150
        var imageSize: CGSize = .init(width: maxWH, height: maxWH)
        
        if size.width / size.height > 1 { // 宽图片
            if size.width > maxWH { // 压缩宽度
                let scale = image.size.width / maxWH
                let scaleHeight = image.size.height / scale
                imageSize.width = maxWH
                imageSize.height = scaleHeight
            }
        } else { // 窄图片
            if size.height > maxWH { // 压缩高度
                let scale = image.size.height / maxWH
                let scaleWidth = image.size.width / scale
                imageSize.width = scaleWidth
                imageSize.height = maxWH
            }
        }
        
        imageView.corner(radius: 5)
        imageView.image = image
        imageView.snp.remakeConstraints { make in
            if model.isOutGoingMsg {
                make.right.equalToSuperview()
            }else{
                make.left.equalToSuperview()
            }
            
            make.width.equalTo(imageSize.width)
            make.height.equalTo(imageSize.height)
            make.top.bottom.equalToSuperview()
        }
        
        timeLabel.text = videoModel.videoTime
    }
}

