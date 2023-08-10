//
//  SendLocationController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/10.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 发送定位VC
 
 这里查看了[易截图]App的做法,基于它们做的
 1. 访问易截图提供的也没地址
 2. 监听文件加载到的js文件,并手动拿到用户选择的位置,这里需要js直接操作dom.通过dom获取位置
 3. 调用腾讯地图 API, 获取指定位置图片 https://apis.map.qq.com/ws/staticmap/v2/?center=39.904228,116.406467&zoom=15&size=600*200&maptype=roadmap&key=4UGBZ-62SWP-HJRDU-V6Q4W-HS4XQ-5EFKG&scale=2
 
 // dom 获取选中目标地理位置
 document.getElementById("activePosition")
 <div id=​"activePosition" class=​"active-pos">​<h2 class=​"poi-title">​东城区王府井东方广场(东长安街北150米)​</h2>​<p class=​"poi-address initPos">​北京市东城区东长安街1号中区​</p>​<span class=​"poi-latlng">​39.909496283262236,116.41373604766846​</span>​<span class=​"poi-city">​北京市​</span>​<i class=​"active" style=​"display:​ inline-block;​">​</i>​</div>
 
 // dom 获取并拦截发送按钮
 document.getElementById("btn")
 <div id=​"btn">​<a onclick=​"send()​">​发送​</a>​</div>
 
 这里可以重写一个 onclick 回调的方法 - 示例如下
 <div id=​"btn">​<a onclick={alert("你好");}>​发送​</a>​</div>
 
 
 */
import UIKit
import WebKit
import XYUIKit

private struct MapUrls {
    static let yijietu: URL = URL(string: "https://1jietu.com/map.html?platform=ios&system=ios")!
    static let tencentApi: URL = URL(string: "https://apis.map.qq.com/ws/staticmap/v2/?center=39.904228,116.406467&zoom=15&size=600*200&maptype=roadmap&key=4UGBZ-62SWP-HJRDU-V6Q4W-HS4XQ-5EFKG&scale=2")!
}

class SendLocationController: UIViewController {
    
    var webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(rightBtnClick), title: "操作")

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
//        let url = URL(string: "https://1jietu.com/map.html?platform=ios&system=ios")!
//        webView.load(NSMutableURLRequest(url: url) as URLRequest)
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <title>HTML示例</title>
        </head>
        <body>
        <div id="activePosition">
        <!-- 在这里添加您希望显示的内容 -->
        我是谁?
        </div>
        
        <a href="#" id="btn">点击这里</a>
        </body>
        </html>
        
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    @objc func rightBtnClick(){
        getLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        // 等待网页加载完成
        webView.evaluateJavaScript("document.readyState") { (result, error) in
            if result != nil {
                // 执行JavaScript代码来查找元素
                let elementQuery = "document.querySelector('activePosition')" // 替换'selector'为你要查找的元素选择器
                self.webView.evaluateJavaScript(elementQuery) { (result, error) in
                    if result != nil {
                        // 处理找到的元素
                        print(result)
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func getLocation() {
        let getSelectedLocation = "document.getElementById('activePosition').innerText"
        webView.evaluateJavaScript(getSelectedLocation, completionHandler: { result, error in
            if let error = error {
                Toast.make(error.localizedDescription)
            }else{
                print("location ->")
                print(result ?? "err")
            }
        })
        
        let getBtn = "document.getElementById('btn')"
        webView.evaluateJavaScript(getBtn, completionHandler: { result, error in
            if let error = error {
                Toast.make(error.localizedDescription)
            }else{
                print("btn ->")
                print(result ?? "err")
            }
        })
        
//        let getLatLng = "document.getElementsByClassName('poi-latlng')[0].innerText"
//        webView.evaluateJavaScript(getLatLng, completionHandler: { result, error in
//            if let error = error {
//                Toast.make(error.localizedDescription)
//            }else{
//                print("getLatLng ->")
//                print(result ?? "getLatLng")
//            }
//        })
//
//        let javaScriptCode = "document.querySelectorAll('a')"
//        webView.evaluateJavaScript(javaScriptCode, completionHandler: { (result, error) in
//            if error == nil {
//                // 处理结果
//                if let links = result as? [Any] {
//                    for link in links {
//                        print(link) // 打印链接的标题
//                    }
//                }
//            } else {
//                // 处理错误
//                print(error?.localizedDescription)
//            }
//        })
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", let webV = object as? WKWebView {
            if webV.estimatedProgress == 1.0 {
                getLocation()
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}
