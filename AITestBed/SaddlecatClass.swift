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
    
    override init(theScene:SKScene, theMap: MapClass, pos: CGPoint, message: MessageClass, number: Int)
    {
        super.init()
        sprite=SKSpriteNode(imageNamed: "saddleCat")
        sprite.position=pos
        sprite.name="saddlecat"
        sprite.name=String(format:"entSaddleCat%04d", number)
        name=String(format:"entSaddleCat%04d", number)
        theScene.addChild(sprite)
        
    }
}
