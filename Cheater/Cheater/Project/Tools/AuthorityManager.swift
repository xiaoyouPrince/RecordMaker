//
//  AuthorityManager.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/5.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 权限管理工具类
 
 1. 相册
    需要在 info.plist 配置 NSPhotoLibraryUsageDescription 描述信息
 
 2. 相机权限
    需要在 info.plist 配置 NSCameraUsageDescription 描述信息
 
 */

import UIKit
import Photos
import XYUIKit

@objc public class AuthorityManager: NSObject {
    
    @objc public static let shared: AuthorityManager = {
        let shared = AuthorityManager()
        return shared
    }()
    
    ///操作完成回调
    public typealias CompletionHandler = ((_ completion: Bool) -> Void)
    ///按钮事件回调
    public typealias ActionHandler = (() -> Void)
    ///授权回调
    var authHandler: CompletionHandler?
    ///去设置回调
    var settingHandler: CompletionHandler?
    
    @objc public func request(auth type: AuthType,
                              authHandler: @escaping CompletionHandler,
                              settingHandler: CompletionHandler? = nil) {
        self.authHandler = authHandler
        self.settingHandler = settingHandler
        
        self.setupAuth(auth: type)
    }
}

extension AuthorityManager {
    
    private func setupAuth(auth: AuthType) {
        self.auth(auth: auth)
    }
    
    private func auth(auth: AuthType) {
        switch auth {
        case AuthType.album:
            self.album()
            break
        case AuthType.camera:
            self.camera()
            break
        default:
            break
        }
    }
    
    func authCompletion(_ res: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.authHandler?(res)
        }
    }
    
    func settingCompletion(_ res: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.settingHandler?(res)
        }
    }
}

// MARK: 弹窗
extension AuthorityManager {
    
    ///系统弹框
    public func presentAlertController(title: String,
                                       message: String,
                                       confirmTitle: String,
                                       cancelTitle: String,
                                       confirmHandler: ActionHandler? = nil,
                                       cancelHandler: ActionHandler? = nil) {
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { action in
            DispatchQueue.main.async {
                confirmHandler?()
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
            DispatchQueue.main.async {
                cancelHandler?()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        let keyWindow = UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.first(where: \.isKeyWindow)
        let rootController = keyWindow?.rootViewController?.topMostViewController
        rootController?.present(alertController, animated: true)
    }
    
    ///去设置的弹窗
    func showSettingAlert() {
        showSettingAlert(title: "权限未开启",
                         message: "当前功能需要获取相册权限，因您已拒绝该权限，可以在设置中手动打开相册权限。",
                         confirmTitle: Alert.Action.open,
                         cancelTitle: Alert.Action.cancel)
    }
    
    ///去设置的弹窗
    func showSettingAlert(title: String,
                          message: String,
                          confirmTitle: String,
                          cancelTitle: String,
                          confirmHandler: ActionHandler? = nil,
                          cancelHandler: ActionHandler? = nil) {
        self.presentAlertController(title: title, message: message, confirmTitle: confirmTitle, cancelTitle: cancelTitle) { [weak self] in
            self?.settingCompletion(true)
            guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {return}
            
            if UIApplication.shared.canOpenURL(settingUrl) {
                UIApplication.shared.open(settingUrl)
            }
        } cancelHandler: { [weak self] in
            self?.settingCompletion(false)
        }
    }
}


extension UIViewController {
    var topMostViewController: UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}

