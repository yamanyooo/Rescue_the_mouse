//
//  GameModeMain.swift
//  NH_Takashi
//
//  Created by yohei on 2016/10/12.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation
import UIKit

protocol InfoUsedItemDelegate{
    func getObjIndex()->Int
    func reqUseItem()
    func reqMouseCnt(cnt: Int)
    func gameModeEnd(gameEnd: GameEnd)
}

enum GameEnd{
    
    case STAGE_CLEAR
    case STAGE_FAILED
    case STAGE_EXIT
}

class ObjInfo{
    
    var view: ObjView
    var mouse: ObjMouse
    
    init(argView: ObjView, argMouse: ObjMouse){
        
        view = argView
        mouse = argMouse
    }
}

let h_tile = 7
let v_tile = 8


class GameModeMain: UIView, TouchActionDelegate, ObjDataDelegate, CAAnimationDelegate {
    
    var tileView = [[TileView]]()
    var objView = [[ObjView]]()
    var gameObj: [[String]] = []
    var diff: [[Bool]] = []
    var objMouse: [ObjMouse] = []
    var objCat: [ObjCat] = []
    var loadObjImg: [UIImage] = []
    var loadAnimationImg: [[UIImage]] = []
    var timer = Timer()
    var resultCatAndMouseContact: Bool = false
    var mouseCntExist: Int = 0{
        didSet{
            delegate?.reqMouseCnt(cnt: mouseCntExist)
        }
    }
    var delegate: InfoUsedItemDelegate?

    
    init(frame: CGRect, obj: [[String]]) {

        super.init(frame: frame)
        
        loadImg()
        
        drawTile()
        
        gameObj = obj
        drawObj()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    func loadImg(){
        
        for i in 0..<objFileName.count{
            if("none" == objFileName[i]){
                loadObjImg.append(UIImage())
            }else{
                loadObjImg.append(UIImage(named: objFileName[i])!)
            }
        }
        
        for ptn in 0..<AnimationPtn.PTN_END.rawValue{
            loadAnimationImg.append([UIImage]())
            for num in 0..<animationFileName[ptn].count{
                if(AnimationPtn.NONE.rawValue == ptn){
                    loadAnimationImg[ptn].append(UIImage())
                }
                else{
                    loadAnimationImg[ptn].append(UIImage(named: animationFileName[ptn][num])!)
                }
            }
        }
    }
    
    // タイル描画処理
    func drawTile(){
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = self.frame.size.width / 200
        
        let h_tileSize = Int(self.frame.size.width) / h_tile
        let v_tileSize = Int(self.frame.size.height) / v_tile
        let h_tileAdjNum = Int(self.frame.size.width) % h_tile
        let v_tileAdjNum = Int(self.frame.size.height) % v_tile
        var h_tileAdjSize, v_tileAdjSize: Int
        var xPoint: CGFloat = 0
        var yPoint: CGFloat = 0
        
        for y in 0..<v_tile{
            
            tileView.append([TileView]())
            objView.append([ObjView]())
            diff.append([Bool]())
            
            v_tileAdjSize = v_tileAdjNum > y ? 1 : 0
            xPoint = 0
            
            for x in 0..<h_tile{
                
                h_tileAdjSize = h_tileAdjNum > x ? 1 : 0
                
                tileView[y].append(TileView(frame: CGRect(x: xPoint, y: yPoint , width: CGFloat(h_tileSize + h_tileAdjSize), height: CGFloat(v_tileSize + v_tileAdjSize))))
                objView[y].append(ObjView(frame:  CGRect(x: xPoint, y: yPoint , width: CGFloat(h_tileSize + h_tileAdjSize), height: CGFloat(v_tileSize + v_tileAdjSize)), x: x, y: y))
                diff[y].append(Bool(false))
                objView[y][x].contentMode = UIView.ContentMode.scaleAspectFit
                tileView[y][x].setColler(x: x, y: y)
                tileView[y][x].tilePosX = x
                tileView[y][x].tilePosY = y
                
                self.addSubview(tileView[y][x])
                self.addSubview(objView[y][x])
                tileView[y][x].delegate = self
                
                xPoint += CGFloat(h_tileSize + h_tileAdjSize)
            }
            xPoint = 0
            yPoint += CGFloat(v_tileSize + v_tileAdjSize)
        }
    }

    // オブジェクト描画処理
    func drawObj(){
        
        var mouseCnt: Int = 0
        var catCnt: Int = 0
        
        for y in 0..<v_tile{
            for x in 0..<h_tile{
                
                let imgNo = Int(gameObj[y][x])
                
                if(ObjIndex.NONE.rawValue != imgNo){
                    objView[y][x].image = loadObjImg[imgNo!]
                }else{}
                
                if(ObjIndex.MOUSE.rawValue == imgNo){
                    objMouse.append(ObjMouse(x: x, y: y))
                    objMouse[mouseCnt].delegate = self
                    mouseCnt += 1
                }else if(ObjIndex.CAT.rawValue == imgNo){
                    objCat.append(ObjCat(x: x, y: y))
                    objCat[catCnt].delegate = self
                    catCnt += 1
                }else{}
            }
        }
        mouseCntExist = mouseCnt
    }
    
    // タイルタップ時デリゲート処理
    func touchTileEvent(tile: TileView) {
        
        let objIndex: Int = (self.delegate?.getObjIndex())!
        
        if(ObjIndex.NONE.rawValue == Int(gameObj[tile.tilePosY][tile.tilePosX])){
            
            
            if( (ObjIndex.NONE.rawValue != objIndex)
             && (ObjIndex.BOMB.rawValue != objIndex)){
                // アイテム配置成立
                gameObj[tile.tilePosY][tile.tilePosX] = String(objIndex)
                objView[tile.tilePosY][tile.tilePosX].image = loadObjImg[objIndex]
                delegate?.reqUseItem()
                // 1ターンカウント
                turnStart(tile: tile)
                
            }else{}

        }else if((ObjIndex.WALL.rawValue == Int(gameObj[tile.tilePosY][tile.tilePosX]))
              && (ObjIndex.BOMB.rawValue == objIndex)){
            
            gameObj[tile.tilePosY][tile.tilePosX] = String(ObjIndex.NONE.rawValue)
            objView[tile.tilePosY][tile.tilePosX].image = nil
            delegate?.reqUseItem()
            
            animationExe(x: tile.tilePosX, y: tile.tilePosY, ptn: AnimationPtn.USE_BOMB)

            
        }else{}
    }
    
    func turnStart(tile: TileView){
        
        for y in 0..<v_tile{
            for x in 0..<h_tile{
                if( (tile.tilePosY != y)
                    || (tile.tilePosX != x)){
                    if( (ObjIndex.NOODLE_0MIN.rawValue == Int(gameObj[y][x]))
                        || (ObjIndex.NOODLE_1MIN.rawValue == Int(gameObj[y][x]))
                        || (ObjIndex.NOODLE_2MIN.rawValue == Int(gameObj[y][x]))){
                        gameObj[y][x] = String(Int(gameObj[y][x])! + 1)
                        objView[y][x].image = loadObjImg[Int(gameObj[y][x])!]
                    }else{}
                }else{}
            }
        }
        
        self.isUserInteractionEnabled = false
        
        // 目標探索処理
        objTargetSearch(obj: objMouse)
        objTargetSearch(obj: objCat)
        // アクション処理
        objAction()
    }
    
    // オブジェクトデータ公開処理
    func getObjData(x: Int, y: Int) -> Int {
        return Int(self.gameObj[y][x])!
    }
    
    // ターゲット探索処理
    func objTargetSearch(obj: [ObjMouse]){
        
        var resultDistance: Int
        var wallDetection: Bool
        var wallDetectionTemp: Bool
        var target: Bool
        var distance: Int
        
        for i in 0..<obj.count{
            
            if( (Direction.NONE != obj[i].targetDirection)
             && (Status.WAIT_ACTION == obj[i].status)){
                
                var dust: Bool
                (dust, target, distance) = obj[i].objTargetSearch(direction: obj[i].targetDirection, distance: 0, wallDetection: false)
                if(true == target){
                    obj[i].setTarget(direction: obj[i].targetDirection, distance: distance)
                }else{
                    obj[i].status = Status.STOP
                }
                
            }else if(Status.NOEXIST != obj[i].status){
                
                resultDistance = 0xFFFF
                wallDetection = true
                
                for dir in [Direction.UP, Direction.DOWN, Direction.LEFT, Direction.RIGHT]{
                    
                    (wallDetectionTemp, target, distance) = obj[i].objTargetSearch(direction: dir, distance: 0, wallDetection: false)
                    
                    if(false == wallDetection){
                    
                        if( (true == target)
                         && (false == wallDetectionTemp)
                         && (resultDistance > distance)){
                            
                            resultDistance = distance
                            obj[i].setTarget(direction: dir, distance: distance)
                        }else{}
                    }else{
                        
                        if( (true == target)
                         && (false == wallDetectionTemp)){
                            
                            wallDetection = false
                            resultDistance = distance
                            obj[i].setTarget(direction: dir, distance: distance)
                        }else if((true == target)
                              && (resultDistance > distance)){
                            
                            resultDistance = distance
                            obj[i].setTarget(direction: dir, distance: distance)
                        }else{}
                    }
                }
            }else{}
        }
    }
    
    func objAction(){
        
        for y in 0..<diff.count{
            for x in 0..<diff[y].count{
                diff[y][x] = false
            }
        }

        for i in 0..<objMouse.count{
            
            objActionExe(obj: objMouse[i])
            if(Status.ACTION == objMouse[i].status){
                diff[objMouse[i].yPointNext][objMouse[i].xPointNext] = true
            }else{}
        }
        
        for i in 0..<objCat.count{
            
            objActionExe(obj: objCat[i])
            if(Status.ACTION == objCat[i].status){
                diff[objCat[i].yPointNext][objCat[i].xPointNext] = true
            }else{}
        }
    }
    
    func objActionExe(obj: ObjMouse){
        
        let tileWidth = Int(objView[0][0].frame.width)
        let tileHeight = Int(objView[0][0].frame.height)
        let x: Int = obj.xPoint
        let y: Int = obj.yPoint
        
        if(Status.WAIT_ACTION == obj.status){
            
            var key: String = ""
            var moveX: Int = 0
            var moveY: Int = 0
            var ptn: AnimationPtn = AnimationPtn.PTN_END
            
            switch obj.targetDirection {
            case .UP:
                key = "position.y"
                moveY -= tileHeight
                ptn = type(of: obj) == ObjMouse.self ? AnimationPtn.MOUSE_UP : AnimationPtn.CAT_UP
                obj.yPointNext = y - 1
                break
            case .DOWN:
                key = "position.y"
                moveY += tileHeight
                ptn = type(of: obj) == ObjMouse.self ? AnimationPtn.MOUSE_DOWN : AnimationPtn.CAT_DOWN
                obj.yPointNext = y + 1
                break
            case .LEFT:
                key = "position.x"
                moveX -= tileWidth
                ptn = type(of: obj) == ObjMouse.self ? AnimationPtn.MOUSE_LEFT : AnimationPtn.CAT_LEFT
                obj.xPointNext = x - 1
                break
            case .RIGHT:
                key = "position.x"
                moveX += tileWidth
                ptn = type(of: obj) == ObjMouse.self ? AnimationPtn.MOUSE_RIGHT : AnimationPtn.CAT_RIGHT
                obj.xPointNext = x + 1
                break
            default:
                break
            }
            obj.setNextTileInfo()
            if(DestinationInfo.WALL == obj.destination){
                obj.status = Status.STOP
                obj.xPointNext = x
                obj.yPointNext = y
                
            }else{
                self.bringSubviewToFront(objView[y][x])
                objView[y][x].animationImages = loadAnimationImg[ptn.rawValue]
                objView[y][x].animationDuration = 0.5
//                objView[y][x].animationRepeatCount = 1
                objView[y][x].startAnimating()
            
                let moveAnimation = CABasicAnimation(keyPath: key)
                if("position.y" == key){
                    moveAnimation.toValue = objView[y][x].layer.position.y + CGFloat(moveY)
                }else{
                    moveAnimation.toValue = objView[y][x].layer.position.x + CGFloat(moveX)
                }
                moveAnimation.duration = 0.4
                moveAnimation.delegate = self
                moveAnimation.setValue(obj, forKey: "obj")
                moveAnimation.fillMode = CAMediaTimingFillMode.forwards
                moveAnimation.isRemovedOnCompletion = false
                objView[y][x].layer.add(moveAnimation, forKey: key)
                obj.status = Status.ACTION
                objView[y][x].animation = true
            }
        }else{}
        
        let stop = judgeActionStop()
        if(true == stop){
            self.isUserInteractionEnabled = true
        }else{}
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        let obj = anim.value(forKey: "obj") as? ObjMouse
        anim.setValue(nil, forKey: "obj")
        
        let x: Int = obj!.xPoint
        let y: Int = obj!.yPoint
        let xNext = obj!.xPointNext
        let yNext = obj!.yPointNext
        
        objView[y][x].stopAnimating()
        objView[y][x].layer.removeAllAnimations()
        objView[y][x].animation = false
        
        if(false == resultCatAndMouseContact){
            resultCatAndMouseContact = judgeCatAndMouseContact()
        }else{
            return
        }

        switch obj!.destination {
            
        case .NONE:
            objView[yNext][xNext].image = objView[y][x].image
            objView[yNext][xNext].text.text = objView[y][x].text.text
            gameObj[yNext][xNext] = gameObj[y][x]
            
            if(false == diff[y][x]){
                
                objView[y][x].image = nil
                objView[y][x].text.text = ""
                gameObj[y][x] = String(ObjIndex.NONE.rawValue)
            }else{}
            obj!.xPoint = obj!.xPointNext
            obj!.yPoint = obj!.yPointNext

            obj!.status = Status.WAIT_ACTION
            obj!.statusAfterAnimation = Status.STOP
            
            if(false == resultCatAndMouseContact){
                tskTurnEnd()
            }
            
            break
            
        case .HOLE:
            
            if(false == diff[y][x]){
                objView[y][x].image = nil
                objView[y][x].text.text = ""
                gameObj[y][x] = String(ObjIndex.NONE.rawValue)
            }
            obj?.statusAfterAnimation = Status.NOEXIST
            animationExe(x: xNext, y: yNext, ptn: AnimationPtn.HOLE, obj: obj!)
            break
            
        case .FOOD_TOY:

            let ptn = judeAnimationPtn(obj: obj!)
            
            objView[yNext][xNext].image = objView[y][x].image
            objView[yNext][xNext].text.text = objView[y][x].text.text
            gameObj[yNext][xNext] = gameObj[y][x]
            
            if(false == diff[y][x]){
                objView[y][x].image = nil
                objView[y][x].text.text = ""
                gameObj[y][x] = String(ObjIndex.NONE.rawValue)
            }else{}
            obj!.xPoint = obj!.xPointNext
            obj!.yPoint = obj!.yPointNext

            obj!.statusAfterAnimation = Status.STOP
            animationExe(x: xNext, y: yNext, ptn: ptn, obj: obj!)

            break
            
        case .TRAP:
            let ptn = type(of: obj!) == ObjMouse.self ? AnimationPtn.MOUSE_TRAP : AnimationPtn.CAT_TRAP
            
//            objView[yNext][xNext].image = objView[y][x].image
            
            if(type(of: obj!) == ObjMouse.self){
                objView[y][x].image = nil
                objView[yNext][xNext].image = nil
                objView[yNext][xNext].text.text = ""
                gameObj[yNext][xNext] = String(ObjIndex.NONE.rawValue)
            }else{
                objView[yNext][xNext].image = objView[y][x].image
                objView[yNext][xNext].text.text = objView[y][x].text.text
                gameObj[yNext][xNext] = gameObj[y][x]
            }
            if(false == diff[y][x]){
                objView[y][x].image = nil
                objView[y][x].text.text = ""
                gameObj[y][x] = String(ObjIndex.NONE.rawValue)
            }else{}
            obj!.xPoint = obj!.xPointNext
            obj!.yPoint = obj!.yPointNext
            obj?.statusAfterAnimation = Status.DEATH
            animationExe(x: xNext, y: yNext, ptn: ptn, obj: obj!)
            
            break
            
        default:
/*            objView[yNext][xNext].image = objView[y][x].image
            gameObj[yNext][xNext] = gameObj[y][x]
            
            if(false == diff[y][x]){
                
                objView[y][x].image = nil
                gameObj[y][x] = String(ObjIndex.NONE.rawValue)
            }else{}
            obj!.xPoint = obj!.xPointNext
            obj!.yPoint = obj!.yPointNext
*/
            break
 
        }

    }
    
    func judeAnimationPtn(obj: ObjMouse)->(AnimationPtn){
        
        var result: AnimationPtn = AnimationPtn.NONE
        let x = obj.xPointNext
        let y = obj.yPointNext
        let judge: ObjIndex = ObjIndex(rawValue: Int(gameObj[y][x])!)!
        
        switch judge {
        case .CHEESE:
            result = type(of: obj) == ObjMouse.self ? AnimationPtn.MOUSE_CHEEZE : AnimationPtn.CAT_CHEEZE
            break
        case .SALAMI:
            result = type(of: obj) == ObjMouse.self ? AnimationPtn.MOUSE_SALAMI : AnimationPtn.CAT_SALAMI
            break
        case .NOODLE_3MIN:
            result = type(of: obj) == ObjMouse.self ? AnimationPtn.MOUSE_NOODLE : AnimationPtn.CAT_NOODLE
            break
        case .SETARIA:
            result = AnimationPtn.CAT_SETARIA
            break
        case .MOUSE_TORAP:
            result = type(of: obj) == ObjMouse.self ? AnimationPtn.MOUSE_TRAP : AnimationPtn.CAT_TRAP
            break
        default:
            break
        }
        return result
    }
    
    func judgeActionDone()->(Bool){
        
        var result: Bool = true
        
        for i in 0..<objMouse.count{
            
            if(Status.ACTION == objMouse[i].status){
                result = false
            }else{}
        }
        
        for i in 0..<objCat.count{
            
            if(Status.ACTION == objCat[i].status){
                result = false
            }else{}
        }
        
        return result
    }
    
    func judgeActionStop()->(Bool){
        var result: Bool = true
        
        for i in 0..<objMouse.count{
            
            if( (Status.STOP != objMouse[i].status)
             && (Status.NOEXIST != objMouse[i].status)){
                result = false
            }else{}
        }
        
        for i in 0..<objCat.count{
            
            if( (Status.STOP != objCat[i].status)
                && (Status.NOEXIST != objCat[i].status)){
                result = false
            }else{}
        }
        
        return result
    }
    
    func judgeCatAndMouseContact()->(Bool){
        
        var result: Bool = false
        
        for catNum in 0..<objCat.count{
            
            for mouseNum in 0..<objMouse.count{
                
                if( (Status.NOEXIST != objCat[catNum].status)
                 && (Status.DEATH != objCat[catNum].status)
                 && (Status.NOEXIST != objMouse[mouseNum].status)
                 && (Status.DEATH != objMouse[mouseNum].status)
                 && (objCat[catNum].xPointNext == objMouse[mouseNum].xPointNext)
                 && (objCat[catNum].yPointNext == objMouse[mouseNum].yPointNext)
                 && (ObjIndex.HOLE.rawValue != Int(gameObj[objCat[catNum].yPointNext][objCat[catNum].xPointNext]))){
                    
                    if(true == objView[objMouse[mouseNum].yPoint][objMouse[mouseNum].xPoint].animation){
                        objView[objMouse[mouseNum].yPoint][objMouse[mouseNum].xPoint].stopAnimating()
                        objView[objMouse[mouseNum].yPoint][objMouse[mouseNum].xPoint].animation = false
                    }else{}

                    objView[objMouse[mouseNum].yPoint][objMouse[mouseNum].xPoint].image = nil
                    objView[objMouse[mouseNum].yPoint][objMouse[mouseNum].xPoint].text.text = ""
                    objView[objCat[catNum].yPoint][objCat[catNum].xPoint].text.text = ""
                    objView[objMouse[mouseNum].yPointNext][objMouse[mouseNum].xPointNext].image = nil
                    animationExe(x: objMouse[mouseNum].xPointNext, y: objMouse[mouseNum].yPointNext, ptn: AnimationPtn.CAT_MOUSE, obj: objMouse[mouseNum])
                    objMouse[mouseNum].statusAfterAnimation = Status.DEATH
                    result = true
                    
                }else{}
            }
        }
        
        return (result)
    }
    
    func judgeCollision(obj: [ObjMouse]){
        for i in 0..<obj.count{
            for j in i..<obj.count{
                
                if( (i != j)
                 && (Status.NOEXIST != obj[i].status)
                 && (Status.DEATH != obj[i].status)
                 && (Status.NOEXIST != obj[j].status)
                 && (Status.DEATH != obj[j].status)
                 && (obj[i].xPoint == obj[j].xPoint)
                 && (obj[i].yPoint == obj[j].yPoint)){
                    
                    obj[i].objCnt += obj[j].objCnt
                    obj[j].status = Status.NOEXIST

                    
                }else{}
            }
        }
    }
    
    func setCollisionLabel(){
        
        for y in 0..<v_tile{
            for x in 0..<h_tile{
                objView[y][x].text.text = ""
            }
        }
        
        for i in 0..<objMouse.count{
            if( (1 < objMouse[i].objCnt)
             && ( Status.NOEXIST != objMouse[i].status)
             && ( Status.DEATH != objMouse[i].status)){
                objView[objMouse[i].yPoint][objMouse[i].xPoint].text.text = "×" + String(objMouse[i].objCnt)
            }else{}
        }
        for i in 0..<objCat.count{
            if( (1 < objCat[i].objCnt)
             && ( Status.NOEXIST != objCat[i].status)
             && ( Status.DEATH != objCat[i].status)){
                objView[objCat[i].yPoint][objCat[i].xPoint].text.text = "×" + String(objCat[i].objCnt)
            }else{}
        }
    }

    // bomb
    func animationExe(x: Int, y: Int, ptn: AnimationPtn){

        self.objView[y][x].animationImages = self.loadAnimationImg[ptn.rawValue]
        self.objView[y][x].animationDuration = 1
        self.objView[y][x].animationRepeatCount = 1
        self.objView[y][x].startAnimating()

        timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(animationEnd_Bomb), userInfo: objView[y][x], repeats: false)

    }
    
    
    func animationExe(x: Int, y: Int, ptn: AnimationPtn, obj: ObjMouse){
        
        if(objView[y][x].animation == false){
            
            self.objView[y][x].animationImages = self.loadAnimationImg[ptn.rawValue]
            self.objView[y][x].animationDuration = 1.3
            self.objView[y][x].animationRepeatCount = 1
            self.objView[y][x].startAnimating()
            
            objView[y][x].animation = true
            
            let info = ObjInfo(argView: objView[y][x], argMouse: obj)
            
            timer = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(animationEnd_Food_Toy_Hole), userInfo: info, repeats: false)
        }
        else if(AnimationPtn.HOLE == ptn){
            obj.status = Status.NOEXIST
            obj.statusAfterAnimation = Status.STOP
        }
        else{
            obj.status = Status.STOP
            obj.statusAfterAnimation = Status.STOP
        }
    }
    
    @objc func animationEnd_Bomb(sender: Timer){

        let userInfo = sender.userInfo as? ObjView
        userInfo?.stopAnimating()
        
        turnStart(tile: tileView[(userInfo?.pointY)!][(userInfo?.pointX)!])

    }
    
    @objc func animationEnd_Food_Toy_Hole(sender: Timer){
        
        let userInfo = sender.userInfo as? ObjInfo
        let obj = userInfo!
        obj.view.stopAnimating()
        obj.view.animation = false
        if(Status.DEATH == obj.mouse.statusAfterAnimation){
            
            obj.view.animationImages = loadAnimationImg[AnimationPtn.Mouse_DEATH.rawValue]
            obj.view.animationDuration = 2
            obj.view.animationRepeatCount = 1
            obj.view.startAnimating()

            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(animationEndDelay), userInfo: obj.mouse, repeats: false)

        }
        else{
            obj.mouse.status = obj.mouse.statusAfterAnimation
            obj.mouse.statusAfterAnimation = Status.STOP
            tskTurnEnd()
        }
    }
    
    @objc func animationEndDelay(sender: Timer){
        
        let userInfo = sender.userInfo as? ObjMouse
        let obj = userInfo!

        obj.status = obj.statusAfterAnimation
        obj.statusAfterAnimation = Status.STOP

    }
    
//    func animationEnd_Trap_MouseAndCat(sender: NSTimer){
//    }
    
    func tskTurnEnd(){
        
        let actionDone = judgeActionDone()
        
        if( true == actionDone){
            
            judgeCollision(obj: objMouse)
            judgeCollision(obj: objCat)
            
            setCollisionLabel()
            
            // 目標探索処理
            objTargetSearch(obj: objMouse)
            objTargetSearch(obj: objCat)
            // アクション処理
            objAction()
        }else{}

    }
    
    func notifyMouseNoexist() {
        
        var result: Bool = true
        var mouseCnt: Int = 0
        
        for i in 0..<objCat.count{
            if(Status.NOEXIST == objCat[i].status){
                notifyMouseDeath()
            }else{}
        }
        
        
        for i in 0..<objMouse.count{
            
            if(Status.NOEXIST != objMouse[i].status){
                result = false
                mouseCnt += objMouse[i].objCnt
            }else{}
        }
        
        mouseCntExist = mouseCnt
        
        if(true == result){
            // ステージクリア
            self.delegate?.gameModeEnd(gameEnd: GameEnd.STAGE_CLEAR)
        }else{}
    }
    func notifyMouseDeath() {
        // ステージ失敗
        self.delegate?.gameModeEnd(gameEnd: GameEnd.STAGE_FAILED)
    }
}
