//
//  AuthorityCameraExtension.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/5.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import Photos

extension AuthorityManager {
    ///相机权限
    func camera() {
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                self?.authCompletion(granted)
            }
            break
        case .restricted, .denied:
            showSettingAlert()
            break
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.authCompletion(true)
            } else {
                self.authCompletion(false)
            }
            break
        default:
            self.authCompletion(false)
            break
        }
    }
}

@objc public extension AuthorityManager {
    ///检查相机权限
    @objc func isHaveCameraAuth()-> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            return true
        }
        return false
    }
    
    @objc func isCameraAuthDenied()-> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return true
        }
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            return true
        }
        return false
    }
}

