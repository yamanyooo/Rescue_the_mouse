//
//  ViewController.swift
//  Rescue_the_mouse
//
//  Created by yohei on 2018/08/14.
//  Copyright © 2018年 yamanyon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 各描画パーツの縦幅比率の設定
        let ratioMainHeight: CGFloat = 16
        let ratioBtnHeight: CGFloat = 3
        let ratioSpaceHeight: CGFloat = 1
        let ratioSumHeight: CGFloat = ratioMainHeight + ratioBtnHeight * 3 + ratioSpaceHeight * 5
        
        // 各描画パーツの横幅比率の設定
        let ratioBtnWidth: CGFloat = 8
        let ratioSpaceWidth:CGFloat = 1
        let ratioSumWidth: CGFloat = ratioBtnWidth + ratioSpaceWidth * 2

        // Screen Size の取得
        let statusbarHeight = UIApplication.shared.statusBarFrame.height
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height - statusbarHeight
        
        // 幅比率1当たりのサイズを算出
        let heightPerRatio: CGFloat = screenHeight / ratioSumHeight
        let widthPerRatio: CGFloat = screenWidth / ratioSumWidth

        // 各描画パーツの縦幅算出
        let mainHeight: CGFloat = ratioMainHeight * heightPerRatio
        let btnHeight: CGFloat = ratioBtnHeight * heightPerRatio
        let spaceHeight: CGFloat = ratioSpaceHeight * heightPerRatio

        // 各描画パーツの横幅算出
        let btnWidth: CGFloat = ratioBtnWidth * widthPerRatio
        let spaceWidth: CGFloat = ratioSpaceWidth * widthPerRatio

        // 描画用縦座標
        var heightTemp: CGFloat = statusbarHeight + ratioSpaceHeight * 2

        //TOPイメージ
        let topImage = UIImageView(frame: CGRect(x:spaceWidth/2, y:heightTemp, width:btnWidth + spaceWidth, height:mainHeight))
        topImage.image = UIImage(named:"top_image.png")
        topImage.contentMode = .scaleAspectFit
        self.view.addSubview(topImage)
        // 描画用縦座標
        heightTemp += mainHeight

        //ゲームスタートボタン
        let gameStartBtn = UIButton(frame: CGRect(x:spaceWidth, y:heightTemp, width:btnWidth, height:btnHeight))
        gameStartBtn.setImage(UIImage(named:"game_start.png"), for:.normal)
        gameStartBtn.imageView?.contentMode = .scaleAspectFit
        gameStartBtn.contentHorizontalAlignment = .fill
        gameStartBtn.contentVerticalAlignment = .fill
        gameStartBtn.addTarget(self, action: #selector(gameStartBtnTapInside), for: .touchUpInside)
        self.view.addSubview(gameStartBtn)

        // 描画用縦座標
        heightTemp += ( btnHeight + spaceHeight )
        
        //遊び方ボタン
        let howToBtn = UIButton(frame: CGRect(x:spaceWidth, y:heightTemp, width:btnWidth, height:btnHeight))
        howToBtn.setImage(UIImage(named:"how_to_play.png"), for:.normal)
        howToBtn.imageView?.contentMode = .scaleAspectFit
        howToBtn.contentHorizontalAlignment = .fill
        howToBtn.contentVerticalAlignment = .fill
        gameStartBtn.addTarget(self, action: #selector(howToPlayBtnTapInside), for: .touchUpInside)
        self.view.addSubview(howToBtn)

        // 描画用縦座標
        heightTemp += ( btnHeight + spaceHeight )

        //設定ボタン
        let configBtn = UIButton(frame: CGRect(x:spaceWidth, y:heightTemp, width:btnWidth, height:btnHeight))
        configBtn.setImage(UIImage(named:"configuration.png"), for:.normal)
        configBtn.imageView?.contentMode = .scaleAspectFit
        configBtn.contentHorizontalAlignment = .fill
        configBtn.contentVerticalAlignment = .fill
        gameStartBtn.addTarget(self, action: #selector(configurationBtnTapInside), for: .touchUpInside)
        self.view.addSubview(configBtn)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func gameStartBtnTapInside(){
        
//        self.performSegue(withIdentifier: "toStageSelectView", sender: self)
 //       let stageSelectPage = StageSelectPage()
 //       self.present(stageSelectPage, animated: false)
        let stageSelectMain = StageSelectMain()
        self.present(stageSelectMain, animated: false)
        
    }

    @objc func howToPlayBtnTapInside(){
        
    }
    
    @objc func configurationBtnTapInside(){
        
    }



}

