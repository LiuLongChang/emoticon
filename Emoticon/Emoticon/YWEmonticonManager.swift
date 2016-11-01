//
//  YWEmonticonManager.swift
//  Emoticon
//
//  Created by langyue on 16/10/31.
//  Copyright © 2016年 langyue. All rights reserved.
//

import Foundation
import YYModel


//表情单例：为了便于表情是复用 使用单例 只加载一次表情数据
class YWEmoticonManager{
    static let shared = YWEmoticonManager()
    //表情包懒加载数组
    lazy var packageArr = [YWEmoticonPackage]()

    //构造函数 如果init之前增加private 修饰符， 可以要求调用者必须通过shared 访问对象
    // OC 要重写 allocWithZone方法

    private init(){
        loadPackages()
    }

}


extension YWEmoticonManager{

    /*
     注意 应该倒叙遍历 一次遍历可以把所有的图片替换完成
     我 
     r1 = {1,4}
     r2 = {6,5}
     - 顺序替换 替换前面的之后 后面的范围会失效
     
     
     将给定的字符串转换成属性文本
     
     parameter string: 完整的字符串
     returns: 属性文本
     
     */

    func emoticonString(string: String,font: UIFont)->NSAttributedString{


        let attrString = NSMutableAttributedString(string: string)
        //建立正则表达式 过滤所有的表情文字
        //() [] 都是正则表达式的关键字 如果需要参与匹配 需要转义
        let pattern = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: pattern,options: []) else {
            return attrString
        }

        // 匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location:0,length: attrString.length))

        // 遍历所有匹配结果
        for m in matches.reversed() {
            let r = m.rangeAt(0)
            let subStr = (attrString.string as NSString).substring(with: r)
            //使用subStr 查找对应的表情符号
            if let em = YWEmoticonManager.shared.findEmoticon(string: subStr) {
                //使用表情符号中的属性文本 替换原有的属性文本内容
                attrString.replaceCharacters(in: r, with: em.imageText(font: font))
            }

        }
        //统一设置一遍字符串的属性
        attrString.addAttributes([NSFontAttributeName: font], range: NSRange.init(location: 0, length: attrString.length))

        return attrString
    }



    //根据string 在所有的表情符号中查找对应是表情模型
    // 如果找到返回表情模型
    // 否则 返回nil

    func findEmoticon(string:String?) -> YWEmoticon? {
        //遍历表情包 OC中过滤数组使用谓词 swift 更简单
        for p in packageArr {
            let result = p.emoticonArr.filter(){ $0.chs == string}
            // 判断 结果数量的数组
            //判断 结果数组的数量
            if result.count == 1 {
                return result[0]
            }
        }
        return nil
    }

}


//MARK: - 表情包数据处理
fileprivate extension YWEmoticonManager{

    func loadPackages(){
        //读取emoticons.plist
        //只要按照 Bundle 默认的结构目录设定 就可以直接读取Resources 目录的文件
        guard let path = Bundle.main.path(forResource: "HMEmoticon", ofType: "bundle"),
            let bundle = Bundle(path:path),
            let plistPath = bundle.path(forResource:"emoticons",ofType:"plist"),
            let array = NSArray.init(contentsOfFile: plistPath) as? [[String:String]],
            let modelArray = NSArray.yy_modelArray(with: YWEmoticonPackage.self,json: array) as? [YWEmoticonPackage]
        else {
                return
        }
        //设置表情包数据 使用+= 不会再次给packetArr 分配空间， 直接追加数据
        packageArr += modelArray
        print(packageArr)
    }

}
