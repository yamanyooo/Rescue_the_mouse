//
//  ItemView.swift
//  NH_Takashi
//
//  Created by yohei on 2016/10/30.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation
import UIKit

protocol TapImgDelegate{
    func tapImgEvent(item: ItemView)
}

class ItemView: UIView{
    
    var itemCnt: Int = 0{
        didSet{
            self.text.text = "×" + self.itemCnt.description
        }
    }
    var text: UILabel = UILabel()
    var iconImg: UIImageView = UIImageView()
    var touchImg: Bool = false{
        didSet{
            self.setItemImg()
        }
    }
    var itemSelect: Bool = false{
        didSet{
            self.setItemImg()
        }
    }
    var itemID: Int = -1
    var img: UIImage = UIImage()
    var delegate: TapImgDelegate?
    
    init(frame: CGRect, id: Int, itemNum: Int) {
        
        super.init(frame: frame)
        
        itemID = id
        self.setItemImg()

        self.itemCnt = itemNum
        
        let ratioMargin: CGFloat = 1
        let ratioIconWidth: CGFloat = 16
        let ratioIconHeight: CGFloat = 14
        let ratioTextHeight: CGFloat = 6
        let ratioWidthSum: CGFloat = ratioMargin * 2 + ratioIconWidth
        let ratioHeightSum: CGFloat = ratioMargin * 2 + ratioIconHeight + ratioTextHeight
        
        let iconSizeWidth = self.frame.width * ratioIconWidth / ratioWidthSum
        let iconSizeHeight = self.frame.height * ratioIconHeight / ratioHeightSum
        
        let widthNm = iconSizeWidth / img.size.width
        let heightNm = iconSizeHeight / img.size.height
        
        let scale: CGFloat = widthNm < heightNm ? widthNm : heightNm
        
        let resultIconSizeWidth = floor(img.size.width * scale)
        let resultIconSizeHeight = floor(img.size.height * scale)
        let resultTextHeight = floor(resultIconSizeWidth * ratioTextHeight / ratioIconHeight)
        let resultMarginWidth = floor((self.frame.width - resultIconSizeWidth) / 2)
        let resultMarginHeight = floor((self.frame.height - resultIconSizeHeight - resultTextHeight) / 2)
        
        self.iconImg.frame = CGRect(x: resultMarginWidth, y: resultMarginHeight, width: resultIconSizeWidth, height: resultIconSizeHeight)
        iconImg.image = img
        self.addSubview(iconImg)
        
        text.frame = CGRect(x: resultMarginWidth, y: resultMarginHeight + resultIconSizeHeight, width: resultIconSizeWidth, height: resultTextHeight )
        text.textAlignment = NSTextAlignment.right
        text.font = UIFont.systemFont(ofSize: resultTextHeight)
        text.font = UIFont.boldSystemFont(ofSize: resultTextHeight)
        text.textColor = UIColor.black
        text.text = "×" + itemCnt.description
        self.addSubview(text)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var tapLocation: CGPoint
        let touch = touches.first
        
        tapLocation = touch!.location(in: self)
        
        if(true == self.iconImg.frame.contains(tapLocation)){
            
            touchImg = true
            
        }else{
            
            // NONE
        }

    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var tapLocation: CGPoint
        let touch = touches.first
        
        tapLocation = touch!.location(in: self)
        
        if(false == self.iconImg.frame.contains(tapLocation)){
        
            touchImg = false
        
        }else{
            
            // NONE
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        var tapLocation: CGPoint
        let touch = touches.first
        
        tapLocation = touch!.location(in: self)

        if((true == self.iconImg.frame.contains(tapLocation))
            && (true == touchImg)){
            
            self.delegate?.tapImgEvent(item: self)
            
        }else{
            
            // NONE
        }
        
        touchImg = false

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        
        touchImg = false
        
    }
    
    func setItemImg(){
        
        var fileName: String
        let fileImg: UIImage
        
        if(true == self.itemSelect){
            
            fileName = (true == touchImg) ? itemData[itemID].itemImgActiveTap : itemData[itemID].itemImgActive
    
        }else{
            
            fileName = (true == touchImg) ? itemData[itemID].itemImgInactiveTap : itemData[itemID].itemImgInactive

        }
        
        fileImg = UIImage(named: fileName)!
        
        img = fileImg
        iconImg.image = img
    }
    
    
}
