//
//  CheetahClass.swift
//  AITestBed
//
//  Created by Game Design Shared on 1/7/19.
//  Copyright © 2019 Liberty Game Dev. All rights reserved.
//

import Foundation
import SpriteKit
class CheetahClass:EntityClass
{
    var MAXHERD:Int = 1
    var MAXCHILD:Int = 2
    var isPregnant:Bool = false
    var isChasing:Bool = false
    var isStarving:Bool = false     // I would recommend doing this more as "var lastMeal:Int=0"
    var isClose:Bool = false        // close to what?
    var isTravel:Bool = false       // travel?
    
    
    override init()
    {
        super.init()
        sprite=SKSpriteNode(imageNamed: "cheetah")
    } // init
    
    
    
    override init(theScene:SKScene, theMap: MapClass, pos: CGPoint, number: Int)
    {
        super.init()
        
        // set the passed references
        map=theMap
        scene=theScene
        
        
        // sprite update
        sprite=SKSpriteNode(imageNamed: "cheetah")
        sprite.position=pos
        sprite.name="cheetah"
        sprite.name=String(format:"entCheetah%04d", number)
        name=String(format:"entCheetah%04d", number)
        sprite.zPosition=120
        
        scene!.addChild(sprite)
        
        // Variable updates
        MAXSPEED=3
        TURNRATE=1
        TURNFREQ=0.1
        AICycle=0
        MAXAGE=8*8640
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual
        age=random(min: 1.0, max: MAXAGE*0.7)
        
    } // full init()
} // CheetahClass
