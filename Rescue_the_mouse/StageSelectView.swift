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

    struct stageSelectMap{
        var background: String
        var map: [[Int]]
        var btn: [[Int]]
    }
    
    let pieceV: Int = 11
    let pieceH: Int = 8
//    var gameMode: GameMode?
    var pieceView: [[UIImageView]] = []
    var pieceImage: [UIImage] = []
    var stageSelectButton: [StageSelectButton] = []
    var stageFileName: String = ""
    var bannerView: GADBannerView = GADBannerView()

    let stgBtnImg = UIImage(named:"stg_btn09.png")!
    let stgBtnTapImg = UIImage(named:"stg_btn08.png")!
    
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
        loadPieceImage()
        createAdMobView()

        // Screen Size の取得
        let statusbarHeight = UIApplication.shared.statusBarFrame.height
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height - statusbarHeight - bannerView.frame.height
        let backgroundView: UIImageView = UIImageView()
        
        backgroundView.frame = CGRect(x: 0, y: statusbarHeight, width: screenWidth, height: screenHeight)
        backgroundView.image = UIImage(named: viewInfo[0].background)!
        
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)

        let pieceSizeX: CGFloat = screenWidth / CGFloat(pieceH)
        let pieceSizeY: CGFloat = screenHeight / CGFloat(pieceV + 1)
    
        let yOffset: CGFloat = pieceSizeY / 2
    
        for y in 0..<pieceV{
            pieceView.append([UIImageView]())
            for x in 0..<pieceH{
    
                pieceView[y].append(UIImageView(frame: CGRect(x: CGFloat(x)*pieceSizeX, y: CGFloat(y)*pieceSizeY+statusbarHeight+yOffset, width: pieceSizeX, height: pieceSizeY)))
                pieceView[y][x].image = pieceImage[viewInfo[0].map[y][x]]
                
                if(PieceType.HOUSE.rawValue <= viewInfo[0].map[y][x]){
                //    pieceView[y][x].frame = CGRectOffset(pieceView[y][x].frame, 0, pieceSizeY / 7)
                }else{}
                self.view.addSubview(pieceView[y][x])
                
                if(0 != viewInfo[0].btn[y][x]){
                
                    stageSelectButton.append(StageSelectButton(frame: pieceView[y][x].frame, num: viewInfo[0].btn[y][x]))
                    stageSelectButton[stageSelectButton.count - 1].contentMode = UIView.ContentMode.scaleAspectFit
                
                    stageSelectButton[stageSelectButton.count - 1].setImage(stgBtnImg, for: UIControl.State.normal)
                    stageSelectButton[stageSelectButton.count - 1].setImage(stgBtnTapImg, for: UIControl.State.highlighted)
                
                    stageSelectButton[stageSelectButton.count - 1].addTarget(self, action: "stgBtnTapInside:", for: .touchUpInside)
                
                self.view.addSubview(stageSelectButton[stageSelectButton.count - 1])
                
                
                }else{}
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if("gameMode"==segue.identifier){
        
            gameMode = segue.destinationViewController as! GameMode
            gameMode!.stageFileName = stageFileName
        //  gameMode!.stageFileName = "stage_test"
            gameMode!.delegate = self
        }
    }
*/
 
    func loadPieceImage(){
        
        for i in 0..<pieceFileName.count{
            if(PieceType.NONE.rawValue != i){
                pieceImage.append(UIImage(named: pieceFileName[i])!)
            }else{
                pieceImage.append(UIImage())
            }
        }
    }

    func stgBtnTapInside(sender: AnyObject){
        let obj = sender as! StageSelectButton
        var numText: String
        
        if(obj.stageNumber < 10){
            numText = "000" + String(obj.stageNumber)
        }
        else if(obj.stageNumber < 100){
            numText = "00" + String(obj.stageNumber)
        }
        else if(obj.stageNumber < 1000){
            numText = "0" + String(obj.stageNumber)
        }
        else{
            numText = String(obj.stageNumber)
        }
        
        stageFileName = "stage" + numText
        //        NSLog("%d", obj.stageNumber)
        
    //    self.performSegueWithIdentifier("gameMode", sender: self)
        
    }

    func createAdMobView(){
        // AdMob広告設定
        bannerView = GADBannerView(adSize:kGADAdSizeSmartBannerPortrait)
        bannerView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - bannerView.frame.height)
        bannerView.frame.size = CGSize(width: self.view.frame.width, height: bannerView.frame.height)
        // AdMobで発行された広告ユニットIDを設定
        bannerView.adUnitID = adUnitID
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
        
        
        // テスト用の広告を表示する時のみ使用（申請時に削除）
        switch targetInfo {
        case .SIMULATOR:
            // シミュレータ
            gadRequest.testDevices = [kGADSimulatorID]
            break
        case .YAMA_IPHONE:
            // yamada IPhone実機
            gadRequest.testDevices = [yamaID]
            break
        case .KUDO_IPHONE:
            // kudo IPhone実機
            gadRequest.testDevices = [kudoID]
            break
        default:
            break
        }
        
        bannerView.load(gadRequest)
        self.view.addSubview(bannerView)
    }

    func reqCloseGameModeMain() {
    //        self.dismissViewControllerAnimated(true, completion: nil)
    //        gameMode!.dismissViewControllerAnimated(true, completion: nil)
    }
        
}
