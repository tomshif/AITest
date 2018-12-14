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
    
    public var herdLeader:ElephantClass?
    
    
    internal var FOLLOWDIST:CGFloat=150
    internal var followDistVariable:CGFloat=0
    
    override init(theScene: SKScene, pos: CGPoint, message: MessageClass, number: Int)
    {
        super.init(theScene: theScene, pos: pos, message: message, number: number)
    
        sprite.texture=texture
        followDistVariable=random(min: FOLLOWDIST*0.5, max: FOLLOWDIST*1.3)
        
        // override variable initial values
        MAXAGE=45.0
        TURNRATE=0.1
        TURNFREQ=0.1
        MINSCALE=0.1
        
        
        
        sprite.name=String(format:"Elephant%04d", number)
        name=String(format:"Elephant%04d", number)
        
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4)
        age=random(min: 1.0, max: MAXAGE*0.7)
        
        
    } // override init
    
    init(theScene: SKScene, pos: CGPoint, message: MessageClass, number: Int, leader: ElephantClass)
    {
        super.init(theScene: theScene, pos: pos, message: message, number: number)
        
        sprite.texture=texture
        herdLeader=leader
        followDistVariable=random(min: FOLLOWDIST*0.5, max: FOLLOWDIST*1.3)
        
        let chance=random(min: 0.0, max: 1.0)
        if chance > 0.25
        {
            isMale=false
        }
        else
        {
            isMale=true
        }
        
        // override variable initial values
        MAXAGE=45.0
        TURNRATE=0.1
        TURNFREQ=0.4
        MAXSPEED=0.6
        
        sprite.name=String(format:"Elephant%04d", number)
        name=String(format:"Elephant%04d", number)
        
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4)
        age=random(min: 1.0, max: MAXAGE*0.7)
 
        
    } // follow init
    
    init(theScene: SKScene, pos: CGPoint, message: MessageClass, number: Int, isLeader: Bool)
    {
        super.init(theScene: theScene, pos: pos, message: message, number: number)
        
        sprite.texture=texture
        isHerdLeader=isLeader
        isMale=isLeader
        
        
        // override variable initial values
        MAXAGE=45.0
        TURNRATE=0.1
        TURNFREQ=0.4
        MAXSPEED=0.6
        
        sprite.name=String(format:"Elephant%04d", number)
        name=String(format:"Elephant%04d", number)
        
        MAXAGE=random(min: MAXAGE*1.0, max: MAXAGE*1.4)
        age=random(min: MAXAGE*0.5, max: MAXAGE*0.7)

        
    } // leader init
    
    private func getDistanceToLeader() -> CGFloat
    {
        if herdLeader != nil
        {
            let dx = herdLeader!.sprite.position.x-sprite.position.x
            let dy = herdLeader!.sprite.position.y-sprite.position.y
            let dist = hypot(dy, dx)
            return dist
        } // if we have a herd leader
        else
        {
            return -1.0
        }
    } // func getDistanceToLeader
    
    
    
    
    
    func pursue()
    {
        if herdLeader != nil
        {
            speed=random(min: MAXSPEED*0.7, max: MAXSPEED*1.0)
            let dx=herdLeader!.sprite.position.x-sprite.position.x
            let dy=herdLeader!.sprite.position.y-sprite.position.y
            var angle=atan2(dy, dx)
            var angleDiff = angle-sprite.zRotation
            
            if angle < 0
            {
                angle+=CGFloat.pi*2
            }
            if angleDiff > CGFloat.pi*2
            {
                angleDiff -= CGFloat.pi*2
            }
            if angleDiff < -CGFloat.pi*2
            {
                angleDiff += CGFloat.pi*2
            }
            
            if (angleDiff > 0.3 && angleDiff < CGFloat.pi) || angleDiff < -CGFloat.pi
            {
                sprite.zRotation+=TURNRATE
            }
            else if (angleDiff < -0.3 && angleDiff > -CGFloat.pi) || angleDiff > CGFloat.pi
            {
                sprite.zRotation -= TURNRATE
            }
            
            
        }
        
    } // func pursue
    
    override func update(cycle: Int) -> Int {
        var ret:Int = -1
        
        updateGraphics()
        
        if alive
        {
            if !ageEntity()
            {
                ret=2
            } // we're able to age
        } // if we're alive
        let dist = getDistanceToLeader()
        if cycle==AICycle
        {
            if currentState==WANDERSTATE
            {
                if dist > FOLLOWDIST + followDistVariable
                {
                    pursue()
                } // if we're out of range of our leader
                else
                {
                    wander()
                } // if in range of leader
            } // if we're wandering
            
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
        
        
        
    } // 
    
    
} // class ElephantClass
