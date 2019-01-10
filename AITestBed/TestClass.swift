//
//  TestClass.swift
//  AITestBed
//
//  Created by Tom Shiflet on 1/9/19.
//  Copyright © 2019 Liberty Game Dev. All rights reserved.
//

import Foundation
import SpriteKit


class TestClass:EntityClass
{
    override init()
    {
        super.init()
    } // init
    
    
    
    
    override init(theScene:SKScene, theMap: MapClass, pos: CGPoint, number: Int)
    {
        super.init()
        
        // set the passed references
        map=theMap
        scene=theScene
        
        
        // sprite update
        sprite=SKSpriteNode(imageNamed: "entity")
        sprite.position=pos
        
        sprite.name=String(format:"entTest%04d", number)
        name=String(format:"entTest%04d", number)
        sprite.zPosition=170
        
        scene!.addChild(sprite)
        
        // Variable updates
        MAXSPEED=1.2
        TURNRATE=0.05
        TURNFREQ=0.5
        AICycle=3
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual
        age=random(min: 1.0, max: MAXAGE*0.7)
        
    } // full init()
    
}
