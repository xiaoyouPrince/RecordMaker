//
//  UITextView+Emotion.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/15.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit

class EmotionAttchment: NSTextAttachment {
    /// 中文名称
    var chs: String?
}

/// 封装UITextView插入和读取属性字符串的方法
extension UITextView {
    
    /// 获取TextView的AttributeString
    ///
    /// - Returns: 转换后的文本
    func getAttributeString() -> String {
        
        // 1.获取属性字符串
        let attrStr = NSMutableAttributedString(attributedString: attributedText)
        
        // 2.遍历 attrStr 对原有的表情进行替换
        let range = NSMakeRange(0, attrStr.length)
        attrStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            
            //print("\(String(describing: dict))" + "-----" + "(\(range.location),\(range.length))")
            
            if  let attachment = dict[NSAttributedString.Key(rawValue: "NSAttachment")] as? EmotionAttchment {
                attrStr.replaceCharacters(in: range, with: attachment.chs!)
            }
            
            //print(attrStr.string)
        }
        
        return attrStr.string
    }
    
    
    func insertEmotionToTextView(emotion : EmotionItem) {
        
        // 普通表情（图文混排）
        // 1.设置attachment
        let attachment = EmotionAttchment()
        attachment.chs = emotion.title
        attachment.image = emotion.image //UIImage(contentsOfFile: emotion.pngPath!)
        let font = self.font
        attachment.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
        
        // 2.通过attachMent生成待使用属性字符串
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        // 3.取得原textView内容获得原属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        // 4.替换当前位置的属性字符串并重新赋值给textView
        let range = selectedRange
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        
        attributedText = attrMStr
        
        // 5.处理出现的遗留问题
        self.font = font
        selectedRange = NSMakeRange(range.location + 1, range.length)
        
    }
    
    
    
}
