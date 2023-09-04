//
//  PYQPageInfoProtocol.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/9/4.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 朋友圈所有页面共用数据协议
 *
 *  1. 目的是通过此协议,页面内的 view 能便捷共享共用数据
 *
 */

// 想办法,写成一个范型协议,每个 VC, 可以自己指定自己的 PageInfo 并且能

import Foundation

protocol PYQPageInfoProtocol {
    var pageInfo: PYQViewController.PYQPageInfo? { set get }
}

extension PYQViewController : PYQPageInfoProtocol {
    struct AssociateKey {
        static var pageInfoKey: String = "pageInfoKey"
    }
    var pageInfo: PYQPageInfo? {
        get {
            objc_getAssociatedObject(self, &AssociateKey.pageInfoKey) as? PYQPageInfo
        }
        set {
            objc_setAssociatedObject(self, &AssociateKey.pageInfoKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    struct PYQPageInfo {

    }
}
