//
//  AuthorityManagerAlbumExtension.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/5.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import Foundation
import Photos

///相册权限
extension AuthorityManager {
    
    func album() {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                    if status == .authorized {
                        self?.authCompletion(true)
                    } else {
                        self?.authCompletion(false)
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { [weak self] status in
                    if status == .authorized {
                        self?.authCompletion(true)
                    } else {
                        self?.authCompletion(false)
                    }
                }
            }
            break
        case .restricted, .denied:
            showSettingAlert()
            break
        case .authorized, .limited:
            self.authCompletion(true)
            break
        default:
            self.authCompletion(false)
            break
        }
    }
}

@objc public extension AuthorityManager {
    ///检查相册权限
    @objc func isHaveAlbumAuth() -> Bool {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if #available(iOS 14, *) {
            if status == .authorized || status == .limited {
                return true
            }
        } else {
            if status == .authorized {
                return true
            }
        }
        return false
    }
    
    @objc func isAlbumDenied() -> Bool {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if status == .restricted || status == .denied {
            return true
        }
        return false
    }
}
