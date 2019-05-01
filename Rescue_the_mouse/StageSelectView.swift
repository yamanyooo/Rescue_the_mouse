//
//  StageSelectView.swift
//  Rescue_the_mouse
//
//  Created by yohei on 2018/08/16.
//  Copyright © 2018年 yamanyon. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StageSelectView: UIViewController,GADBannerViewDelegate{
    
    let pieceV: Int = 11
    let pieceH: Int = 8
    var bannerView: GADBannerView = GADBannerView()
    
    struct stageSelectMap{
        var background: String
        var map: [[Int]]
        var btn: [[Int]]
    }
    
    let viewInfo: [stageSelectMap] = [
        stageSelectMap(
            background: "grass.jpg",
            map:
            [[0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0,10,10,10,10, 0, 0],
             [0, 6, 1, 1, 1, 1, 4, 0],
             [0, 2,10,10,10,10, 2, 0],
             [0, 9, 1, 1, 1, 1, 8, 0],
             [0, 2,10,10,10,10, 2, 0],
             [1, 7, 1, 1, 1, 1, 7, 1],
             [0, 2,10,10,10,10, 2, 0],
             [0, 9, 1, 1, 1, 1, 8, 0],
             [0, 2,10,10,10,10, 2, 0],
             [0, 5, 1, 1, 1, 1, 3, 0]],
            btn:
            [[0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0, 1, 2, 3, 4, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0, 5, 6, 7, 8, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0, 9,10,11,12, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0,13,14,15,16, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0,17,18,19,20, 0, 0]]),
        stageSelectMap(
            background: "grass.jpg",
            map:
            [[0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0,10,10,10,10, 0, 0],
             [0, 6, 1, 1, 1, 1, 4, 0],
             [0, 2,10,10,10,10, 2, 0],
             [0, 9, 1, 1, 1, 1, 8, 0],
             [0, 2,10,10,10,10, 2, 0],
             [1, 7, 1, 1, 1, 1, 7, 1],
             [0, 2,10,10,10,10, 2, 0],
             [0, 9, 1, 1, 1, 1, 8, 0],
             [0, 2,10,10,10,10, 2, 0],
             [0, 5, 1, 1, 1, 1, 3, 0]],
            btn:
            [[0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0,21,22,23,24, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0,25,26,27,28, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0,29,30,31,32, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0,33,34,35,36, 0, 0],
             [0, 0, 0, 0, 0, 0, 0, 0],
             [0, 0,37,38,39,40, 0, 0]])]
    
    enum PieceType: Int{
        case NONE = 0
        case STRAIGHT_LR = 1
        case STRAIGHT_UD = 2
        case CURVE_LU = 3
        case CURVE_LD = 4
        case CURVE_RU = 5
        case CURVE_RD = 6
        case CROSS = 7
        case JUNCTION_LUD = 8
        case JUNCTION_RUD = 9
        case HOUSE = 10
    }
    
    let pieceFileName: [String] = ["none",
                                   "straightLR.png",
                                   "straightUD.png",
                                   "curveLU.png",
                                   "curveLD.png",
                                   "curveRU.png",
                                   "curveRD.png",
                                   "cross.png",
                                   "junctionLUD.png",
                                   "junctionRUD.png" ,
                                   "house01.png"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Screen Size の取得
        let statusbarHeight = UIApplication.shared.statusBarFrame.height
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height - statusbarHeight - bannerView.frame.height
        var backgroundView: UIImageView = UIImageView()
        
        backgroundView.frame = CGRect(x: 0, y: statusbarHeight, width: screenWidth, height: screenHeight)
        backgroundView.image = UIImage(named: viewInfo[0].background)!
        
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
        for y in 0..<pieceV{
            for x in 0..<pieceH{
            }
        }
    }
    
}
