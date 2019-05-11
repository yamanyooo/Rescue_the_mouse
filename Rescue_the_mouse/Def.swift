//
//  Def.swift
//  NH_Takashi
//
//  Created by yohei on 2016/11/08.
//  Copyright © 2016年 yohei. All rights reserved.
//

import Foundation

// 実機デバッグモード切替え設定
enum TargetValue{
    case SIMULATOR
    case YAMA_IPHONE
    case KUDO_IPHONE
    case KUMI_IPHONE
}
// AdMob
let adUnitID: String = "ca-app-pub-1066065675178783/1714655558"
let yamaID: String = "3e2cd12831eb5f5cfb8cd722647c3783"
let kudoID: String = "d89e99445013a4ab8079ed007658fd83"
let kumiID: String = "fbd0a3897fa0cf4c95a3d6c08711e96e"

let targetInfo: TargetValue = TargetValue.SIMULATOR
//let targetInfo: TargetValue = TargetValue.YAMA_IPHONE
//let targetInfo: TargetValue = TargetValue.KUDO_IPHONE
//let targetInfo: TargetValue = TargetValue.KUMI_IPHONE

// trueに設定するとどのステージを選択してもtest用ステージが起動
let testStage: Bool = false

enum ObjIndex: Int {
    case NONE = 0
    case MOUSE
    case HOLE
    case WALL
    case CAT
    case MOUSE_TORAP
    case CHEESE
    case SALAMI
    case SETARIA
    case BOMB
    case NOODLE_0MIN
    case NOODLE_1MIN
    case NOODLE_2MIN
    case NOODLE_3MIN
}

let objFileName: [String] = [
    "none",
    "mouse01.png",
    "hole.png",
    "wall.png",
    "cat01.png",
    "mouse_trap.png",
    "cheese.png",
    "salami.png",
    "setaria.png",
    "bomb.png",
    "noodle_0min.png",
    "noodle_1min.png",
    "noodle_2min.png",
    "noodle_3min.png"
]

let itemOffset: Int = ObjIndex.CHEESE.rawValue

enum Item: Int {
    case CHEESE = 0     // チーズ
    case SALAMI         // サラミ
    case SETARIA        // 猫じゃらし
    case BOMB           // 爆弾
    case NOODLE         // カップ麺
    case NONE_ITEM
}

let ItemIdx: [String] = [
    "cheese",
    "salami",
    "setaria",
    "bomb",
    "noodle",
    "noodle_3min"
]

struct ItemFileName {
    var itemImgInactive: String
    var itemImgInactiveTap: String
    var itemImgActive: String
    var itemImgActiveTap: String
}

var a: Int = 1

let itemData: [ItemFileName] = [
    ItemFileName(  // チーズ
        itemImgInactive: "item_cheese_inactive.png",
        itemImgInactiveTap: "item_cheese_inactive_tap.png",
        itemImgActive: "item_cheese_active.png",
        itemImgActiveTap: "item_cheese_active_tap.png"),
    ItemFileName(  // サラミ
        itemImgInactive: "item_salami_inactive.png",
        itemImgInactiveTap: "item_salami_inactive_tap.png",
        itemImgActive: "item_salami_active.png",
        itemImgActiveTap: "item_salami_active_tap.png"),
    ItemFileName(  // 猫じゃらし
        itemImgInactive: "item_setaria_inactive.png",
        itemImgInactiveTap: "item_setaria_inactive_tap.png",
        itemImgActive: "item_setaria_active.png",
        itemImgActiveTap: "item_setaria_active_tap.png"),
    ItemFileName(  // 爆弾
        itemImgInactive: "item_bomb_inactive.png",
        itemImgInactiveTap: "item_bomb_inactive_tap.png",
        itemImgActive: "item_bomb_active.png",
        itemImgActiveTap: "item_bomb_active_tap.png"),
    ItemFileName(  // カップ麺
        itemImgInactive: "item_noodle_inactive.png",
        itemImgInactiveTap: "item_noodle_inactive_tap.png",
        itemImgActive: "item_noodle_active.png",
        itemImgActiveTap: "item_noodle_active_tap.png"),
    ItemFileName(  // カップ麺(3min追加に伴い要素調整)
        itemImgInactive: "item_noodle_inactive.png",
        itemImgInactiveTap: "item_noodle_inactive_tap.png",
        itemImgActive: "item_noodle_active.png",
        itemImgActiveTap: "item_noodle_active_tap.png")
]

enum AnimationPtn: Int{
    case NONE = 0
    case USE_BOMB
    case HOLE
    case MOUSE_UP
    case MOUSE_DOWN
    case MOUSE_LEFT
    case MOUSE_RIGHT
    case MOUSE_CHEEZE
    case MOUSE_SALAMI
    case MOUSE_NOODLE
    case MOUSE_TRAP
    case Mouse_DEATH
    case CAT_UP
    case CAT_DOWN
    case CAT_LEFT
    case CAT_RIGHT
    case CAT_TRAP
    case CAT_MOUSE
    case CAT_CHEEZE
    case CAT_SALAMI
    case CAT_NOODLE
    case CAT_SETARIA
    case PTN_END
}

// AnimationPtnと対応
let animationFileName: [[String]] = [
    ["none"],
    ["explosion01.png", "explosion02.png", "explosion03.png", "explosion04.png",
     "explosion05.png", "explosion06.png", "explosion07.png", "explosion08.png",
     "explosion09.png", "explosion10.png", "explosion11.png", "explosion12.png"],
    ["fall01.png", "fall02.png", "fall03.png", "fall04.png", "fall05.png",
     "fall06.png", "fall07.png", "fall08.png", "fall09.png"],
    ["mouse_up01.png", "mouse_up02.png", "mouse_up03.png"],
    ["mouse_down01.png", "mouse_down02.png", "mouse_down03.png"],
    ["mouse_left01.png", "mouse_left02.png", "mouse_left03.png"],
    ["mouse_right01.png", "mouse_right02.png", "mouse_right03.png"],
    ["mouse_cheese01.png", "mouse_cheese02.png", "mouse_cheese03.png",
     "mouse_cheese04.png", "mouse_cheese05.png", "mouse_cheese06.png"],
    ["mouse_salami01.png", "mouse_salami02.png", "mouse_salami03.png",
     "mouse_salami04.png", "mouse_salami05.png", "mouse_salami06.png"],
    ["mouse_noodle01.png", "mouse_noodle02.png", "mouse_noodle03.png",
     "mouse_noodle04.png", "mouse_noodle05.png", "mouse_noodle06.png"],
    ["trap07.png"],
    ["mouse_death.png", "mouse_death01.png", "mouse_death02.png",
     "mouse_death03.png", "mouse_death04.png", "mouse_death05.png"],
    ["cat_up01.png", "cat_up02.png", "cat_up03.png"],
    ["cat_down01.png", "cat_down02.png", "cat_down03.png"],
    ["cat_left01.png", "cat_left02.png", "cat_left03.png"],
    ["cat_right01.png", "cat_right02.png", "cat_right03.png"],
    ["attack01.png", "attack02.png", "attack03.png", "attack04.png",
     "attack05.png", "attack06.png", "attack07.png", "attack08.png"],
    ["attack01.png", "attack02.png", "attack03.png", "attack04.png",
     "attack05.png", "attack06.png", "attack07.png", "attack08.png"],
    ["cat_cheese01.png", "cat_cheese02.png", "cat_cheese03.png",
     "cat_cheese04.png", "cat_cheese05.png", "cat_cheese06.png"],
    ["cat_salami01.png", "cat_salami02.png", "cat_salami03.png",
     "cat_salami04.png", "cat_salami05.png", "cat_salami06.png"],
    ["cat_noodle01.png", "cat_noodle02.png", "cat_noodle03.png",
     "cat_noodle04.png", "cat_noodle05.png", "cat_noodle06.png"],
    ["cat_setaria01.png", "cat_setaria02.png", "cat_setaria03.png",
     "cat_setaria04.png", "cat_setaria05.png", "cat_setaria06.png"]
    
]

