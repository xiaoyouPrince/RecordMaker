//
//  WXContactTableHaderFooterView.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/21.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit

class WXContactTableHaderFooterView: UITableViewHeaderFooterView {

    var label = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
