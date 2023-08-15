//
//  EmotionManager.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/15.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import Foundation
import UIKit

struct EmotionManager {
    
    static let shared: EmotionManager = .init()
    var emotions: [EmotionItem]
    
    init() {
        self.emotions = EmotionManager.emotions
    }
}

extension EmotionManager {
    /// 获取所有 emotions
    private static var emotions: [EmotionItem] {
        var result = [EmotionItem]()
        for emotion in emotionString {
            if let fullName = emotion.components(separatedBy: "_").last {
                if let preName = fullName.components(separatedBy: ".").first{
                    result.append(EmotionItem(title: "[\(preName)]", imageName: emotion))
                }
            }
        }
        return result
    }
    
    private static let emotionString =
    ["001_微笑.png","002_撇嘴.png","003_色.png","004_发呆.png","005_得意.png","006_流泪.png","007_害羞.png","008_闭嘴.png","009_睡.png","010_大哭.png","011_尴尬.png","012_发怒.png","013_调皮.png","014_呲牙.png","015_惊讶.png","016_难过.png","017_囧.png","018_抓狂.png","019_吐.png","020_偷笑.png","021_愉快.png","022_白眼.png","023_傲慢.png","024_困.png","025_惊恐.png","026_憨笑.png","027_悠闲.png","028_咒骂.png","029_疑问.png","030_嘘.png","031_晕.png","032_衰.png","033_骷髅.png","034_敲打.png","035_再见.png","036_擦汗.png","037_抠鼻.png","038_鼓掌.png","039_坏笑.png","040_右哼哼.png","041_鄙视.png","042_委屈.png","043_快哭了.png","044_阴险.png","045_亲亲.png","046_可怜.png","047_笑脸.png","048_生病.png","049_脸红.png","050_破涕为笑.png","051_恐惧.png","052_失望.png","053_无语.png","054_嘿哈.png","055_捂脸.png","056_奸笑.png","057_机智.png","058_皱眉.png","059_耶.png","060_吃瓜.png","061_加油.png","062_汗.png","063_天啊.png","064_Emm.png","065_社会社会.png","066_旺柴.png","067_好的.png","068_打脸.png","069_哇.png","070_翻白眼.png","071_666.png","072_让我看看.png","073_叹气.png","074_苦涩.png","075_裂开.png","076_嘴唇.png","077_爱心.png","078_心碎.png","079_拥抱.png","080_强.png","081_弱.png","082_握手.png","083_胜利.png","084_抱拳.png","085_勾引.png","086_拳头.png","087_OK.png","088_合十.png","089_啤酒.png","090_咖啡.png","091_蛋糕.png","092_玫瑰.png","093_凋谢.png","094_菜刀.png","095_炸弹.png","096_便便.png","097_月亮.png","098_太阳.png","099_庆祝.png","100_礼物.png","101_红包.png","102_發.png","103_福.png","104_烟花.png","105_爆竹.png","106_猪头.png","107_跳跳.png","108_发抖.png","109_转圈.png"]
}

struct EmotionItem {
    let title: String
    let imageName: String
    
    var image: UIImage {
        UIImage(named: imageName) ?? UIImage()
    }
}
