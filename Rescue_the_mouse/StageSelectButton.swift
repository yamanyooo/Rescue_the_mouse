//
//  StageSelectButton.swift
//  Rescue_the_mouse
//
//  Created by yohei on 2019/05/01.
//  Copyright © 2019年 yamanyon. All rights reserved.
//

import Foundation
import UIKit

class StageSelectButton: UIButton{
    
    var stageNumber: Int = 0
    
    init(frame: CGRect, num: Int) {
        super.init(frame: frame)
        
        stageNumber = num
        
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.text = String(stageNumber)
        label.font = UIFont.systemFont(ofSize: frame.height*0.5)
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
}

