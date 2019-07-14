//
//  GameModeHeader.swift
//  NH_Takashi
//
//  Created by yohei on 2016/10/12.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation
import UIKit

protocol ExitReqDelegate{
    func exitReq()
}

class GameModeHeader: UIImageView{
    
    var mouseCountView: UILabel = UILabel()
    var delegate: ExitReqDelegate?
    let exitImg: UIImage = UIImage(named: "exit.png")!
    let exitTapImg: UIImage = UIImage(named: "exit_tap.png")!
    
    init(frame: CGRect, stageName: String) {
        
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        let headerImg = UIImage(named: "wood.jpg")!
        self.image = headerImg
        
        let ratioMarginButtonHeight: CGFloat = 1
        let ratioButtonHeight: CGFloat = 5
        let ratioSumButtonHeight: CGFloat = ratioMarginButtonHeight*2 + ratioButtonHeight
        let buttonHeightPerRatio: CGFloat = self.frame.height / ratioSumButtonHeight

        
        let ratioMarginStageNameHeight: CGFloat = 1
        let ratioStageNameHeight: CGFloat = 2
        let ratioSumStageNameHeight: CGFloat = ratioMarginStageNameHeight*2 + ratioStageNameHeight
        let stageNameHeightPerRatio: CGFloat = self.frame.height / ratioSumStageNameHeight

        
        let ratioMarginImageHeight: CGFloat = 1
        let ratioImageTextHeight: CGFloat = 4
        let ratioImageHeight: CGFloat = 12
        let ratioSumImageHeight: CGFloat = ratioMarginImageHeight*2 + ratioImageTextHeight + ratioImageHeight
        let imageHeightPerRatio: CGFloat = self.frame.height / ratioSumImageHeight
        
        let ratioMarginTopMouseCountHeight: CGFloat = 4
        let ratioMarginBottomMouseCountHeight: CGFloat = 1
        let ratioMouseCountHeight: CGFloat = 3
        let ratioSumMouseCountHeight: CGFloat = ratioMarginTopMouseCountHeight + ratioMarginBottomMouseCountHeight + ratioMouseCountHeight
        let mouseCountHeightPerRatio: CGFloat = self.frame.height / ratioSumMouseCountHeight
        
        
        let ratioMarginLeftWidth: CGFloat = 1
        let ratioButtonWidth: CGFloat = 4
        let ratioMarginLeftStageNameWidth: CGFloat = 1
        let ratioMarginRightStageNameWidth: CGFloat = 1
        let ratioStageNameWidth: CGFloat = 12
        let ratioImageWidth: CGFloat = 3
        let ratioMouseCountWidth: CGFloat = 4
        let ratioMarginRightWidth: CGFloat = 0
        let ratioSumWidth: CGFloat = ratioMarginLeftWidth + ratioButtonWidth + ratioMarginLeftStageNameWidth + ratioMarginRightStageNameWidth + ratioStageNameWidth + ratioImageWidth + ratioMouseCountWidth + ratioMarginRightWidth
        let widthPerRatio: CGFloat = self.frame.width / ratioSumWidth
        
        var height: CGFloat = ratioMarginButtonHeight * buttonHeightPerRatio
        var width: CGFloat = ratioMarginLeftWidth * widthPerRatio
        
        let buttonCGRect: CGRect = CGRect(x: width, y: height, width: ratioButtonWidth * widthPerRatio, height: ratioButtonHeight * buttonHeightPerRatio)
        
        height = ratioMarginStageNameHeight * stageNameHeightPerRatio
        width += (ratioButtonWidth + ratioMarginLeftStageNameWidth) * widthPerRatio
        
        let stageNameCGRect = CGRect(x: width, y: height, width: ratioStageNameWidth * widthPerRatio, height: ratioStageNameHeight * stageNameHeightPerRatio)
        
        height = ratioMarginImageHeight * imageHeightPerRatio
        width += (ratioStageNameWidth + ratioMarginRightStageNameWidth) * widthPerRatio
        
        let imageTextCGRect = CGRect(x: width, y: height, width: ratioImageWidth * widthPerRatio, height: ratioImageTextHeight * imageHeightPerRatio)
        
        height += ratioImageTextHeight * imageHeightPerRatio
        
        let imageCGRect = CGRect(x: width, y: height, width: ratioImageWidth * widthPerRatio, height: ratioImageHeight * imageHeightPerRatio)

        height = ratioMarginTopMouseCountHeight * mouseCountHeightPerRatio
        width += ratioImageWidth * widthPerRatio
        
        let mouseCountCGRect = CGRect(x: width, y: height, width: ratioMouseCountWidth * widthPerRatio, height: ratioMouseCountHeight * mouseCountHeightPerRatio)

        
        let buttonView = UIButton(frame: buttonCGRect)
        buttonView.setImage(exitImg, for: UIControl.State.normal)
        buttonView.setImage(exitTapImg, for: UIControl.State.highlighted)
        buttonView.addTarget(self, action: #selector(exitButtonTapInside), for: .touchUpInside)
        buttonView.addTarget(self, action: #selector(exitButtonTapOutside), for: .touchUpOutside)
        self.addSubview(buttonView)

        let stageNameView = UILabel(frame: stageNameCGRect)
        stageNameView.backgroundColor = UIColor.clear
        stageNameView.textAlignment = NSTextAlignment.center
        stageNameView.textColor = UIColor.black
        stageNameView.font = UIFont(name: "Futura-Medium", size: (ratioStageNameHeight * stageNameHeightPerRatio))
        let splitNumbers = (stageName.components(separatedBy: NSCharacterSet.decimalDigits.inverted))
        let number = splitNumbers.joined()
        let number2 = Int(number)
        if(true == testStage){
            stageNameView.text = "TEST"
        }else{
            stageNameView.text = "STAGE " + (number2?.description)!
        }
        self.addSubview(stageNameView)
        
        let imageText = UILabel(frame: imageTextCGRect)
        imageText.backgroundColor = UIColor.clear
        imageText.textAlignment = NSTextAlignment.left
        imageText.textColor = UIColor.black
        imageText.text = "あと"
        imageText.font = UIFont.systemFont(ofSize: floor(ratioImageTextHeight * imageHeightPerRatio))
        imageText.font = UIFont.boldSystemFont(ofSize: floor(ratioImageTextHeight * imageHeightPerRatio))
        self.addSubview(imageText)
        
        let imageView = UIImageView(frame: imageCGRect)
        let img = UIImage(named: "mouse01.png")!
        imageView.image = img
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        self.addSubview(imageView)

        mouseCountView.frame = mouseCountCGRect
        mouseCountView.backgroundColor = UIColor.clear
        mouseCountView.textAlignment = NSTextAlignment.left
        mouseCountView.textColor = UIColor.black
        mouseCountView.font = UIFont.systemFont(ofSize: floor(ratioMouseCountHeight * mouseCountHeightPerRatio))
        mouseCountView.font = UIFont.boldSystemFont(ofSize: floor(ratioMouseCountHeight * mouseCountHeightPerRatio))
        self.addSubview(mouseCountView)


    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    @objc func exitButtonTapInside(){
        delegate?.exitReq()
    }
    
    @objc func exitButtonTapOutside(){
        
    }
    
}
