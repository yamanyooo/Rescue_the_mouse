//
//  StageSelectMain.swift
//  Rescue_the_mouse
//
//  Created by yohei on 2019/05/14.
//  Copyright © 2019年 yamanyon. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StageSelectMain: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView = GADBannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAdMobView()
        
        self.view.backgroundColor = UIColor.white
        // Screen Size の取得
        let statusbarHeight = UIApplication.shared.statusBarFrame.height
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height - statusbarHeight - bannerView.frame.height
        var stageSelectPage = StageSelectPage(frame: CGRect(x: 0, y: statusbarHeight, width: screenWidth, height: screenHeight))
//        stageSelectPage.view.frame = CGRect(x: 0, y: statusbarHeight, width: screenWidth, height: screenHeight)
        self.addChild(stageSelectPage)
        self.view.addSubview(stageSelectPage.view!)
        stageSelectPage.didMove(toParent: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        case .KUMI_IPHONE:
            // kumi IPhone実機
            gadRequest.testDevices = [kumiID]
            break
        default:
            break
        }
        
        bannerView.load(gadRequest)
        self.view.addSubview(bannerView)
    }

}
