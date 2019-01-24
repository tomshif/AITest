//
//  CheetahClass.swift
//  AITestBed
//
//  Created by Game Design Shared on 1/7/19.
//  Copyright © 2019 Liberty Game Dev. All rights reserved.
//

import Foundation
import SpriteKit
class CheetahClass:EntityClass
{
    var MAXHERD:Int = 1
    var MAXCHILD:Int = 2
    var isPregnant:Bool = false
    var isChasing:Bool = false
    var lastMeal:Bool = false     // I would recommend doing this more as "var lastMeal:Int=0"
    var isClose:Bool = false        // close to what?
    var isTravel:Bool = false       // travel?
    var cubs:Bool = false
    var followDist:CGFloat = 400
    var timeInterval:CGFloat = 0
    
    override init()
    {
        super.init()
        sprite=SKSpriteNode(imageNamed: "cheetahSprite")
    } // init
    
    
    
    override init(theScene:SKScene, theMap: MapClass, pos: CGPoint, number: Int)
    {
        super.init()
        
        // set the passed references
        map=theMap
        scene=theScene
        
        
        // sprite update
        sprite=SKSpriteNode(imageNamed: "cheetahSprite")
        sprite.position=pos
        sprite.name=String(format:"entCheetah%04d", number)
        name=String(format:"entCheetah%04d", number)
        sprite.zPosition=120
        
        scene!.addChild(sprite)
        
        // Variable updates
        MAXSPEED=3
        TURNRATE=0.15
        TURNFREQ=3
        AICycle=0
        MAXAGE=8*8640
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual
        age=random(min: 1.0, max: MAXAGE*0.7)
    
        
        
    } // full init()
    init(theScene:SKScene, theMap: MapClass, pos: CGPoint, number: Int, leader: EntityClass?)
    {
        super.init()
        
        MAXAGE=8*8640
        MAXAGE=random(min: MAXAGE*0.8, max: MAXAGE*1.4) // adjust max age to the individual

        
        if leader == nil
        {
            isHerdLeader = true
            age=random(min: MAXAGE*0.3, max: MAXAGE*0.7)
        }
        else
        {
            herdLeader = leader
            age=random(min: 1.0, max: MAXAGE*0.1)
        }
        
        // set the passed references
        map=theMap
        scene=theScene
        
        
        // sprite update
        sprite=SKSpriteNode(imageNamed: "cheetahSprite")
        sprite.position=pos
        sprite.name="cheetah"
        sprite.name=String(format:"entCheetah%04d", number)
        name=String(format:"entCheetah%04d", number)
        sprite.zPosition=120
        
        scene!.addChild(sprite)
        
        // Variable updates
        MAXSPEED=3
        TURNRATE=0.15
        TURNFREQ=3
        AICycle=0
        
    } // full init()
    
    func catchUp()
    {
        var angle = getAngleToEntity(ent: herdLeader!)
        if angle < 0
        {
            angle += CGFloat.pi*2
        }
        turnToAngle=angle
        isTurning=true
        speed = MAXSPEED * 0.45
    }
    
    func TimeInterval()
    {
        timeInterval += map!.getTimeInterval()*map!.getTimeScale()
        
        if timeInterval >= 12960
        {
            spawnBaby()
        }
    }
    
    func checkBaby()
    {
        if !isMale && getAgeString()=="Mature"
        {
            
                }
            }
    
    
    override func update(cycle: Int) -> Int
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
                    if getDistToEntity(ent: herdLeader!) > followDist
                    {
                        catchUp()
                    }
                    else
                    {
                        wander()
                    }
                }
                else
                {
                    wander()
                }
            }
            
            // fix it if our rotation is more than pi*2 or less than 0
            if sprite.zRotation > CGFloat.pi*2
            {
                sprite.zRotation -= CGFloat.pi*2
            }
            if sprite.zRotation < 0
            {
                sprite.zRotation += CGFloat.pi*2
            }
            
            if getAgeString() == "Mature"
            {
                herdLeader = nil
            }
            
            func spawnBaby()
            {
                
          let chance=random(min: 0, max: 1)
            if chance > 0.999995
            {
                let temp = CheetahClass(theScene: scene!, theMap: map!, pos: sprite.position, number: map!.entityCounter, leader: self)
                
                map!.entityCounter+=1
                
                map!.entList.append(temp)
            }
            }
        } // if it's our update cycle
        
        return ret
        
    } // func update
    
    
    
    
    
    
} // CheetahClass
