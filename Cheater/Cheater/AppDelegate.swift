//
//  AppDelegate.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/11.
//

import UIKit
import XYNav
/*
    关于导入 XYNav 头文件, 不知道 Xcode 是什么问题,需要在某地显示导入一下,否则一些拓展方法无法使用.
    不过可以理解的是: 需要在本项目的命名空间内引入一下其他命名空间的内容.
 
    但是 SnapKit 为什么就可以呢? 可能是因为其他组件显示的 import snapkit 了,并且其他组件被 import,
    在编译时期,系统会递归编译 import 过的所有内容,这样就解释通了
 */

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

