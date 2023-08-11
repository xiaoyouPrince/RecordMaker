//
//  SendLocationController2.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/10.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 发送定位VC

 -- 以下思路是可以行的,但是实际操作遇到一些问题,不好解决,放弃此思路
 1. 元素找不到, 从网页上操作也是有时候能查找到,有时候不能查找到,不解
 
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

class WebView: WKWebView, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
    }
}

class SendLocationController2: UIViewController {
    
    var webView: WebView = WebView()
    var callback: ((MsgModelLocation)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        let config = WKWebViewConfiguration()
        webView = WebView(frame: .zero, configuration: config)
        config.userContentController.add(self, name: "myApp")
        webView.uiDelegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        //此方法不行主要是其地图组件本身是插入的,直接通过id查element可能查不到
        //let url = URL(string: "https://1jietu.com/map.html?platform=ios&system=ios")!
        //webView.load(NSMutableURLRequest(url: url) as URLRequest)

        if let url = SendLocationController2.HTML {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension SendLocationController2 : WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        
        /*
         {
             cityname = "\U5317\U4eac\U5e02";
             latlng =     {
                 lat = "39.90469";
                 lng = "116.40717";
             };
             mapImage = "https://apis.map.qq.com/ws/staticmap/v2/?center=39.90469,116.40717&zoom=15&size=600*200&maptype=roadmap&key=4UGBZ-62SWP-HJRDU-V6Q4W-HS4XQ-5EFKG&scale=2";
             module = locationPicker;
             poiaddress = "\U5317\U4eac\U5e02";
             poiname = "\U6211\U7684\U4f4d\U7f6e";
         }
         */
        
        if let dict = message.body as? [String: Any] {
            DispatchQueue.global().async {
                let location = MsgModelLocation(dict: dict)
                DispatchQueue.main.async {
                    self.callback?(location)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            Toast.make("数据异常,请暂停使用本功能...")
        }
    }
}

extension SendLocationController2 : WKUIDelegate {
    /**
     *  处理js里的alert
     *
     */
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if message.contains("http") {
            print("图片地址:\(message)")
            completionHandler()
            return
        }
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "确定", style: .default, handler: { action in
            completionHandler()
        })
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}


extension SendLocationController2 {
    static var HTML: URL? {
        Bundle.main.url(forResource: "locationPicker", withExtension: "html")
    }
    
    static var jQuery: URL? {
        Bundle.main.url(forResource: "jQuery", withExtension: "js")
    }
}
