//
//  WXContactCell.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/19.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit

class WXContactCell: UITableViewCell {
    
    private var iconView = UIImageView()
    private var titleLabel = UILabel()
    private var totalLabel = UILabel()
    
    var model: WXContact? {
        didSet {
            iconView.image = model?.image
            titleLabel.text = model?.title
            totalLabel.text = model?.title
            
            if model?.image == nil {
                totalLabel.isHidden = false
                titleLabel.isHidden = true
                
                contentView.snp.remakeConstraints { make in
                    make.height.equalTo(50)
                }
            }else{
                totalLabel.isHidden = true
                titleLabel.isHidden = false
                
                contentView.snp.remakeConstraints { make in
                    make.height.equalTo(60)
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(totalLabel)
        
        iconView.corner(radius: 5)
        iconView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.top.equalTo(8)
            make.width.equalTo(iconView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(-15)
        }
        
        totalLabel.textAlignment = .center
        totalLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(CGFloat.width)
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
