//
//  SaddlecatClass.swift
//  AITestBed
//
//  Created by Tom Shiflet on 1/7/19.
//  Copyright © 2019 Liberty Game Dev. All rights reserved.
//

import Foundation
import SpriteKit

class SaddlecatClass:EntityClass
{
    
    override init()
    {
        super.init()
        sprite=SKSpriteNode(imageNamed: "saddleCat")
    } // init
    
    
    
    override init(theScene:SKScene, theMap: MapClass, pos: CGPoint, number: Int)
    {
        super.init()
        
        // set the passed references
        map=theMap
        scene=theScene

        
        // sprite update
        sprite=SKSpriteNode(imageNamed: "saddleCat")
        sprite.position=pos
        sprite.name="saddlecat"
        sprite.name=String(format:"entSaddleCat%04d", number)
        name=String(format:"entSaddleCat%04d", number)
        scene!.addChild(sprite)

        // Variable updates
        MAXSPEED=1.2
        TURNRATE=0.25
        TURNFREQ=0.11
        AICycle=3
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4)
        age=random(min: 1.0, max: MAXAGE*0.7)
        
    } // full init()
} // class SaddlecatClass


