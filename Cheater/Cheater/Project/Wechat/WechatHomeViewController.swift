//
//  WechatHomeViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/13.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import XYUIKit
import XYInfomationSection

class WechatHomeViewController: XYInfomationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = WXConfig().listBgColor
        setNavbarWechat()
        nav_hideDefaultBackBtn()
        
        let tabbar = WechatTabbar()
        tabbar.frame.origin = CGPoint(x: 0, y: view.bounds.height - tabbar.bounds.height)
        view.addSubview(tabbar)
        
        
        let image = UIImage(named: "tabbar_contactsHL_new_26x21_")
        let iv = UIImageView(image: image)
        view.addSubview(iv)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nav_hideBarBottomLine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nav_hideBarBottomLine(false)
    }
}
