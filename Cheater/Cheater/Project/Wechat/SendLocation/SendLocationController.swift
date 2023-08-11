//
//  SendLocationController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/10.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 发送定位VC
 

 */
import UIKit
import MapKit
import XYUIKit
import CoreLocation
import XYInfomationSection

//private struct MapUrls {
//    static let yijietu: URL = URL(string: "https://1jietu.com/map.html?platform=ios&system=ios")!
//    static let tencentApi: URL = URL(string: "https://apis.map.qq.com/ws/staticmap/v2/?center=39.904228,116.406467&zoom=15&size=600*200&maptype=roadmap&key=4UGBZ-62SWP-HJRDU-V6Q4W-HS4XQ-5EFKG&scale=2")!
//}

class SendLocationController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(rightBtnClick), title: "确定")
        setNavbarWechat()
        navigationController?.navigationBar.isTranslucent = false
        
        
        let webView = WebView()
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        let url = URL(string: "https://1jietu.com/map.html?platform=ios&system=ios")!
        webView.load(NSMutableURLRequest(url: url) as URLRequest)
        
        // header
        let sectionView = XYInfomationSection()
        let item1 = XYInfomationItem()
        item1.title = "位置地址"
        item1.titleKey = "add"
        item1.type = .input
        let item2 = XYInfomationItem()
        item2.title = "详细地址"
        item2.titleKey = "subAdd"
        item2.type = .input
        sectionView.dataArray = [item1, item2]
        view.addSubview(sectionView)
        sectionView.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.top)
            make.left.right.equalTo(webView)
        }
    }
}



extension SendLocationController {
    @objc func rightBtnClick(){
        
    }
}
