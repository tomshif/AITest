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
    
    private let FOLLOWDIST:CGFloat = 250
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
        TURNRATE=0.1
        TURNFREQ=0.5
        AICycle=3
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual
        age=random(min: 1.0, max: MAXAGE*0.7)
        currentState==WANDERSTATE
        
        isHerdLeader=true
        
    } // leader init()
    
    
    
    init(theScene:SKScene, theMap: MapClass, pos: CGPoint, number: Int, ldr: EntityClass)
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
        TURNRATE=0.1
        TURNFREQ=0.5
        AICycle=3
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual
        age=random(min: 1.0, max: MAXAGE*0.7)
 
        herdLeader=ldr
        isHerdLeader=false
        
    } // full init()
    
    
    private func pursue()
    {
        // get angle to leader
        let dx=herdLeader!.sprite.position.x-sprite.position.x
        let dy=herdLeader!.sprite.position.y-sprite.position.y
        let angleToLeader=atan2(dy, dx)
        
        turnToAngle=angleToLeader
        isTurning = true
        speed=MAXSPEED
        
        
        
    } // func pursue
    
    
    override internal func update(cycle: Int) -> Int
    {
        var ret:Int = -1
        
        doTurn()
        updateGraphics()
        
        if alive
        {
            if !ageEntity()
            {
                ret=2
            } // we're able to age, if we die, set return death code
        } // if we're alive
        if cycle==AICycle
        {
            if currentState==WANDERSTATE
            {
                if herdLeader != nil && !isHerdLeader
                {
                    let ldrDist=getDistToEntity(ent: herdLeader!)

                    if ldrDist > FOLLOWDIST
                    {
                        print("Distance to leader: \(ldrDist)")
                        pursue()
                        
                    } // if we're out of range
                    else
                    {
                        wander()
                    }
                } // if we're not herd leader and we have an active leader
                else
                {
                    wander()
                }
                
            } // if we're in wander state
            
            // fix it if our rotation is more than pi*2 or less than 0
            if sprite.zRotation > CGFloat.pi*2
            {
                sprite.zRotation -= CGFloat.pi*2
            }
            if sprite.zRotation < 0
            {
                sprite.zRotation += CGFloat.pi*2
            }
            
        } // if it's our update cycle
        
        return ret
        
    } // func update
}
