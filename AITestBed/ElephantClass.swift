//
//  ElephantClass.swift
//  AITestBed
//
//  Created by Tom Shiflet on 12/14/18.
//  Copyright © 2018 Liberty Game Dev. All rights reserved.
//

import Foundation
import SpriteKit

class ElephantClass:EntityClass
{
    let texture=SKTexture(imageNamed: "elephant_top")
    
    override init(theScene: SKScene, pos: CGPoint, message: MessageClass, number: Int)
    {
        super.init(theScene: theScene, pos: pos, message: message, number: number)
    
        sprite.texture=texture
        
        // override variable initial values
        MAXAGE=45.0
        TURNRATE=0.1
        TURNFREQ=0.4
        
        sprite.name=String(format:"Elephant%04d", number)
        name=String(format:"Elephant%04d", number)
        
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4)
        age=random(min: 1.0, max: MAXAGE*0.7)
        
        
    }
    
    
} // class ElephantClass
