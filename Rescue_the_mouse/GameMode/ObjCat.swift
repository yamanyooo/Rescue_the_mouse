//
//  ObjCat.swift
//  NH_Takashi
//
//  Created by yohei on 2016/11/22.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation

class ObjCat: ObjMouse{

    override init(x: Int, y: Int) {
        super.init(x: x, y: y)
        objType = ObjIndex.CAT
    }
    
    override func judgeObj(x: Int, y: Int, wallDetection: Bool)->ObjTarget{
        
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
                    || (obj == ObjIndex.NOODLE_3MIN.rawValue)
                    || (obj == ObjIndex.SETARIA.rawValue))){
            
            resultJudge = ObjTarget.TARGET
            
        }else if( (obj == ObjIndex.WALL.rawValue)
               || (obj == ObjIndex.NOODLE_0MIN.rawValue)
               || (obj == ObjIndex.NOODLE_1MIN.rawValue)
               || (obj == ObjIndex.NOODLE_2MIN.rawValue)){
            
            resultJudge = ObjTarget.WALL
            
        }else{
            
            resultJudge = ObjTarget.NONE
            
        }
        
        return resultJudge
    }
    
    
    override func setNextTileInfo(){
        let info: Int = (self.delegate?.getObjData(x: xPointNext, y: yPointNext))!
        
        switch info{
        case ObjIndex.NONE.rawValue:
            destination = DestinationInfo.NONE
            break
        case ObjIndex.WALL.rawValue, ObjIndex.NOODLE_0MIN.rawValue, ObjIndex.NOODLE_1MIN.rawValue, ObjIndex.NOODLE_2MIN.rawValue:
            destination = DestinationInfo.WALL
            break
        case ObjIndex.HOLE.rawValue:
            destination = DestinationInfo.HOLE
            break
        case ObjIndex.CHEESE.rawValue, ObjIndex.SALAMI.rawValue, ObjIndex.NOODLE_3MIN.rawValue, ObjIndex.SETARIA.rawValue, ObjIndex.MOUSE_TORAP.rawValue:
            destination = DestinationInfo.FOOD_TOY
            break
        default:
            destination = DestinationInfo.NONE
            break
        }
    }

}
