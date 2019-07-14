//
//  GameObjectView.swift
//  NH_Takashi
//
//  Created by yohei on 2016/08/20.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation
import UIKit




class GameObjectView: UIView {
    
    var tilePosX = 0
    var tilePosY = 0
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    //    override func drawRect(rect: CGRect) {
    
    //    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.green

    }
    

}
