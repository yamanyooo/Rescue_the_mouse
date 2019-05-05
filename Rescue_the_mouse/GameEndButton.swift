//
//  GameEndButton.swift
//  NH_Takashi
//
//  Created by yohei on 2016/12/06.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonTapDelegate{
    func buttonTap(view: GameEndButton)
}

enum ButtonPos{
    
    case INI_VALUE
    case LEFT
    case RIGHT
}

class GameEndButton: UIImageView{
    
    let buttonImg: UIImage
    let buttonImgTap: UIImage
    var button: UIImageView = UIImageView()
    var buttonPos: ButtonPos = ButtonPos.INI_VALUE
    var delegate: ButtonTapDelegate?
    var tapState: Bool = false{
        didSet{
            if(true == tapState){
                self.button.image = buttonImgTap
            }else{
                self.button.image = buttonImg
            }
        }
    }
    
    init(frame: CGRect, img: UIImage, imgTap: UIImage, imgMask: UIImage, pos: ButtonPos){

        self.buttonImg = img
        self.buttonImgTap = imgTap
        
        
        super.init(frame: frame)
        
        self.buttonPos = pos
        self.isUserInteractionEnabled = true
        self.image = imgMask
        self.backgroundColor = UIColor.clear
        self.contentMode = UIView.ContentMode.scaleAspectFit
        self.layer.backgroundColor = UIColor.clear.cgColor

        button.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        button.image = img
        button.contentMode = UIView.ContentMode.scaleAspectFit
        button.isUserInteractionEnabled = false

        self.addSubview(button)
        
        

    }
    
    required init(coder aDecoder: NSCoder){
        
        fatalError("init error")
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let territory = judgeTerritory(point: point)

        if(true == territory){
            
            return self
            
        }else{
            
            return nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.tapState = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var tapLocation: CGPoint
        var territory: Bool
        let touch = touches.first
        
        tapLocation = touch!.location(in: self)
        territory = judgeTerritory(point: tapLocation)
        
        if(true == territory){
            // NONE
        }else{
            tapState = false
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var tapLocation: CGPoint
        var territory: Bool
        let touch = touches.first
        
        tapLocation = touch!.location(in: self)
        territory = judgeTerritory(point: tapLocation)
        
        if( (true == territory)
         && (true == tapState)){
            // Tap成立 デリゲート
            delegate?.buttonTap(view: self)
            
        }else{
            // NONE
        }
        
        tapState = false
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        tapState = false
    }
    
    func judgeTerritory(point: CGPoint)->Bool{
        
        var result: Bool = false
        
        if(true != self.bounds.contains(point)){

            result = false
        }else{
            
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let imgPng = UIGraphicsGetImageFromCurrentImageContext()!.pngData()
            let imgCtx = UIImage(data: imgPng!)
            UIGraphicsEndImageContext()
            
            let pixelData = imgCtx?.cgImage?.dataProvider?.data
            // 画素バッファを得る
            let data = CFDataGetBytePtr(pixelData)
            
            
            let address : Int = Int(imgCtx!.size.width) * Int(point.y) + Int(point.x)
            let alpha = CGFloat((data?[address*4+3])!) / 255.0

            
            if(0 != alpha){
                
                result = true
            }else{
                
                result = false
            }
        }
        
        return result
    }
}
