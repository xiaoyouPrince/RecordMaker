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
    
    /// 封面图片
    var image: UIImage {
        var result: UIImage?
        if let data = imageData {
            result = UIImage(data: data)
        }
        return result ?? UIImage()
    }
}

class CellContentVideo: CellContentPhoto {
    let playIcon = UIImageView()
    let timeLabel = UILabel()
    
    override func setupUI() {
        super.setupUI()
        contentView.addSubview(playIcon)
        contentView.addSubview(timeLabel)

        playIcon.image = UIImage(named: "play_video_icon2")
        playIcon.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
        if let image = playIcon.image {
            playIcon.corner(radius: image.size.width/2)
            playIcon.border(color: .white, width: 1)
        }

        timeLabel.textColor = .C_FFFFFF
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.snp.makeConstraints { make in
            make.right.equalTo(imageView.snp.right).offset(-8)
            make.bottom.equalTo(imageView.snp.bottom).offset(-6)
        }
    }
    
    override func setModel(_ model: WXDetailModel) {
        guard let data = model.data, let subModel: MsgVideoModel = data.toModel() else { return }
        setContent(image: subModel.image, isOutGoingMsg: model.isOutGoingMsg)
        timeLabel.text = subModel.videoTime
    }
}

