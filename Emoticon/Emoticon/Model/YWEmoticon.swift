//
//  YWEmoticon.swift
//  Emoticon
//
//  Created by langyue on 16/11/1.
//  Copyright © 2016年 langyue. All rights reserved.
//

import Foundation
import YYModel

class YWEmoticon: NSObject {


    //表情类型 false - 图片表情/true - emoji
    var type = false
    //表情字符串 发送给服务器 节约流量
    var chs: String?
    //表情的图片名称,用于本地图文混排
    var png: String?
    //emoji 16进制编码
    var code: String?
    //表情模型所在的目录
    var directory: String?
    //图片模型对应的图像
    var image:UIImage?{
        //判断表情类型
        if type {
            return nil
        }
        guard let directory = directory,
        let png = png,
        let path = Bundle.main.path(forResource: "HMEmoticon", ofType: "bundle"),
            let bundle = Bundle(path:path) else {

                return nil

        }
        return UIImage(named: "\(directory)/\(png)",in:bundle,compatibleWith:nil)
    }


    //根据当前的图像 生成图像的属性文本
    func imageText(font:UIFont) -> NSAttributedString{
        //判断图像是否存在
        guard let image = image else {
            return NSAttributedString(string:"")
        }
        //创建文本附件 -图像
        let attachment = NSTextAttachment()
        attachment.image = image
        //lineHeight 大致和字体大小相等
        let height = font.lineHeight
        attachment.bounds = CGRect.init(x: 0, y: -4, width: height, height: height)
        //返回图像属性文本
        return NSAttributedString(attachment:attachment)

    }


    override var description: String{
        return yy_modelDescription()
    }

}


