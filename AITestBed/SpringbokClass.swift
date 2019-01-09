//
//  Springbok.swift
//  AITestBed
//
//  Created by Game Design Shared on 1/9/19.
//  Copyright © 2019 Liberty Game Dev. All rights reserved.
//

import Foundation
import SpriteKit

class SpringbokClass:EntityClass
{
    
    override init()
    {
        super.init()
        sprite=SKSpriteNode(imageNamed: "Springbok")
    } // init
    
    
    
    override init(theScene:SKScene, theMap: MapClass, pos: CGPoint, number: Int)
    {
        super.init()
        
        // set the passed references
        map=theMap
        scene=theScene
        
        
        // sprite update
        sprite=SKSpriteNode(imageNamed: "Springbok")
        sprite.position=pos
        sprite.name="Springbok"
        sprite.name=String(format:"entSpringbok2#5z", number)
        name=String(format:"entSpringbok2#5z", number)
        sprite.zPosition=140
        
        scene!.addChild(sprite)
        
        // Variable updates
        MAXSPEED=2.2
        TURNRATE=0.2
        TURNFREQ=0.06
        AICycle=0
        MAXAGE=7*8640
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual
        age=random(min: 1.0, max: MAXAGE*0.7)
        
    } // full init()
} // class SpringbokClass
