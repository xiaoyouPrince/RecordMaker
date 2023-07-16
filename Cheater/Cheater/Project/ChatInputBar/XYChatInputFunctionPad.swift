//
//  XYChatInputFunctionPad.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/14.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

class XYChatInputFunctionPad: UIView {
    
    let collectionViewMargin: CGFloat = 15
    let collectionViewHeight: CGFloat = 200
    
    /// 功能按钮点击回调
    var actionCallback:((String)->())?
    
    private lazy var collectioinViewLayout: UICollectionViewFlowLayout = getLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectioinViewLayout)
    private lazy var pageControl = UIPageControl()
    private lazy var dataArray: [FuncitonPadCell.CellModel] = getModels()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        
        addSubview(collectionView)
        addSubview(pageControl)
        
        pageControl.numberOfPages = 2
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FuncitonPadCell.self, forCellWithReuseIdentifier: FuncitonPadCell.indentifier)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = WXConfig.inputBgColor
//        collectionView.snp.makeConstraints { make in
//            make.left.top.right.equalToSuperview()
//            make.height.equalTo(collectionViewHeight)
//        }
        // collectionView 自动布局每次渲染视觉效果能看到, frame 直接定位无渲染的 UI 效果
        collectionView.frame = CGRect(origin: .init(x: collectionViewMargin, y: collectionViewMargin), size: .init(width: .width - 2*collectionViewMargin, height: collectionViewHeight))
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        addSubview(.line)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: (CGFloat.width - 2*collectionViewMargin) / 4 , height: collectionViewHeight/2)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    fileprivate func getModels() -> [FuncitonPadCell.CellModel] {
       return [
            FuncitonPadCell.CellModel( title: "照片", imageName: "ChatRomm_ToolPanel_Icon_Photo_64x64_"),
            FuncitonPadCell.CellModel( title: "红包", imageName: "ChatRomm_ToolPanel_Icon_Luckymoney_64x64_"),
            FuncitonPadCell.CellModel( title: "拍摄", imageName: "ChatRomm_ToolPanel_Icon_Video_64x64_"),
            FuncitonPadCell.CellModel( title: "转账", imageName: "ChatRomm_ToolPanel_Icon_Pay_64x64_"),
            FuncitonPadCell.CellModel( title: "视频通话", imageName: "ChatRomm_ToolPanel_Icon_Videovoip_64x64_"),
            FuncitonPadCell.CellModel( title: "语音输入", imageName: "ChatRomm_ToolPanel_Icon_Voiceinput_64x64_"),
            FuncitonPadCell.CellModel( title: "位置", imageName: "ChatRomm_ToolPanel_Icon_Location_64x64_"),
            FuncitonPadCell.CellModel( title: "收藏", imageName: "ChatRomm_ToolPanel_Icon_MyFav_64x64_"),
            FuncitonPadCell.CellModel( title: "添加系统消息", imageName: "ChatRomm_ToolPanel_Icon_Photo_64x64_"),
            FuncitonPadCell.CellModel( title: "文件", imageName: "ChatRomm_ToolPanel_Icon_Photo_64x64_"),
            FuncitonPadCell.CellModel( title: "添加时间", imageName: "ChatRomm_ToolPanel_Icon_Photo_64x64_"),
            FuncitonPadCell.CellModel( title: "个人名片", imageName: "ChatRomm_ToolPanel_Icon_Photo_64x64_"),
            FuncitonPadCell.CellModel( title: "切换用户", imageName: "ChatRomm_ToolPanel_Icon_Photo_64x64_"),
            FuncitonPadCell.CellModel( title: "卡券", imageName: "ChatRomm_ToolPanel_Icon_Photo_64x64_"),
            FuncitonPadCell.CellModel( title: "链接", imageName: "ChatRomm_ToolPanel_Icon_Photo_64x64_"),
            FuncitonPadCell.CellModel( title: "", imageName: ""),
        ]
    }

}

extension XYChatInputFunctionPad : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let percent = scrollView.contentOffset.x / scrollView.bounds.width
        if percent > 0.5 {
            pageControl.currentPage = 1
        }else{
            pageControl.currentPage = 0
        }
        
    }
}

extension XYChatInputFunctionPad : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FuncitonPadCell = collectionView.dequeueReusableCell(withReuseIdentifier: FuncitonPadCell.indentifier, for: indexPath) as! FuncitonPadCell
        cell.model = dataArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: FuncitonPadCell.CellModel = dataArray[indexPath.item]
        actionCallback?(model.title)
    }
}


private class FuncitonPadCell: UICollectionViewCell {
    
    struct CellModel {
        var title: String
        var imageName: String
    }
    
    static let indentifier: String = "FuncitonPadCell"
    
    let button = UIImageView()//UIButton(type: .system)
    let titleLabel = UILabel()
    let btnCover = UILabel()
    var model: CellModel? {
        didSet{
            guard let model = model else { return }
            
            let image = UIImage(named: model.imageName)?.withRenderingMode(.alwaysOriginal)
            button.image = image
            //button.setImage(image, for: .normal)

            titleLabel.text = model.title
            
            button.isHidden = model.imageName.isEmpty
            titleLabel.isHidden = model.imageName.isEmpty
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(button)
        addSubview(titleLabel)
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(5)
        }
        
        button.corner(radius: 10)
        button.backgroundColor = .white
        
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = .C_666666
        
        addSubview(btnCover)
        btnCover.isHidden = true
        btnCover.backgroundColor = .white.withAlphaComponent(0.5)
        btnCover.snp.makeConstraints { make in
            make.edges.equalTo(button)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.isSelected = !self.isSelected
                })
            }
            btnCover.isHidden = !isSelected
        }
    }
}
