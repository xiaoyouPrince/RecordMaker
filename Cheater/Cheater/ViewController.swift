//
//  ViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        set{
            
        }
        get{
            .custom
        }
    }
    
    override var modalTransitionStyle: UIModalTransitionStyle {
        set{
            
        }
        get{
            .coverVertical
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        present(MyVC(), animated: true)
    }


}

