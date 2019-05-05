//
//  ObjMouse.swift
//  NH_Takashi
//
//  Created by yohei on 2016/11/12.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation

protocol ObjDataDelegate{
    func getObjData(x: Int, y: Int)->Int
    func notifyMouseDeath()
    func notifyMouseNoexist()
}

enum Status: Int {
    case NOEXIST = 0
    case STOP
    case WAIT_ACTION
    case ACTION
    case DEATH
}

enum Direction: Int {
    case NONE = 0
    case UP = 1
    case DOWN = 2
    case RIGHT = 3
    case LEFT = 4
}

enum ObjTarget{
    case NONE
    case TARGET
    case WALL
}

enum DestinationInfo: Int{
    case NONE = 0
    case WALL
    case HOLE
    case FOOD_TOY
    case TRAP
}

class ObjMouse: NSObject{
    
    var xPoint: Int
    var yPoint: Int
    var xPointNext: Int
    var yPointNext: Int
    var destination: DestinationInfo
    var status: Status{
        didSet{
            changeStatus()
        }
    }
    var statusAfterAnimation: Status
    var targetDirection: Direction
    var targetDistance: Int
    var objCnt: Int
    var delegate: ObjDataDelegate?
    
    init(x: Int, y: Int) {
        
        xPoint = x
        yPoint = y
        xPointNext = x
        yPointNext = y
        destination = DestinationInfo.NONE
        status = Status.STOP
        statusAfterAnimation = Status.STOP
        targetDirection = Direction.NONE
        targetDistance = 0
        objCnt = 1
    }
    
    func objTargetSearch(direction: Direction, distance: Int, wallDetection: Bool)->(Bool, Bool, Int){
        
        let x: Int = self.xPoint
        let y: Int = self.yPoint
        var resultTarget: Bool = true
        var distanceCnt: Int = distance
        var wallDetectionArg: Bool = wallDetection
        var judgeObjRtn: ObjTarget = ObjTarget.NONE
        
        switch direction{
            case .UP:
                if(0 > y - distanceCnt){
                    resultTarget = false
                }else{
                    judgeObjRtn = judgeObj(x: x, y: y - distanceCnt, wallDetection: wallDetectionArg)
                }
                break
            case .DOWN:
                if(v_tile <= y + distanceCnt){
                    resultTarget = false
                }else{
                    judgeObjRtn = judgeObj(x: x, y: y + distanceCnt, wallDetection: wallDetectionArg)
                }
                break
            case .LEFT:
                if(0 > x - distanceCnt){
                    resultTarget = false
                }else{
                    judgeObjRtn = judgeObj(x: x - distanceCnt, y: y, wallDetection: wallDetectionArg)
                }
            break
            case .RIGHT:
                if(h_tile <= x + distanceCnt){
                    resultTarget = false
                }else{
                    judgeObjRtn = judgeObj(x: x + distanceCnt, y: y, wallDetection: wallDetectionArg)
                }
                break
            default:
                break
        }
        
        if(false == resultTarget){
            
        }else if(ObjTarget.TARGET == judgeObjRtn){
            resultTarget = true
        }else if(ObjTarget.WALL == judgeObjRtn){
            distanceCnt += 1
            (wallDetectionArg, resultTarget, distanceCnt) = objTargetSearch(direction: direction, distance: distanceCnt, wallDetection: true)
        }else if(ObjTarget.NONE == judgeObjRtn){
            distanceCnt += 1
            (wallDetectionArg, resultTarget, distanceCnt) = objTargetSearch(direction: direction, distance: distanceCnt, wallDetection: wallDetectionArg)
        }else{}
        
        return (wallDetectionArg, resultTarget, distanceCnt)
        
    }
    
    func judgeObj(x: Int, y: Int, wallDetection: Bool)->ObjTarget{
        
        let obj: Int = (self.delegate?.getObjData(x: x, y: y))!
        var resultJudge:ObjTarget = ObjTarget.NONE
        
        if(
            (true == wallDetection)
         && (obj == ObjIndex.CHEESE.rawValue)){
            
            resultJudge = ObjTarget.TARGET
            
        }else if(
            (false == wallDetection)
         && ((obj == ObjIndex.CHEESE.rawValue)
          || (obj == ObjIndex.SALAMI.rawValue)
          || (obj == ObjIndex.NOODLE_3MIN.rawValue))){
            
            resultJudge = ObjTarget.TARGET
            
        }else if( (obj == ObjIndex.WALL.rawValue)
               || (obj == ObjIndex.NOODLE_0MIN.rawValue)
               || (obj == ObjIndex.NOODLE_1MIN.rawValue)
               || (obj == ObjIndex.NOODLE_2MIN.rawValue)
               || (obj == ObjIndex.SETARIA.rawValue)){
            
            resultJudge = ObjTarget.WALL
            
        }else{
            
            resultJudge = ObjTarget.NONE
            
        }
        
        return resultJudge
    }
    
    func setTarget(direction: Direction, distance: Int){
        
        self.status = Status.WAIT_ACTION
        self.targetDirection = direction
        self.targetDistance = distance
        
    }
    
    func setNextTileInfo(){
        let info: Int = (self.delegate?.getObjData(x: xPointNext, y: yPointNext))!
        
        switch info{
        case ObjIndex.NONE.rawValue:
            destination = DestinationInfo.NONE
            break
        case ObjIndex.WALL.rawValue, ObjIndex.NOODLE_0MIN.rawValue, ObjIndex.NOODLE_1MIN.rawValue, ObjIndex.NOODLE_2MIN.rawValue, ObjIndex.SETARIA.rawValue:
            destination = DestinationInfo.WALL
            break
        case ObjIndex.HOLE.rawValue:
            destination = DestinationInfo.HOLE
            break
        case ObjIndex.CHEESE.rawValue, ObjIndex.SALAMI.rawValue, ObjIndex.NOODLE_3MIN.rawValue:
            destination = DestinationInfo.FOOD_TOY
            break
        case ObjIndex.MOUSE_TORAP.rawValue:
            destination = DestinationInfo.TRAP
        default:
            destination = DestinationInfo.NONE
            break
        }
    }
    func changeStatus(){
        if(Status.NOEXIST == self.status){
            self.delegate?.notifyMouseNoexist()
        }else if(Status.DEATH == self.status){
            self.delegate?.notifyMouseDeath()
        }else{}
    }
}
