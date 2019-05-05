//
//  GameModeItem.swift
//  NH_Takashi
//
//  Created by yohei on 2016/10/12.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation
import UIKit

let activeItemNone: Int = -1

class GameModeItem: UIImageView, TapImgDelegate{
    
    var itemView = [ItemView]()
    var activeItem: Int = activeItemNone
    
    init(frame: CGRect, itemInfo: [ItemInfo]) {
        
        super.init(frame: frame)

        let backgroundImage: UIImage = UIImage(named: "wood.jpg")!
        self.image = backgroundImage
        self.isUserInteractionEnabled = true
        
        let itemViewNum: Int = 5
        let itemViewWidth = self.frame.width / CGFloat(itemViewNum)
        let itemViewHeight = self.frame.height
        let itemViewAdjNum: Int = Int(self.frame.width) % itemViewNum
        
        var xPoint: CGFloat = 0
        let yPoint: CGFloat = 0
        var itemViewAdjSize: CGFloat = 0
        

        
        for i in 0..<itemViewNum{
            
            itemViewAdjSize = itemViewAdjNum > i ? 1 : 0

            if(i < itemInfo.count){
                itemView.append(ItemView(frame: CGRect(x: xPoint, y: yPoint, width: itemViewWidth + itemViewAdjSize, height: itemViewHeight) ,id: itemInfo[i].itemId, itemNum: itemInfo[i].itemCnt))
                itemView[i].backgroundColor = UIColor.clear
                self.addSubview(itemView[i])
                itemView[i].delegate = self
            }else{}
            
            xPoint += itemViewWidth + itemViewAdjSize
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    
    // デリゲート関数
    func tapImgEvent(item: ItemView) {
        
        item.itemSelect = !item.itemSelect
        
        if(true == item.itemSelect){
            self.activeItem = itemView.index(of: item)!
        }else{
            self.activeItem = activeItemNone
        }
        
        for i in 0..<itemView.count{
            
            if(item != itemView[i]){
                
                itemView[i].itemSelect = false
                
            }else{}
        }
        
    }
    
}
