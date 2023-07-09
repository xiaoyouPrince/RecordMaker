//
//  WXAddRuleViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/22.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 微信主页 - 通讯录 - 右上角点击,添加角色页面
 */

import XYUIKit
import XYInfomationSection
import XYAlbum

class WXAddRuleViewController: XYInfomationBaseViewController {
    
    struct TitleText {
        static let name = "名字"
        static let icon = "头像"
    }
    
    let addHeadImage = UIImage(named: "add_head")
    private var saveCallback: ((WXContact)->())?
    private var randomContact: WXContact?
    
    init(saveCallback: ((WXContact)->())? = nil) {
        self.saveCallback = saveCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav(with: "添加角色")
        refreshContent()
        refreshBottom()
    }
}

extension WXAddRuleViewController {
    
    func setupNav(with navtitle: String) {
        title = navtitle
        view.backgroundColor = WXConfig.tableViewBgColor
        setNavbarWechat()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveAction))
        nav_setCustom(backImage: WXConfig.wx_backImag)
    }
    
    func refreshContent() {
        
        setContentWithData(contentData(), itemConfig: { item in
            item.titleFont = UIFont.systemFont(ofSize: 17)
            item.titleColor = UIColor.black
            item.accessoryView = UIImageView(image: UIImage(named: "youjiantou"))
            item.cellHeight = 60
        }, sectionConfig: {section in
            section.corner(radius: 0)
        }, sectionDistance: 10, contentEdgeInsets: .zero) {[weak self] index, cell in
            //Toast.make("\(cell.model.title)")
            guard let self = self else {return}
            
            if cell.model.title == TitleText.icon {
                
                var actions = ["相册","相机"]
                var currentImage: UIImage?
                if let obj = cell.model.obj as? UIImage, obj != self.addHeadImage {
                    actions.append("编辑当前图片")
                    currentImage = obj
                }
                
                XYAlertSheetController.showDefault(on: self, title: "从哪里选择", subTitle: nil, actions: actions ) { index in
                    if index == 0 {
                        self.askAuthAndChooseImage(type: .album)
                    }else if index == 1 {
                        self.askAuthAndChooseImage(type: .camera)
                    }else{
                        if let currentImage = currentImage {
                            // 编辑当前图片
                            let editVC = XYEditViewController()
                            editVC.delegate = self
                            editVC.image = currentImage
                            self.push(editVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func askAuthAndChooseImage(type: AuthType) {
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
    
    func refreshBottom() {
        
        let addRandomBtn = UIButton(type: .custom)
        addRandomBtn.backgroundColor = .C_587CF7
        addRandomBtn.setTitle("随机生成一个", for: .normal)
        addRandomBtn.corner(radius: 5)
        addRandomBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        addRandomBtn.addTap { [weak self] _ in
            self?.randomContact = WXContact.random
            self?.refreshContent()
        }
        
        setFooterView(addRandomBtn, edgeInsets: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    func contentData() -> [Any] {
        
        var image: UIImage?
        var title: String?
        if let randomContact = randomContact {
            image = randomContact.image
            title = randomContact.title
        }
        
        return [ // total
            [ // section 1
                [
                    "title": TitleText.icon,
                    "type": XYInfoCellType.other.rawValue,
                    "customCellClass": PhotoCell.self,
                    "value": image != nil ? "true" : "false",
                    "obj": image ?? addHeadImage as Any
                ],
                [
                    "title": TitleText.name,
                    "type": XYInfoCellType.input.rawValue,
                    "value": title ?? ""
                ]
            ]
        ]
        
    }
    
    @objc func saveAction(){
        
        var result = [AnyHashable: Any]()
        var image = UIImage()
        for subview in contentView.subviews.first!.subviews {
            if let subView = subview as? XYInfomationSection {
                result = subView.contentKeyValues

                if let first = subView.dataArray.first, let obj = first.obj as? UIImage, obj != addHeadImage {
                    image = obj
                }
            }
        }
        
        if let image = result[TitleText.icon] as? String, image == "false" { // not choose icon
            Toast.make("请选择\(TitleText.icon)")
            return
        }
        if let title = result[TitleText.name] as? String, title.isEmpty == true { // not input title
            Toast.make("请输入\(TitleText.name)")
            return
        }
        
        //Toast.makeDebug(result.toString ?? "")
        let contact = WXContact(image: image, title: result[TitleText.name] as! String)
        contact.save()

        //Toast.makeDebug("新建的联系人 - \(contact.title)")
        ContactDataSource.update()
        saveCallback?(contact)
        navigationController?.popViewController(animated: true)
    }
}

extension WXAddRuleViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, XYEidtViewControllerDelegate {
    
    func showImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        topMostViewController.present(imagePicker, animated: true)
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
        
        if self.randomContact != nil {
            self.randomContact?.imageData = editedImage.pngData()
        }else{
            self.randomContact = WXContact.random
            self.randomContact?.imageData = editedImage.pngData()
            self.randomContact?.title = ""
        }
        self.refreshContent()
    }
}


extension WXAddRuleViewController {
    
    
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
