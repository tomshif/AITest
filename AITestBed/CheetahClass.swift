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
    var followDist:CGFloat = 100
    var lastBaby:CGFloat = 0
    


    
    private var targetEntity:EntityClass?
    
    
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
        MAXSPEED=6
        TURNRATE=0.1
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

        let chance = random(min: 0, max: 1)
        if chance > 0.6
        {
            isMale = true
        }
        
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
        MAXSPEED=6
        TURNRATE=0.1
        TURNFREQ=3
        AICycle=0
        ACCELERATION=0.6
        TURNSPEEDLOST=0.4
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
        speed = herdLeader!.speed*1.05 + MAXSPEED*0.2
        let dist=getDistToEntity(ent: herdLeader!)
        if dist < followDist*1.05
        {
            speed=herdLeader!.speed
        }
    }
    
    func lookForPrey()
    {
        if herdLeader == nil
        {
            var closest:CGFloat=500000000
            var targetIndex:Int = -1
            
            // first find the closest prey
            for i in 0 ..< map!.entList.count
            {
                if !map!.entList[i].name.contains("Cheetah")
                {
                    let dist=getDistToEntity(ent: map!.entList[i])
                    if dist < closest
                    {
                        closest=dist
                        targetIndex=i
                    } // if we're closer
                } // if it's not a cheetah
            } // for each entity
            
            if closest < 600 && targetIndex > -1 && stamina > 0.999
            {
                targetEntity=map!.entList[targetIndex]
                currentState=HUNTSTATE
            }
            else
            {
                targetEntity=nil
                currentState=WANDERSTATE
            }
        }
        
        
    } // func lookForPrey
    
    func hunt()
    {
        if herdLeader == nil
        {
            var angle = getAngleToEntity(ent: targetEntity!)
            if angle > CGFloat.pi*2
            {
                angle -= CGFloat.pi*2
            }
            if angle < 0
            {
                angle += CGFloat.pi*2
            }
            turnToAngle=angle
            isTurning=true
            speed += ACCELERATION
            if speed > MAXSPEED
            {
                speed=MAXSPEED
            }
            
            let dist = getDistToEntity(ent: targetEntity!)
            if dist < 10
            {
                map!.msg.sendMessage(type: map!.msg.DEATH_PREDATOR, from: targetEntity!.name)
                targetEntity!.die()
                targetEntity=nil
                currentState=WANDERSTATE
                speed=0
            }
            stamina -= 0.01
            if stamina < 0
            {
                speed=0
                currentState=WANDERSTATE
                targetEntity=nil
                map!.msg.sendMessage(type: map!.msg.FAILEDHUNT, from: name)
            }
        } // if we're the momma
        else
        {
            speed=0
            currentState=WANDERSTATE
        }
        
    }
    
    override func update(cycle: Int) -> Int
    {
        
        
        var ret:Int = -1
        
        doTurn()
        updateGraphics()
        Baby()
        
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
                        lookForPrey()
                        stamina+=0.0001
                        if stamina > 1
                        {
                            stamina=1
                        }
                    }
                }
                else
                {
                    wander()
                    lookForPrey()
                    stamina+=0.0001
                    if stamina > 1
                    {
                        stamina=1
                    }
                }
            }
            
            if (currentState==HUNTSTATE && targetEntity != nil)
            {
                hunt()
            }
            
            if herdLeader != nil
            {
                if herdLeader?.currentState==HUNTSTATE
                {
                    hunt()
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
            
            
        } // if it's our update cycle
        
        return ret
        
    } // func update
    
    func Baby()
    {

        
        if age - lastBaby > 1000 && !isMale && getAgeString()=="Mature"
        {
           
            let chance=random(min: 0, max: 1)
            if chance > 0.9995
            {
                let temp = CheetahClass(theScene: scene!, theMap: map!, pos: sprite.position, number: map!.entityCounter, leader: self)
                
                let chance = random(min: 0, max: 0.6)
                if chance > 0.6
                {
                    isMale = true
                }
                
                map!.entityCounter+=1
                
                map!.entList.append(temp)
                map!.msg.sendMessage(type: map!.msg.BORN, from: name)
                lastBaby = age
            }
        }
    }
    
} // CheetahClass
