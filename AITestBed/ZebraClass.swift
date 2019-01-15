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
    
    var alert:Int=0
    var temper:Int=0
    var MAXHERD:Int=30
    var MAXCHILDRENBORN:Int=2
    
    var isSick:Bool=false
    var isFemale:Bool=false
    var isChild:Bool=false  // don't really need these three. We can pull these from the age stat.
    var isMature:Bool=false
    var isOld:Bool=false
    
    var isPregnant:Bool=false
    var isTranqued:Bool=false
    
    var inHerd:Bool=true // All zebras will technically be in a herd. Even if the herd is just that one zebra (e.g., if they get separated from their herd or their herd leader dies).
    
    
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
        TURNRATE=0.2
        TURNFREQ=0.5
        AICycle=1
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual
        age=random(min: 1.0, max: MAXAGE*0.7)
        
    } // full init()
    
    init(theScene:SKScene, theMap: MapClass, pos: CGPoint, number: Int, leader:EntityClass?)
    {
        super.init()
        
        if leader==nil
        {
            isHerdLeader=true
        }// if we dont have a herd leader
        else
        {
            herdLeader=leader
        }// if we have a herd leader
        
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
        TURNRATE=0.2
        TURNFREQ=0.5
        AICycle=1
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual
        age=random(min: 1.0, max: MAXAGE*0.7)
        
    } // full init()
}// zebra class
