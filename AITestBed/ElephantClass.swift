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
    private var map:MapClass?
    
    

    internal var FOLLOWDIST:CGFloat=150
    internal var followDistVariable:CGFloat=0
    
    private var isAvoidingObstacle:Bool=false

    
    private var gotoPoint:CGPoint=CGPoint(x: 0, y: 0)
    private var tempPoint:CGPoint=CGPoint(x: 0, y: 0)
    
    private var METABOLISM:CGFloat=0.00001
    private var WATERUSAGE:CGFloat=0.000015
    
    
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
    
    init(theScene: SKScene, pos: CGPoint, message: MessageClass, number: Int, leader: ElephantClass, theMap: MapClass)
    {
        super.init(theScene: theScene, pos: pos, message: message, number: number)
        map=theMap
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
    
    init(theScene: SKScene, pos: CGPoint, message: MessageClass, number: Int, isLeader: Bool, theMap: MapClass)
    {
        super.init(theScene: theScene, pos: pos, message: message, number: number)
        
        sprite.texture=texture
        isHerdLeader=isLeader
        isMale=isLeader
        map=theMap
        
        // override variable initial values
        MAXAGE=45.0
        TURNRATE=0.1
        TURNFREQ=0.4
        MAXSPEED=0.6
        
        sprite.name=String(format:"Elephant%04d", number)
        name=String(format:"Elephant%04d", number)
        
        MAXAGE=random(min: MAXAGE*1.0, max: MAXAGE*1.4)
        age=random(min: MAXAGE*0.5, max: MAXAGE*0.7)
        thirst=0.26
        
    } // leader init
    
    func goTo()
    {
        if !isAvoidingObstacle
        {
            let dx=gotoPoint.x-sprite.position.x
            let dy=gotoPoint.y-sprite.position.y
            let dist = hypot(dy, dx)
            var angle=atan2(dy, dx)
            var angleDiff = angle-sprite.zRotation
            speed=MAXSPEED*0.4
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
            }
            else if (angleDiff < -0.3 && angleDiff > -CGFloat.pi) || angleDiff > CGFloat.pi
            {
                // we need to turn right
                sprite.zRotation -= TURNRATE
            }
            
            
            // if we're at our destination go back to wandering
            if dist < 100
            {
                currentState=WANDERSTATE
            }
            
            
            
        } // if we're not avoiding an obstacle
        else
        {
            let dx=tempPoint.x-sprite.position.x
            let dy=tempPoint.y-sprite.position.y
            let dist = hypot(dy, dx)
            var angle=atan2(dy, dx)
            var angleDiff = angle-sprite.zRotation
            speed=MAXSPEED*0.4
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
            }
            else if (angleDiff < -0.3 && angleDiff > -CGFloat.pi) || angleDiff > CGFloat.pi
            {
                // we need to turn right
                sprite.zRotation -= TURNRATE
            }
            
            
            // if we're at our destination go back to going straight to point
            if dist < 50
            {
                isAvoidingObstacle=false
            }
        } // if we are avoiding an obstacle
        
        
        // check for obstacle in front at three different distances
        let obstacle = checkObstacle(direction: sprite.zRotation)
        // if there is something in front, check to 45 degrees left/right to see if it's clear
        if obstacle && !isAvoidingObstacle
        {
            isAvoidingObstacle=true
            avoidObstacle()
        } // if we have an obstacle
        
        
        
        
        
    } // func goto
    
    func avoidObstacle()
    {
        var left:Bool=false, right:Bool=false
        // look left
        let angleLeft=sprite.zRotation+CGFloat.pi/4
        let angleRight=sprite.zRotation-CGFloat.pi/4
        if checkObstacle(direction: angleLeft)
        {
            left=true
            print("Left Blocked")
        }
        if checkObstacle(direction: angleRight)
        {
            right=true
            print("Right Blocked")
        }
        
        if !left && !right
        {
            let chance=random(min: 0, max: 1.0)
            if chance > 0.5
            {
                let dx=cos(angleRight)*FOLLOWDIST*0.5
                let dy=sin(angleRight)*FOLLOWDIST*0.5
                tempPoint=CGPoint(x: sprite.position.x+dx, y: sprite.position.y+dy)
                print("TempPoint: \(tempPoint)")
                
            } // if we choose right
            else
            {
                let dx=cos(angleLeft)*FOLLOWDIST*0.5
                let dy=sin(angleLeft)*FOLLOWDIST*0.5
                tempPoint=CGPoint(x: sprite.position.x+dx, y: sprite.position.y+dy)
                print("TempPoint: \(tempPoint)")
            } // if we choose left
            
        } // if both left and right are open
        
        if !left && right
        {
            let dx=cos(angleLeft)*FOLLOWDIST*0.5
            let dy=sin(angleLeft)*FOLLOWDIST*0.5
            tempPoint=CGPoint(x: sprite.position.x+dx, y: sprite.position.y+dy)
            print("TempPoint: \(tempPoint)")
            
        } // if only right is open
        
        if !right && left
        {
            let dx=cos(angleRight)*FOLLOWDIST*0.5
            let dy=sin(angleRight)*FOLLOWDIST*0.5
            tempPoint=CGPoint(x: sprite.position.x+dx, y: sprite.position.y+dy)
            print("TempPoint: \(tempPoint)")
        } // if only left is open
        
        if left && right
        {
            let chance=random(min: 0, max: 1.0)
            if chance > 0.5
            {
                let dx=cos(angleRight+CGFloat.pi/4)*FOLLOWDIST*0.1
                let dy=sin(angleRight+CGFloat.pi/4)*FOLLOWDIST*0.1
                tempPoint=CGPoint(x: sprite.position.x+dx, y: sprite.position.y+dy)
                print("TempPoint: \(tempPoint)")
                
            } // if we choose right
            else
            {
                let dx=cos(angleLeft+CGFloat.pi/4)*FOLLOWDIST*0.1
                let dy=sin(angleLeft+CGFloat.pi/4)*FOLLOWDIST*0.1
                tempPoint=CGPoint(x: sprite.position.x+dx, y: sprite.position.y+dy)
                print("TempPoint: \(tempPoint)")
            } // if we choose left
        } // if left and right are both blocked, set a short point to the right or left and try again
    }
    
    func checkObstacle(direction: CGFloat) -> Bool
    {
        var obstacle:Bool=false
        for i in 2...3
        {
            let px=cos(direction)*FOLLOWDIST*(CGFloat(i)/9)
            let py=sin(direction)*FOLLOWDIST*(CGFloat(i)/9)
            
            let nodes=scene?.nodes(at: CGPoint(x: sprite.position.x+px, y: sprite.position.y+py))
            if nodes!.count > 0
            {
                for theNodes in nodes!
                {
                    if theNodes.name=="Water"
                    {
                        //print("Water in front of me!")
                        obstacle=true
                        
                        
                    } // if its water
                    
                } // for each node
            } // if we have nodes to check
        } // for each distance to check
        return obstacle
        
    } // func checkObstacle
    
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
    
    
    private func findFoodZone() -> CGPoint
    {
        var index = -1
        var tempDist:CGFloat=999999999
        var tempPoint=CGPoint(x: 0, y: 0)
        if map!.zoneList.count > 0
        {

            for i in 0..<map!.zoneList.count
            {
                if map!.zoneList[i].type==0
                {
                    let dx=map!.zoneList[i].sprite.position.x-sprite.position.x
                    let dy=map!.zoneList[i].sprite.position.y-sprite.position.y
                    let dist = hypot(dy, dx)
                    if dist < tempDist
                    {
                        index=i
                        tempDist=dist
                        tempPoint=map!.zoneList[i].sprite.position
                    } // if we're closer
                } // if it's a food zone
                
                
            } // for each zone
            
        } // if we have zones
        if index > -1
        {
            return tempPoint
        }
        else
        {
            msg!.sendCustomMessage(message: "Error finding food zone")
            return tempPoint
            
        }
        
    } // func findFoodZone
    
    private func findWaterZone() -> CGPoint
    {
        var index = -1
        var tempDist:CGFloat=999999999
        var tempPoint=CGPoint(x: 0, y: 0)
        if map!.zoneList.count > 0
        {
            
            for i in 0..<map!.zoneList.count
            {
                if map!.zoneList[i].type==ZoneType.WATERZONE
                {
                    let dx=map!.zoneList[i].sprite.position.x-sprite.position.x
                    let dy=map!.zoneList[i].sprite.position.y-sprite.position.y
                    let dist = hypot(dy, dx)
                    if dist < tempDist
                    {
                        index=i
                        tempDist=dist
                        tempPoint=map!.zoneList[i].sprite.position
                    } // if we're closer
                } // if it's a food zone
                
                
            } // for each zone
            
        } // if we have zones
        if index > -1
        {
            return tempPoint
        }
        else
        {
            msg!.sendCustomMessage(message: "Error finding water zone")
            return tempPoint
            
        }
        
    } // func findFoodZone
    
    
    private func getDistanceToFoodZone() -> CGFloat
    {
        let foodPoint=findFoodZone()
        let dx=foodPoint.x-sprite.position.x
        let dy=foodPoint.y-sprite.position.y
        let dist=hypot(dy, dx)
        //print("Counting \(map!.zoneList.count) zones")
    
        return dist
    } // func getDistanceToFoodZone
    
    private func getDistanceToWaterZone() -> CGFloat
    {
        let foodPoint=findWaterZone()
        let dx=foodPoint.x-sprite.position.x
        let dy=foodPoint.y-sprite.position.y
        let dist=hypot(dy, dx)
        //print("Counting \(map!.zoneList.count) zones")
        
        return dist
    } // func getDistanceToWaterZone
    
    
    private func updateStats() -> Int
    {
        var ret:Int = -1
        hunger -= METABOLISM
        thirst -= WATERUSAGE
        
        if hunger < 0.25 && isHerdLeader && getDistanceToFoodZone() > 250
        {

            gotoPoint=findFoodZone()
            currentState=GOTOSTATE

        } // we're hungry, find food
        
        if currentState==WANDERSTATE && getDistanceToFoodZone() < 250
        {
            hunger += 0.0001
            isEating=true
        }
        else
        {
            isEating=false
        }
        
        if thirst < 0.25 && isHerdLeader && getDistanceToWaterZone() > 250
        {
            
            gotoPoint=findWaterZone()
            currentState=GOTOSTATE
            
        } // we're thirsty, find water
        
        if currentState==WANDERSTATE && getDistanceToWaterZone() < 250
        {
            thirst += 0.0002
            isDrinking=true
        }
        else
        {
            isDrinking=false
        }
        
        
        
        if hunger <= 0
        {
            ret = 4
        }
        
        if hunger > 1
        {
            hunger=1.0
        }
        if thirst > 1
        {
            thirst=1.0
        }
        return ret
        
        
    } // updateStats()
    
    override func update(cycle: Int) -> Int {
        var ret:Int = -1
        
        updateGraphics()
        let statsRet=updateStats()
        if statsRet > 0
        {
            ret = statsRet
        } // if animal died in stat
        
        
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
            else if currentState==GOTOSTATE
            {
                goTo()
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
        
        
        
    } // 
    
    
} // class ElephantClass
