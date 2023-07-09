//
//  WXDetailCell.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

class WXDetailCell: UITableViewCell {
    
    static let indentifier = "WXDetailCell"
    var model: WXDetailModel? {
        didSet {
            guard let model = model else { return }
            
            let contentView = model.contentClass.init()
            bubbleView.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            
        }
    }
    
    var iconImage: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var bubbleView = UIControl()
    var statusBtn: UIButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)
        
    }
    
    func buildUI() {
        
        // 头像左右边距
        let margin: CGFloat = 12
        let iconSize: CGFloat = 50
        
        addSubview(iconImage)
        addSubview(nameLabel)
        addSubview(bubbleView)
        addSubview(statusBtn)
        
        iconImage.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.width.height.equalTo(iconSize)
            make.top.equalTo(8)
            make.bottom.lessThanOrEqualTo(-8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(5)
            make.top.equalTo(iconImage)
        }
        
        bubbleView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        statusBtn.snp.makeConstraints { make in
            make.bottom.equalTo(bubbleView)
            make.width.height.equalTo(25)
            make.left.equalTo(bubbleView.snp.right).offset(3)
        }
        
    }

}
