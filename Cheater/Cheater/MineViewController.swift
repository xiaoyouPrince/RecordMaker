//
//  MineViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/11.
//

import UIKit

class MineViewController: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = .yellow
//        navigationController?.navigationBar.tintColor = UIColor.orange
//        navigationController?.navigationBar.barTintColor = UIColor.orange
        
        setNavbarWechat()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        navigationController?.popViewController(animated: true)
    }
}
