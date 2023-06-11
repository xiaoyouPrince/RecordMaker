//
//  File.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/11.
//

import UIKit

class MyVC: UIViewController {
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        set{
            
        }
        get{
            .custom
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .yellow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
}
