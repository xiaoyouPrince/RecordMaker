//
//  ChoosePhotoController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/15.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 一个选择图片小工具
 * 静态方法直接调用选择图片方法,内部处理选择图片的方式和处理,回调直接返回处理完成之后的图片
 *  1. 静态调用
 *  2. 图片处理完统一回调
 */

import UIKit
import XYAlbum
import XYUIKit

class ChoosePhotoController: UIViewController {
    static var shared: ChoosePhotoController = ChoosePhotoController()
    private var callback: ((UIImage)->())?
    
    static func choosePhoto(_ callback: @escaping (UIImage)->()){
        self.shared.callback = callback
        
        let currentVC = UIViewController.currentVisibleVC
        XYAlertSheetController.showDefault(on: currentVC, title: "从哪里选择", subTitle: nil, actions: ["相册", "拍照"] ) { index in
            if index == 0 {
                self.shared.askAuthAndChooseImage(type: .album)
            }else if index == 1 {
                self.shared.askAuthAndChooseImage(type: .camera)
            }
        }
    }
    
    private func askAuthAndChooseImage(type: AuthType) {
        AuthorityManager.shared.request(auth: type) {[weak self] completion in
            print(completion, "----")
            
            if type == .album {
                self?.showAlbum()
            }else
            {
                self?.showImagePicker()
            }
            
        } settingHandler: { completion in
            
        }
    }
}

extension ChoosePhotoController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, XYEidtViewControllerDelegate {
    
    func showImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        let currentVC = UIViewController.currentVisibleVC
        currentVC.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("info = \(info)")
        
        // 1. 销毁picker控制器
        picker.dismiss(animated: true, completion: nil)
        
        // 原图
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 进入编辑页面
            let editVC = XYEditViewController()
            editVC.delegate = self
            editVC.image = image
            
            present(editVC, animated: true, completion: nil)
        }
    }
    
    func imageEidtFinish(_ editedImage: UIImage) {
        self.callback?(editedImage)
    }
}

 
private extension ChoosePhotoController {
    
    
    func showAlbum() {
        print("showAlbum---")
        
        let album = XYAlbumViewController.init { choosedImage in
            
        } finishEdit: {[weak self] editedImage in
            // todo: - 压缩图片放到一个 50*50 的大小,用作 icon
            self?.imageEidtFinish(editedImage)
        }
        UIViewController.currentVisibleVC.present(album, animated: true)
    }
    
    /// 通过指定图片生成指定size大小的小图
    /// - Parameters:
    ///   - image: 原图
    ///   - size: 目标大小
    /// - Returns: 结果图
    func generateThumbnail(image: UIImage, size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let thumbnail = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return thumbnail
    }
}
