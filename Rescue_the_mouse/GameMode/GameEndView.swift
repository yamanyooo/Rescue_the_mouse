//
//  GameEndView.swift
//  NH_Takashi
//
//  Created by yohei on 2016/12/05.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation
import UIKit

protocol NextActionDelegate {
    func nextAction(action: Action)
}

enum Action{
    case STAGE_SELECT
    case NEXT_STAGE
    case RETRY_STAGE
    case CANCEL
}

enum GameEndMode{
    case CLEAR
    case FAILD
    case EXIT
}

enum ModeIndex: Int{
    
    case CLEAR = 0
    case FAILED = 1
    case END = 2
}

enum FileIndex: Int{
    
    case TEXT = 0
    case LEFT_BUTTEN = 1
    case LEFT_BUTTEN_TAP = 2
    case RIGHT_BUTTEN = 3
    case RIGHT_BUTTEN_TAP = 4
}

let fileName: [[String]] = [
    ["STAGE_CLEAR.png", "stage_select_button.png", "stage_select_button_tap.png",
        "next_stage_button.png", "next_stage_button_tap.png"],
    ["STAGE_FAILED.png", "stage_select_button.png", "stage_select_button_tap.png",
        "retry_button.png", "retry_button_tap.png"],
    ["GAME_END.png", "stage_select_button.png", "stage_select_button_tap.png",
        "cancel_button.png", "cancel_button_tap.png"]
]

let animationFile: [[String]] = [
    ["clear_mouse01.png", "clear_mouse02.png"],
    ["mouse_death01.png", "mouse_death02.png",
     "mouse_death03.png", "mouse_death04.png", "mouse_death05.png"/*"failed_mouse01.png", "failed_mouse02.png"*/],
    ["end_mouse01.png", "end_mouse02.png"]
]


class GameEndView: UIView, ButtonTapDelegate{
    
    var mode: GameEndMode
    var modeIndex: ModeIndex
    var loadFile: [UIImage] = []
    var loadAnimation: [UIImage] = []
    var animationTime: Double = 0.0
    var delegate: NextActionDelegate?
    
    init (frame: CGRect, gameEndMode: GameEndMode){
        
        var confetti: Bool = false
        mode = gameEndMode
        
        switch mode{
            case .CLEAR:
                modeIndex = ModeIndex.CLEAR
                animationTime = 2.0
                confetti = true
            break
            
            case .FAILD:
                modeIndex = ModeIndex.FAILED
                animationTime = 3.0
                confetti = false
            break
            
            case .EXIT:
                modeIndex = ModeIndex.END
                animationTime = 3.0
                confetti = false
            break
            
            default:
            break
        }
        
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.black
        
        loadImageFile()
        createView()
        
        if(true == confetti){
            createConfetti()
        }else{}

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }

    func loadImageFile(){
        
        for i in 0..<fileName[modeIndex.rawValue].count{
            loadFile.append(UIImage(named: fileName[modeIndex.rawValue][i])!)
        }
        
        for i in 0..<animationFile[modeIndex.rawValue].count{
            loadAnimation.append(UIImage(named: animationFile[modeIndex.rawValue][i])!)
        }
    }
    
    func createView(){
        
        let ratioMarginTopHeight: CGFloat = 3
        let ratioMarginObjheight: CGFloat = 2
        let ratioMarginBottomHeight: CGFloat = 2
        let ratioTextHeight: CGFloat = 3
        let ratioImageHeight: CGFloat = 10
        let ratioButtonHeight: CGFloat = 4
        let ratioSumHeight: CGFloat = ratioMarginTopHeight + ratioMarginObjheight*2 + ratioMarginBottomHeight + ratioTextHeight + ratioImageHeight + ratioButtonHeight
        let heightPerRatio: CGFloat = self.frame.height / ratioSumHeight
        
        let ratioMarginTextWidth: CGFloat = 1
        let ratioTextWidth: CGFloat = 30
        let ratioSumTextWidth: CGFloat = ratioMarginTextWidth*2 + ratioTextWidth
        let textWidthPerRatio: CGFloat = self.frame.width / ratioSumTextWidth
        
        let ratioMarginImageWidth: CGFloat = 2
        let ratioImageWidth: CGFloat = 8
        let ratioSumImageWidth: CGFloat = ratioMarginImageWidth*2 + ratioImageWidth
        let imageWidthPerRatio: CGFloat = self.frame.width / ratioSumImageWidth
        
        let ratioMarginButtonWidth: CGFloat = 2
        let ratioButtonWidth: CGFloat = 4
        let ratioBetweenWidth: CGFloat = 2
        let ratioSumButtonWidth: CGFloat = ratioMarginButtonWidth*2 + ratioButtonWidth*2 + ratioBetweenWidth
        let buttonWidthPerRatio: CGFloat = self.frame.width / ratioSumButtonWidth
        
        var height: CGFloat = ratioMarginTopHeight * heightPerRatio
        var width: CGFloat = ratioMarginTextWidth * textWidthPerRatio
        
        let textCGrect: CGRect = CGRect(x: width, y: height, width: ratioTextWidth * textWidthPerRatio, height: ratioTextHeight * heightPerRatio)
        
        height += (ratioTextHeight + ratioMarginObjheight) * heightPerRatio
        width = ratioMarginImageWidth * imageWidthPerRatio
        
        let imageCGrect = CGRect(x: width, y: height, width: ratioImageWidth * imageWidthPerRatio, height: ratioImageHeight * heightPerRatio)
        
        height += (ratioImageHeight + ratioMarginObjheight) * heightPerRatio
        width = ratioMarginButtonWidth * buttonWidthPerRatio
        
        let leftButtonCGrect = CGRect(x: width, y: height, width: ratioButtonWidth * buttonWidthPerRatio, height: ratioButtonHeight * heightPerRatio)
        
        width += (ratioBetweenWidth + ratioButtonWidth) * buttonWidthPerRatio
        
        let rightButtonCGrect = CGRect(x: width, y: height, width: ratioButtonWidth * buttonWidthPerRatio, height: ratioButtonHeight * heightPerRatio)
        
        //test
        let textView = UIImageView(frame: textCGrect)
//        textView.contentMode = UIViewContentMode.ScaleAspectFit
        textView.image = loadFile[FileIndex.TEXT.rawValue]
//        textView.backgroundColor = UIColor.greenColor()
        self.addSubview(textView)
        
        let imageView = UIImageView(frame: imageCGrect)
//        let img = UIImage(named: "mouse01.png")!
//        imageView.image = img
        imageView.animationImages = loadAnimation
        imageView.animationDuration = animationTime
        imageView.startAnimating()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
//        imageView.backgroundColor = UIColor.yellowColor()
        self.addSubview(imageView)
        
        let maskLeft = UIImage(named: "left_button_mask.png")!
        let leftButtonView = GameEndButton(frame: leftButtonCGrect, img: loadFile[FileIndex.LEFT_BUTTEN.rawValue], imgTap: loadFile[FileIndex.LEFT_BUTTEN_TAP.rawValue], imgMask: maskLeft, pos: ButtonPos.LEFT)
        leftButtonView.delegate = self
        self.addSubview(leftButtonView)
        
        let maskRight = UIImage(named: "right_button_mask.png")!
        let rightButtonView = GameEndButton(frame: rightButtonCGrect, img: loadFile[FileIndex.RIGHT_BUTTEN.rawValue], imgTap: loadFile[FileIndex.RIGHT_BUTTEN_TAP.rawValue], imgMask: maskRight, pos: ButtonPos.RIGHT)
        rightButtonView.delegate = self
        self.addSubview(rightButtonView)
        
    }

    func buttonTap(view: GameEndButton) {
        
        if(ButtonPos.LEFT == view.buttonPos){
            
            delegate?.nextAction(action: Action.STAGE_SELECT)
            
        }else{
            
            switch mode {
            case .CLEAR:
                delegate?.nextAction(action: Action.NEXT_STAGE)
                break
            case .FAILD:
                delegate?.nextAction(action: Action.RETRY_STAGE)
                break
            case .EXIT:
                delegate?.nextAction(action: Action.CANCEL)
                break
            default:
                break
            }
        }
    }
    
    func createConfetti(){
        
        var confettiImg: [UIImage] = []
        let imgFileNum = 11
        let fileName = "confetti"
        let fileExtension = ".png"
        
        for i in 1...imgFileNum{
            
            var fileNum: String
            
            fileNum = i < 10 ? "0" + String(i) : String(i)
            confettiImg.append(UIImage(named: fileName + fileNum + fileExtension)!)
        }
        
        
        let confettiView = UIImageView(frame: self.frame)
        confettiView.animationImages = confettiImg
        confettiView.animationDuration = 2
        confettiView.startAnimating()
        confettiView.backgroundColor = UIColor.clear
        confettiView.contentMode = UIView.ContentMode.scaleAspectFill
        self.addSubview(confettiView)
        self.sendSubviewToBack(confettiView)
        
/*
        var confettiViewLeft = UIImageView(frame: CGRectMake(0,0, self.frame.width, self.frame.height / 2))
        var confettiViewRight = UIImageView(frame: CGRectMake(0, self.frame.height / 2, self.frame.width, self.frame.height / 2))
        confettiViewLeft.animationImages = confettiImg
        confettiViewLeft.animationDuration = 3
        confettiViewLeft.startAnimating()
        confettiViewLeft.backgroundColor = UIColor.clearColor()
        self.addSubview(confettiViewLeft)
        
        confettiViewRight.animationImages = confettiImg
        confettiViewRight.animationDuration = 3
        confettiViewRight.startAnimating()
        confettiViewRight.backgroundColor = UIColor.clearColor()
        self.addSubview(confettiViewRight)
 */
    }
    
}
