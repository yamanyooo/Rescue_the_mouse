//
//  GameMode.swift
//  NH_Takashi
//
//  Created by yohei on 2016/08/16.
//  Copyright © 2016年 yohei. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol GameModeDelegate{
    func reqCloseGameModeMain()
}

struct ItemInfo{
    var itemId: Int
    var itemCnt: Int
}

class GameMode: UIViewController, GADBannerViewDelegate, InfoUsedItemDelegate, NextActionDelegate, ExitReqDelegate{
    
    var stageFileName: String = "NONE"
    var stageData: [[String]] = []
    var itemInfo: [ItemInfo] = []
    var headerView: GameModeHeader?
    var itemView: GameModeItem?
    var delegate: GameModeDelegate?
    var gameViewSize: CGRect?
    var gameEndView: GameEndView?
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        stageData.removeAll()
        itemInfo.removeAll()
        
        loadCsv()
        

        // 各描画パーツの縦幅比率の設定
        let ratioHeader = 2
        let ratioMain = 14
        let ratioItem = 3
        let ratioSum = ratioHeader + ratioMain + ratioItem
        
        // Screen Size の取得
        let statusbarHeight = UIApplication.shared.statusBarFrame.height
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height - statusbarHeight
        
        
        
        var mainHeight: Int
        var itemHeight: Int
        var headerHeight: Int
        var heightTemp = Int(statusbarHeight)
        heightTemp = 0
        

        // AdMob広告設定
        var bannerView: GADBannerView = GADBannerView()
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
        
        // ゲーム画面サイズを記憶
        gameViewSize = CGRect(x: 0, y: statusbarHeight, width: screenWidth, height: screenHeight - bannerView.frame.height)

        // 各描画パーツの縦幅の設定
        mainHeight = Int(screenHeight - bannerView.frame.height) * ratioMain / ratioSum
        itemHeight = Int(screenHeight - bannerView.frame.height) * ratioItem / ratioSum
        headerHeight = Int(screenHeight - bannerView.frame.height) - mainHeight - itemHeight

        // 各描画パーツのViewを作成
        let statusView = UIView(frame: CGRect(x: 0, y: CGFloat(heightTemp), width: screenWidth, height: CGFloat(statusbarHeight)))
        heightTemp += Int(statusbarHeight)
        statusView.backgroundColor = UIColor.white
        self.view.addSubview(statusView)
        
        headerView = GameModeHeader(frame: CGRect(x: 0, y: CGFloat(heightTemp), width: screenWidth, height: CGFloat(headerHeight)))
        headerView!.delegate = self
        heightTemp += headerHeight
        self.view.addSubview(headerView!)
        
        let mainView = GameModeMain(frame: CGRect(x: 0, y: CGFloat(heightTemp), width: screenWidth, height: CGFloat(mainHeight)), obj: stageData)
        mainView.delegate = self
        let temp = mainView.mouseCntExist
        mainView.mouseCntExist = temp
        heightTemp += mainHeight
        mainView.backgroundColor = UIColor.red
        self.view.addSubview(mainView)

        itemView = GameModeItem(frame: CGRect(x: 0, y: CGFloat(heightTemp), width: screenWidth, height: CGFloat(itemHeight)), itemInfo: itemInfo)
        heightTemp += itemHeight
        itemView!.backgroundColor = UIColor.yellow
        self.view.addSubview(itemView!)


//        self.performSegueWithIdentifier("GameModeClose", sender: self)
        // ゲームヘッダ情報
        
        // ゲームメイン部
        // 使用可能アイテム
    
        // イメージの描画
//        let stageView = StageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
//        stageView.backgroundColor = UIColor.clearColor()
//        self.view.addSubview(stageView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loadCsv(){
        
        var dataList: [String]
        
        do {
            //CSVファイルのパスを取得する。
            let csvPath = Bundle.main.path(forResource: self.stageFileName, ofType: "csv")
            
            //CSVファイルのデータを取得する。
            let csvData = try String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
            
            //改行区切りでデータを分割して配列に格納する。
            dataList = csvData.components(separatedBy: "\n")

            for line in 0..<v_tile{
                let temp: [String] = dataList[line].components(separatedBy: ",")
                stageData.append(temp)
            }
            for line in v_tile..<dataList.count{
                var temp: [String] = dataList[line].components(separatedBy: ",")
                if("" != temp[0]){
                    let id: Int = searchItemId(input: temp[0])
                    itemInfo.append(ItemInfo(itemId: id, itemCnt: Int(temp[1])!))
                }else{}
            }

        } catch {
            print(error)
        }
    }
    func searchItemId(input: String)->Int {
        var result: Int = -1
        
        for i in 0..<ItemIdx.count{
            if(ItemIdx[i] == input){
                result = i
            }else{}
        }
        return result
    }
    
    func getObjIndex() -> Int {
        
        var result: Int = ObjIndex.NONE.rawValue
        
        if(activeItemNone != self.itemView!.activeItem){
            if(0 < self.itemView!.itemView[self.itemView!.activeItem].itemCnt){
                result = self.itemView!.itemView[self.itemView!.activeItem].itemID + itemOffset
                
            }else{}
        }else{}
        
        return result
        
    }
    func reqUseItem() -> Int{
        
        var itemCntAll :Int = 0
        
        self.itemView!.itemView[self.itemView!.activeItem].itemCnt -= 1
        
        for i in 0..<self.itemInfo.count{
            itemCntAll += self.itemView!.itemView[i].itemCnt
        }
        return itemCntAll
    }
    
    func exitReq() {
        gameModeEnd(gameEnd: GameEnd.STAGE_EXIT)
    }
    
    func reqMouseCnt(cnt: Int) {
        headerView!.mouseCountView.text = "×"+String(cnt)
    }
    
    func gameModeEnd(gameEnd: GameEnd) {
        
/*        let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let screenWidth = self.view.bounds.width -
        let screenHeight = self.view.bounds.height - statusbarHeight
*/
        var mode: GameEndMode
        
        switch gameEnd {
        case .STAGE_CLEAR:
            mode = GameEndMode.CLEAR
            break
        case .STAGE_FAILED:
            mode = GameEndMode.FAILD
            break
        default:
            mode = GameEndMode.EXIT
            break
        }
        
        gameEndView = GameEndView(frame: gameViewSize!, gameEndMode: mode)
        gameEndView!.delegate = self
        
        self.view.addSubview(gameEndView!)
        
        if(GameEnd.STAGE_CLEAR == gameEnd){
            
        }else{}
        
//        self.performSegueWithIdentifier("GameModeClose", sender: self)
    }
    
    func nextAction(action: Action) {
        
        switch action {
        case .STAGE_SELECT:
            
            self.performSegue(withIdentifier: "GameModeClose", sender: self)
            
            break
            
        case .NEXT_STAGE:
            
            break
            
        case .RETRY_STAGE:
            
            let subviews = self.view.subviews
            
            for subview in subviews {
                subview.removeFromSuperview()
            }
            self.viewDidLoad()
            gameEndView!.removeFromSuperview()
            
            break
            
        case .CANCEL:
            
            gameEndView!.removeFromSuperview()
            
            break
            
        default:
            break
        }
    }
}
