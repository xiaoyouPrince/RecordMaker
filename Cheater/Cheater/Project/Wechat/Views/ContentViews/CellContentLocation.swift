//
//  CellContentLocation.swift
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

class MsgModelLocation: WXDetailContentModelProtocol {
    
//    {
//        cityname = "\U5317\U4eac\U5e02";
//        latlng =     {
//            lat = "39.90469";
//            lng = "116.40717";
//        };
//        mapImage = "https://apis.map.qq.com/ws/staticmap/v2/?center=39.90469,116.40717&zoom=15&size=600*200&maptype=roadmap&key=4UGBZ-62SWP-HJRDU-V6Q4W-HS4XQ-5EFKG&scale=2";
//        module = locationPicker;
//        poiaddress = "\U5317\U4eac\U5e02";
//        poiname = "\U6211\U7684\U4f4d\U7f6e";
//    }

    /// 地址名
    var poiname: String?
    /// 详细地址
    var poiaddress: String?
    /// 图片地址
    var mapImage: String?
    /// 纬度
    var lat: String?
    /// 经度
    var lng: String?
    
    /// 存储已经加载过的图片
    var imageData: Data?
    
    init(dict: [String: Any]) {
        poiname = dict["poiname"] as? String
        poiaddress = dict["poiaddress"] as? String
        mapImage = dict["mapImage"] as? String
        let latlng = dict["latlng"] as? [String: Any] ?? [:]
        lat = latlng["lat"] as? String
        lng = latlng["lng"] as? String
        
        imageData = icon.pngData()
    }
}

extension MsgModelLocation {
    
    func getMapImage(_ callback:@escaping (UIImage)->()) {
        if let imageData = imageData {
            callback(UIImage(data: imageData)!)
            return
        }
        
        DispatchQueue.global().async {
            let image = self.icon
            self.imageData = image.pngData()
            DispatchQueue.main.async {
                callback(image)
            }
        }
    }
    
    /// 耗时操作,需要在子线程操作
    private var icon: UIImage {
        if mapImage == nil {
            return .defaultHead ?? UIImage()
        }
        
        let data = try? Data(contentsOf: URL(string: mapImage!)!)
        let image = UIImage(data: data ?? Data()) ?? UIImage()
        
        /*
         图片由于本身带有腾讯地图商标,这里处理一下移除掉.
         但是实际上使用了一个取巧的方法,就是在获取图片的时候 宽高比改大(5:1),这样
         加载图片的时候直接就被 fit 掉了.
        */
        
        return image
    }
}

class CellContentLocation: CellContentRedPacket {
    
    let tencentMark = UIImageView(image: UIImage(named: "tencent_map_mark"))
    let tipImageView = UIImageView(image: UIImage(named: "chat-map-icon1"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBubbleTintColor(.white)
        iconView.addSubview(tencentMark)
        iconView.addSubview(tipImageView)
        
        tipImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(0)
            make.width.equalTo(20)
            make.height.equalTo(32)
        }
        
        tencentMark.snp.makeConstraints { make in
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
            make.width.equalTo(55)
            make.height.equalTo(15)
        }
        
        iconView.corner(radius: 8, markedCorner: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setModel(_ model: WXDetailModel) {
        bubbleView.addSubview(line)
        bubbleView.addSubview(appIcon)
        bubbleView.addSubview(bottomLabel)
        super.setModel(model)
        
        guard let data = model.data, let subModel: MsgModelLocation = data.toModel() else { return }
        setData(data: subModel, isOutMsg: model.isOutGoingMsg)
    }
}

extension CellContentLocation {
    
    func setData(data: MsgModelLocation, isOutMsg: Bool) {
        // base properties
        bottomLabel.textColor = .C_wx_tip_text
        bottomLabel.text = nil
        line.backgroundColor = .line
        titleLabel.numberOfLines = 1
        subTitleLabel.numberOfLines = 1
        subTitleLabel.textColor = .C_wx_tip_text
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        
        // content
        titleLabel.text = data.poiname
        subTitleLabel.text = data.poiaddress
        data.getMapImage({[weak self] image in
            self?.iconView.image = image
        })
        
        // layout
        relayoutSubview(isOutMsg)
    }
    
    func relayoutSubview(_ isOutMsg: Bool) {
        
        [line, appIcon, bottomLabel].forEach { subv in
            subv.snp.removeConstraints()
        }
        
        // title
        // desc
        // fileIcon
        // appName
        if isOutMsg {
            titleLabel.snp.remakeConstraints { make in
                make.left.top.equalTo(10)
                make.right.equalTo(-15)
                make.height.equalTo(16)
            }
            
            subTitleLabel.snp.remakeConstraints { make in
                make.left.right.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.height.equalTo(13)
            }
            
            iconView.snp.remakeConstraints { make in
                make.top.equalTo(subTitleLabel.snp.bottom).offset(8)
                make.left.bottom.equalToSuperview()
                make.right.equalToSuperview().offset(-5)
                make.height.equalTo(100)
            }
        }else{
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(15)
                make.top.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(16)
            }
            
            subTitleLabel.snp.remakeConstraints { make in
                make.left.right.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.height.equalTo(13)
            }
            
            iconView.snp.remakeConstraints { make in
                make.top.equalTo(subTitleLabel.snp.bottom).offset(8)
                make.right.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(5)
                make.height.equalTo(100)
            }

        }
    }
}

