//
//  WXChooseStatusController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/6.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
 

/*
 * - TODO -
 * 这个是微信选择状态的控制器
 * 弹出可用状态并返回状态icon的名称
 *  1. 返回字符串名称, App 需要持久化的数据量会比 UIImage 小很多
 *  2. ...
 */

import Foundation
import UIKit
import XYUIKit

class WXChooseStatusController: UIViewController {
    
    typealias Callback = (String)->()
    private static var callback: Callback?
    var items: [String] = {
        var result = [String]()
        for index in 1...44 { // 44个
            result.append("zhuangtai_\(index)")
        }
        return result
    }()
    
    static func chooseStatus(_ callback: @escaping (String)->()){
        let instance = WXChooseStatusController()
        self.callback = callback
        let collectionView = instance.setupCollectionView()
        
        XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customHeader: collectionView, actions: [.init(title: "移除当前状态")]) { index in
            
            if index == -1 { // cancel
                callback("")
            }
            if index == 0 { // remove status
                callback("no_status")
            }
        }
    }
}

extension WXChooseStatusController {
    
    private func setupCollectionView() -> UIView {
        let view = UIControl(frame: .zero)
        view.addBlock(for: .touchUpInside) { _ in
            // do 
        }
        let gridView = getGridView()
        let scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        scrollView.addSubview(gridView)
        
        view.snp.makeConstraints { make in
            make.height.equalTo(400)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gridView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(CGFloat.width)
        }
        
        return view
    }
    
    private func getGridView() -> UIView {
        let itemsView = UIView()
        
        // 九宫格展示子类 items
        let margin = 10
        let items = self.items
        
        let colum = 6
        let width = (Int(UIScreen.main.bounds.width - CGFloat(margin*2)) - (colum - 1) * margin) / colum
        let height = width
        
//        let width = 50
//        let height = 50
//        let colum = 7
//        Int(UIScreen.main.bounds.width) > (colum - 1) * margin + //
        
        var index = -1
        for item in items {
            index += 1
            let itemView = UIImageView(image: UIImage(named: item)?.withRenderingMode(.alwaysTemplate))
            itemView.tintColor = .C_wx_status
            itemsView.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                
                make.left.equalToSuperview().offset((width + margin) * (index % colum))
                make.top.equalToSuperview().offset((height + margin) * (index / colum))
                make.width.equalTo(width)
                make.height.equalTo(height)
                
                if index == items.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            
            itemView.addTap { sender in
                //Toast.make(item)
                WXChooseStatusController.callback?(item)
                XYAlertSheetController.dissmiss()
            }
        }
        
        return itemsView
    }
    
}

