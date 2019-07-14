//
//  StageSelectView.swift
//  Rescue_the_mouse
//
//  Created by yohei on 2018/08/16.
//  Copyright © 2018年 yamanyon. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StageSelectView: UIViewController,GADBannerViewDelegate,GameModeNextDelegate{

    struct stageSelectMap{
        var background: String
        var house: String
        var map: [[Int]]
        var btn: [[Int]]
    }
    
    let pieceV: Int = 11
    let pieceH: Int = 8
    var gameMode: GameMode?
    var pieceView: [[UIImageView]] = []
    var pieceImage: [UIImage] = []
    var stageSelectButton: [StageSelectButton] = []
    var stageFileName: String = ""
    var bannerView: GADBannerView = GADBannerView()
    var currentStageNumber: Int = 0
    var viewFrame = CGRect(x:0,y:0,width:0,height:0)
    var viewInfo: stageSelectMap = stageSelectMap(background: "", house: "", map: [], btn: [])
    var mapFileName: String = ""


    let stgBtnImg = UIImage(named:"stg_btn09.png")!
    let stgBtnTapImg = UIImage(named:"stg_btn08.png")!
    
//    let viewInfo: [stageSelectMap] = []
    /*
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
 */
    
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
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(frame: CGRect, mapFileName: String){
        self.init(nibName: nil, bundle: nil)
        viewFrame = frame
        self.mapFileName = mapFileName
        self.view.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPieceImage()
        loadMapFile()

        self.view.backgroundColor = UIColor.white
        // Screen Size の取得
        let screenWidth = self.viewFrame.width
        let screenHeight = self.viewFrame.height
        
        let backgroundView: UIImageView = UIImageView()
        
        backgroundView.frame = self.viewFrame
        backgroundView.image = UIImage(named: viewInfo.background)!
        
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)

        let pieceSizeX: CGFloat = screenWidth / CGFloat(pieceH)
        let pieceSizeY: CGFloat = screenHeight / CGFloat(pieceV + 1)
    
        let yOffset: CGFloat = pieceSizeY / 2
    
        for y in 0..<pieceV{
            pieceView.append([UIImageView]())
            for x in 0..<pieceH{
    
                pieceView[y].append(UIImageView(frame: CGRect(x: CGFloat(x)*pieceSizeX, y: CGFloat(y)*pieceSizeY+yOffset, width: pieceSizeX, height: pieceSizeY)))
                pieceView[y][x].image = pieceImage[viewInfo.map[y][x]]
                
                if(PieceType.HOUSE.rawValue <= viewInfo.map[y][x]){
                }else{}
                self.view.addSubview(pieceView[y][x])
                
                if(0 != viewInfo.btn[y][x]){
                
                    stageSelectButton.append(StageSelectButton(frame: pieceView[y][x].frame, num: viewInfo.btn[y][x]))
                    stageSelectButton[stageSelectButton.count - 1].contentMode = UIView.ContentMode.scaleAspectFit
                
                    stageSelectButton[stageSelectButton.count - 1].setImage(stgBtnImg, for: UIControl.State.normal)
                    stageSelectButton[stageSelectButton.count - 1].setImage(stgBtnTapImg, for: UIControl.State.highlighted)
                
                    stageSelectButton[stageSelectButton.count - 1].addTarget(self, action: #selector(stgBtnTapInside), for: UIControl.Event.touchUpInside)
                
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if("gameMode"==segue.identifier){
        
            gameMode = segue.destination as? GameMode
            gameMode!.stageFileName = stageFileName
            if(true == testStage){
                gameMode!.stageFileName = "stage_test"
            }
            gameMode!.delegate = self as GameModeNextDelegate
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
    
    func loadMapFile(){

        do {
            var dataList: [String]
            var dataListCnt: Int = 1
            //CSVファイルのパスを取得する。
            let csvPath = Bundle.main.path(forResource: self.mapFileName, ofType: "csv")
            //CSVファイルのデータを取得する。
            let csvData = try String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
            //改行区切りでデータを分割して配列に格納する。
            dataList = csvData.components(separatedBy: "\n")
                
            for _ in 0..<pieceV{
                let data = dataList[dataListCnt].replacingOccurrences(of: " ", with: "").components(separatedBy: ",").compactMap{ Int($0) }
                viewInfo.map.append(data)
                dataListCnt += 1
            }
            dataListCnt += 1
                
            for _ in 0..<pieceV{
                let data = dataList[dataListCnt].replacingOccurrences(of: " ", with: "").components(separatedBy: ",").compactMap{ Int($0) }
                viewInfo.btn.append(data)
                dataListCnt += 1
            }
                
            viewInfo.background = dataList[dataListCnt]
            dataListCnt += 1
                
            viewInfo.house = dataList[dataListCnt]

        } catch {
            print(error)
        }
        
    }

    @objc func stgBtnTapInside(sender: AnyObject){

        let obj = sender as! StageSelectButton
        currentStageNumber = obj.stageNumber
        cleateStage()
    }
    
    func cleateStage(){
        
        var numText: String
        
        if(currentStageNumber < 10){
            numText = "000" + String(currentStageNumber)
        }
        else if(currentStageNumber < 100){
            numText = "00" + String(currentStageNumber)
        }
        else if(currentStageNumber < 1000){
            numText = "0" + String(currentStageNumber)
        }
        else{
            numText = String(currentStageNumber)
        }
        
        stageFileName = "stage" + numText
        
        if(true == testStage){
            stageFileName = "stage_test"
        }

        //        NSLog("%d", obj.stageNumber)
        
        // self.performSegue(withIdentifier: "gameMode", sender: self)
        gameMode = GameMode()
        gameMode?.delegate = self
        gameMode?.stageFileName = stageFileName
        self.present(gameMode!, animated: true)

        

    }


    func reqGameModeNext(nextAction: Action) {
        
        switch nextAction {
        case .NEXT_STAGE:
            currentStageNumber += 1
            if(20 >= currentStageNumber){
                cleateStage()
            }
            break
        case .RETRY_STAGE:
            cleateStage()
            break
        default:
           break
        }
    }

    @IBAction func closeGameMode(segue: UIStoryboardSegue){}

}
