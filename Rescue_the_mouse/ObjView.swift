//
//  ObjView.swift
//  NH_Takashi
//
//  Created by yohei on 2016/11/22.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation
import UIKit

class ObjView: UIImageView{
    
    var text: UILabel = UILabel()
    var pointX: Int
    var pointY: Int
    var animation: Bool
    
    init(frame: CGRect, x: Int, y: Int) {
        
        pointX = x
        pointY = y
        animation = false
        
        super.init(frame: frame)
        
        let ratioImg: CGFloat = 3
        let ratioText: CGFloat = 1
        let ratioSum: CGFloat = ratioImg + ratioText
        
        let sizeTextHeight = frame.height / ratioSum * ratioText
        
        text.frame = CGRect(x: 0, y: frame.height-sizeTextHeight, width: frame.width, height: sizeTextHeight)
        text.textAlignment = NSTextAlignment.right
        text.font = UIFont.boldSystemFont(ofSize: sizeTextHeight)
        text.textColor = UIColor.black
        self.addSubview(text)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
}
