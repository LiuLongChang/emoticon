//
//  ViewController.swift
//  Emoticon
//
//  Created by langyue on 16/10/31.
//  Copyright © 2016年 langyue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


        let label = UILabel.init(frame: CGRect.init(x: 100, y: 100, width: 250, height: 250))
        view.addSubview(label)
        let str = "我[爱你]啊！ [哈哈哈],我想[泪]了,[马上有对象]是骗人的,这是马上面向对象[哼][噢耶][好爱哦][偷乐]"
        label.attributedText = YWEmoticonManager.shared.emoticonString(string: str, font: UIFont.systemFont(ofSize: 15))
        label.numberOfLines = 0


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

