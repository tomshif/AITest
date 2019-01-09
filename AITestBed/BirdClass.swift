//
//  BirdClass.swift
//  AITestBed
//
//  Created by Tom Shiflet on 1/8/19.
//  Copyright © 2019 Liberty Game Dev. All rights reserved.
//

import Foundation
import SpriteKit

class BirdClass
{
    let sprite=SKSpriteNode(imageNamed: "bird01")
    let frame1=SKTexture(imageNamed: "bird01")
    let frame2=SKTexture(imageNamed: "bird02")
    
    private var map:MapClass?
    private var scene:SKScene?
    private var leader:BirdClass?
    
    private var isLeader:Bool=false

    public var isAlive:Bool=true
    
    private let MAXSPEED:CGFloat=5.0
    private var speed:CGFloat=2.5
    private let TURNRATE:CGFloat=0.3
    private let TURNFREQ:Double=0.01
    private let FOLLOWDIST:CGFloat=100
    private var animationCycle:Int=1
    
    public var lastWanderTurn=NSDate()
    
    
    init()
    {
        
    }
    
    init(theMap: MapClass,theScene: SKScene, pos: CGPoint, isLdr: Bool, ldr: BirdClass?)
    {
        map=theMap
        scene=theScene
        
        
        
        sprite.position=pos
        sprite.name="ambBird"
        sprite.setScale(random(min: 0.5, max: 0.8))
        isLeader=isLdr
        sprite.zPosition=10
        scene!.addChild(sprite)
        if !isLdr && ldr != nil
        {
            leader=ldr
        }
        
        
        
    } // init()
    
    public func remove()
    {
        sprite.removeFromParent()
    } // remove()
    
    func wander()
    {
        
    }
    
    private func leaderFly()
    {
        // check for speed up
        let speedChance=random(min: 0, max: 1.0)
        if speedChance > 0.75
        {
            speed+=0.1
            if speed > MAXSPEED
            {
                speed=MAXSPEED
            }
        } // if we speed up
        else if speedChance > 0.5
        {
            speed -= 0.1
            if speed < MAXSPEED*0.5
            {
                speed=MAXSPEED*0.5
            }
        } // if we slowdown
        
        //check to see if it's time to turn
        let turnDelta = -lastWanderTurn.timeIntervalSinceNow
        if turnDelta > TURNFREQ/Double(map!.getTimeScale())
        {
            let turn=random(min: -TURNRATE, max: TURNRATE)
            sprite.zRotation+=turn
            lastWanderTurn=NSDate()
        } // if it's time to turn
        
        
    } // leaderFly
    
    public func getDistToLeader() -> CGFloat
    {
        if leader != nil
        {
            let dx=leader!.sprite.position.x-sprite.position.x
            let dy=leader!.sprite.position.y-sprite.position.y
            let dist=hypot(dy, dx)
            return dist
        }
        else
        {
            return 0
        }
        
    } // getDistToEntity
    
    func pursue()
    {
        if leader != nil
        {

            speed=MAXSPEED
            let dx=leader!.sprite.position.x-sprite.position.x
            let dy=leader!.sprite.position.y-sprite.position.y
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
                // turning left
                sprite.zRotation += TURNRATE
                
            } // if turn left
            else if (angleDiff < -0.3 && angleDiff > -CGFloat.pi) || angleDiff > CGFloat.pi
            {
                // we need to turn right
                sprite.zRotation -= TURNRATE
                
            } // else if turn right

        } // if we have a leader
        
    } // func pursue
    

    public func updateGraphics()
    {
        if animationCycle%4 == 0
        {
            sprite.texture=frame1
            
        }
        else
        {
            sprite.texture=frame2
        }
        
        let dx=cos(sprite.zRotation)*speed*map!.getTimeScale()
        let dy=sin(sprite.zRotation)*speed*map!.getTimeScale()
        sprite.position.x+=dx
        sprite.position.y+=dy
        
    } // func updateGraphics
    
    private func checkMapEdge()
    {
        if sprite.position.x > map!.mapBorder || sprite.position.x < -map!.mapBorder || sprite.position.y > map!.mapBorder || sprite.position.y < -map!.mapBorder
        {
            sprite.removeFromParent()
            isAlive=false
            
        } // if we're off the map
    }
    
    public func update(cycle: Int) -> Bool
    {
        // Return false if the bird is well off the screen and should be removed
        updateGraphics()
        if cycle==2
        {
            animationCycle+=1
            if animationCycle > 200
            {
                animationCycle=1
            }
            
            if isLeader
            {
                leaderFly()
                
            } // if is leader
            else
            {
                let dist = getDistToLeader()
                if dist > FOLLOWDIST
                {
                    pursue()
                }
                else
                {
                    leaderFly()
                }
                
            } // if not leader
      
            checkMapEdge()
        } // if it's our animation cycle
        if sprite.zRotation > CGFloat.pi*2
        {
            sprite.zRotation -= CGFloat.pi*2
        }
        if sprite.zRotation < 0
        {
            sprite.zRotation += CGFloat.pi*2
        }

        
        return true
        
    } // func update
    
    
    
} // class BirdClass
