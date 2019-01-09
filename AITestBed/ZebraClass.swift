//
//  ZebraClass.swift
//  AITestBed
//
//  Created by Game Design Shared on 1/9/19.
//  Copyright © 2019 Liberty Game Dev. All rights reserved.
//

import Foundation
import SpriteKit

class ZebraClass:EntityClass
{
    override init()
   
    {
        super.init()
        sprite=SKSpriteNode(imageNamed: "tempZeb")
    } // init
   
    override init(theScene:SKScene, theMap: MapClass, pos: CGPoint, number: Int)
    {
        super.init()
        
        // set the passed references
        map=theMap
        scene=theScene
        
        
        // sprite update
        sprite=SKSpriteNode(imageNamed: "tempZeb")
        sprite.position=pos
        sprite.name=String(format:"entZebra%04d", number)
        name=String(format:"entZebra%04d", number)
        sprite.zPosition=100
        
        scene!.addChild(sprite)
        
        // Variable updates
        MAXSPEED=2.0
        TURNRATE=1.2
        TURNFREQ=0.06
        AICycle=0
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual
        age=random(min: 1.0, max: MAXAGE*0.7)
        
    } // full init()
}// zebra class
