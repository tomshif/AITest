//
//  EntityClass.swift
//  EntityClassTest
//
//  Created by Tom Shiflet on 12/12/18.
//  Copyright © 2018 Tom Shiflet. All rights reserved.
//

import Foundation
import SpriteKit

class EntityClass
{
    private var scene:SKScene?
    var sprite=SKSpriteNode(imageNamed: "entity")
    private var msg:MessageClass?
    
    private var speed:CGFloat=0
    private var age:CGFloat=1.0
    
    
    private var MAXAGE:CGFloat=30.0
    private var MAXSPEED:CGFloat=1.0
    private var TURNRATE:CGFloat=0.1
    private var TURNFREQ:Double = 0.05
    
    
    private var currentState:Int=0
    private var AICycle:Int=0
    
    private var isTurning:Bool=false
    private var alive:Bool=true
    
    
    var hash:String
    var name:String=""
    
    private var lastWanderTurn=NSDate()
    
    private let AGINGVALUE:CGFloat = 0.01
    
    // Constants
    let WANDERSTATE:Int=0
    let GOTOSTATE:Int=2
    
    init()
    {
        sprite.name="Entity"
        hash=UUID().uuidString
        sprite.position=CGPoint(x: 0, y: 0)
        sprite.setScale(0.1)
        scene?.addChild(sprite)
    }
    init(theScene:SKScene, pos: CGPoint, message: MessageClass, number: Int)
    {

        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4)
        age=random(min: 1.0, max: MAXAGE*0.7)
        msg=message
        scene=theScene
        sprite.name=String(format:"Entity%03d", number)
        name=String(format:"Entity%03d", number)
        hash=UUID().uuidString
        sprite.position=pos
        sprite.setScale(0.1)
        scene?.addChild(sprite)
        
    } // init
    
    private func updateGraphics()
    {
        let dx=cos(sprite.zRotation)*speed
        let dy=sin(sprite.zRotation)*speed
        sprite.position.x+=dx
        sprite.position.y+=dy
    } // func updateGraphics
    
    public func isAlive() -> Bool
    {
        return alive
    } // func isAlive
    
    public func getAgeString() -> String
    {
        let ageRatio = age/MAXAGE
        
        if ageRatio > 0.8
        {
            return "Elderly"
        }
        else if ageRatio > 0.4
        {
            return "Mature"
        }
        else if ageRatio > 0.2
        {
            return "Juvenile"
        }
        else
        {
            return "Baby"
        }
    } // func getAge
    
    func getAge() -> CGFloat
    {
        return age
    } // getAge
    
    func getMaxAge() -> CGFloat
    {
        return MAXAGE
    } // getMaxAge
    
    func getCurrentState() -> Int
    {
        return currentState
        
    } // getCurrentState
    
    func getCurrentStateString() -> String
    {
        switch currentState
        {
        case 0:
            return "Wander"
            
        case 2:
            return "Go to"
            
        default:
            return "Other (error)"
        } // switch
        
    } // getCurrentStateString
    
    private func ageEntity() -> Bool
    {
        age += AGINGVALUE
        if age > MAXAGE
        {
            msg!.sendMessage(type: 8, from: name)
            sprite.removeFromParent()
            alive=false
            return false
        } // if we die of old age
        else
        {
            return true
        } // if we're still alive
    } // func ageEntity
    
    private func wander()
    {
        // check for speed up
        let speedChance=random(min: 0, max: 1.0)
        if speedChance > 0.75
        {
            speed+=0.1
            if speed > MAXSPEED*0.5
            {
                speed=MAXSPEED*0.5
            }
        }
        else if speedChance > 0.5
        {
            speed -= 0.1
            if speed < 0
            {
                speed=0
            }
        }
        if !isTurning
        {
            //check to see if it's time to turn
            let turnDelta = -lastWanderTurn.timeIntervalSinceNow
            if turnDelta > TURNFREQ
            {
                let turn=random(min: -TURNRATE, max: TURNRATE)
                sprite.zRotation+=turn
                lastWanderTurn=NSDate()
            }
        } // if we're not turning
    } // func wander
    
    func update(cycle: Int) -> Int
    {
        var ret:Int = -1
        
        updateGraphics()
        
        if alive
        {
            if !ageEntity()
            {
                ret=2
            } // we're able to age
        } // if we're alive
        if cycle==AICycle
        {
            if currentState==WANDERSTATE
            {
                    wander()
            }
            
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
    
    
    
} // class EntityClass
