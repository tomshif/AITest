//
//  GameScene.swift
//  AITestBed
//
//  Created by Tom Shiflet on 12/13/18.
//  Copyright © 2018 Liberty Game Dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var map=MapClass()
    
    var centerPoint=SKShapeNode(circleOfRadius: 10)
    
    var infoBG=SKSpriteNode(imageNamed: "informationBG")
    var msgBG=SKSpriteNode(imageNamed: "messageBG")
    let selectedSquare=SKSpriteNode(imageNamed: "selectedSquare")
    
    
    let infoTitle=SKLabelNode(fontNamed: "Arial")
    let infoAge=SKLabelNode(fontNamed: "Arial")
    let infoState=SKLabelNode(fontNamed: "Arial")
    let infoLeader=SKLabelNode(fontNamed: "Arial")
    let infoGender=SKLabelNode(fontNamed: "Arial")
    let infoHunger=SKLabelNode(fontNamed: "Arial")
    let infoThirst=SKLabelNode(fontNamed: "Arial")
    let infoHerdLeader=SKLabelNode(fontNamed: "Arial")
    let timeLabel=SKLabelNode(fontNamed: "Arial")
    
    
    let msgLabel=SKLabelNode(fontNamed: "Arial")
    
    var selectedEntity:EntityClass?
    
    
    
    var upPressed:Bool=false
    var downPressed:Bool=false
    var leftPressed:Bool=false
    var rightPressed:Bool=false
    var zoomInPressed:Bool=false
    var zoomOutPressed:Bool=false
    var isSelected:Bool=false
    var followModeOn:Bool=false
    
    var myCam=SKCameraNode()

    

    //var zoneList=[ZoneClass]()
    
    var currentCycle:Int=0
    var currentMode:Int=0
    var entityHerdCount:Int=0
    var elephantHerdCount:Int=0
    
    let SELECTMODE:Int=0
    let ENTITYMODE:Int=2
    let ELEPHANTMODE:Int=4
    let FOODZONEMODE:Int=10
    let WATERZONEMODE:Int=12
    let OBSTACLEMODE:Int=14
    let RESTZONEMODE:Int=16
    
    
    
    let ENTITYHERD:Int=0
    let ELEPHANTHERD:Int=2
    
    let ENTITYHERDSIZE:CGFloat=10
    let ELEPHANTHERDSIZE:CGFloat=10
    
    var msg=MessageClass()
    
    
    
    
    
    override func didMove(to view: SKView) {
        backgroundColor=NSColor.white
        
        camera=myCam
        myCam.name="myCamera"
        addChild(myCam)
        
        timeLabel.position.y = -size.height*0.45
        timeLabel.zPosition = 100
        timeLabel.fontSize = 48
        timeLabel.fontColor=NSColor.black
        myCam.addChild(timeLabel)
        
        
        
        infoBG.zPosition=100
        infoBG.name="infoBG"
        infoBG.position.x=size.width/2-infoBG.size.width/2
        infoBG.position.y=size.height/2-infoBG.size.height/2
        myCam.addChild(infoBG)
        
        msgBG.zPosition=100
        msgBG.name="msgBG"
        msgBG.position.x = -size.width/2+msgBG.size.width/2
        msgBG.position.y = -size.height/2+msgBG.size.height/2
        msgBG.alpha=0.0
        myCam.addChild(msgBG)
        
        msgLabel.zPosition=101
        msgLabel.text=""
        msgLabel.name="MsgLabel"
        msgLabel.fontSize=24
        msgLabel.fontColor=NSColor.yellow
        msgLabel.numberOfLines=3
        msgLabel.preferredMaxLayoutWidth=msgBG.size.width*0.95
        msgBG.addChild(msgLabel)
        
        
        infoTitle.zPosition=101
        infoTitle.fontColor=NSColor.yellow
        infoTitle.text="Entity000"
        infoTitle.name="InfoTitle"
        infoTitle.position.y=infoBG.size.height*0.40
        infoBG.addChild(infoTitle)
        
        infoAge.zPosition=101
        infoAge.fontColor=NSColor.yellow
        infoAge.fontSize=26
        infoAge.text="infoAge"
        infoAge.name="InfoAge"
        infoAge.position.y=infoBG.size.height*0.2
        infoBG.addChild(infoAge)
        
        infoState.zPosition=101
        infoState.fontColor=NSColor.yellow
        infoState.fontSize=26
        infoState.text="InfoState"
        infoState.name="InfoState"
        infoState.position.y=infoBG.size.height*0.1
        infoBG.addChild(infoState)
        
        infoLeader.zPosition=101
        infoLeader.fontColor=NSColor.yellow
        infoLeader.fontSize=26
        infoLeader.text="InfoLeader"
        infoLeader.name="InfoLeader"
        infoLeader.position.y = 0
        infoBG.addChild(infoLeader)
        
        infoGender.zPosition=101
        infoGender.fontColor=NSColor.yellow
        infoGender.fontSize=26
        infoGender.text="InfoGender"
        infoGender.name="InfoGender"
        infoGender.position.y = -infoBG.size.height*0.1
        infoBG.addChild(infoGender)
        
        infoHunger.zPosition=101
        infoHunger.fontColor=NSColor.yellow
        infoHunger.fontSize=26
        infoHunger.text="infoHunger"
        infoHunger.name="infoHunger"
        infoHunger.position.y = -infoBG.size.height*0.2
        infoBG.addChild(infoHunger)
        
        infoThirst.zPosition=101
        infoThirst.fontColor=NSColor.yellow
        infoThirst.fontSize=26
        infoThirst.text="infoThirst"
        infoThirst.name="infoThirst"
        infoThirst.position.y = -infoBG.size.height*0.3
        infoBG.addChild(infoThirst)
        
        infoHerdLeader.zPosition=101
        infoHerdLeader.fontColor=NSColor.yellow
        infoHerdLeader.fontSize=26
        infoHerdLeader.text="infoHerdLeader"
        infoHerdLeader.name="infoHerdLeader"
        infoHerdLeader.position.y = -infoBG.size.height*0.4
        infoBG.addChild(infoHerdLeader)
        
        centerPoint.fillColor=NSColor.black
        centerPoint.name="CenterPoint"
        addChild(centerPoint)
        
        selectedSquare.isHidden=true
        selectedSquare.name="selectedSquare"
        selectedSquare.zPosition=50
        addChild(selectedSquare)
        
        
    } // didMove
    
    
    func touchDown(atPoint pos : CGPoint) {

        if currentMode==SELECTMODE
        {
            var temp:String=""
            isSelected=false
            
            for node in nodes(at: pos)
            {
                if (node.name?.contains("Entity"))! || (node.name?.contains("Elephant"))! || (node.name?.contains("infoHunger"))!
                {
                    temp=node.name!
                    isSelected=true
                } // if we have a match

            } // for each node
           
            if isSelected
            {
                for i in 0..<map.entList.count
                {
                    if map.entList[i].name==temp
                    {
                        selectedEntity=map.entList[i]
                        break
                    } // if we have a match
                } // for each entity

                for i in 0..<map.elephantList.count
                {
                    if map.elephantList[i].name==temp
                    {
                        selectedEntity=map.elephantList[i]
                        break
                    } // if we have a match
                } // for each entity
                
                if temp=="infoHunger"
                {
                    selectedEntity!.hunger=0.25
                }
                
            }
    
        } // if we're in select mode
        
        if currentMode==ENTITYMODE
        {
            spawnHerd(type: ENTITYHERD, loc: pos)
            
        } // if we're in entity spawn mode
        
        if currentMode==ELEPHANTMODE
        {
            spawnHerd(type: ELEPHANTHERD, loc: pos)
        }
        
        if currentMode==FOODZONEMODE
        {
            let tempZone=ZoneClass(zoneType: ZoneType.FOODZONE, pos: pos, theScene: self)
            map.zoneList.append(tempZone)
        }
        
        if currentMode==WATERZONEMODE
        {
            let tempZone=ZoneClass(zoneType: ZoneType.WATERZONE, pos: pos, theScene: self)
            map.zoneList.append(tempZone)
        }
        
        if currentMode==RESTZONEMODE
        {
            let tempZone=ZoneClass(zoneType: ZoneType.RESTZONE, pos: pos, theScene: self)
            map.zoneList.append(tempZone)
        }
        
        if currentMode==OBSTACLEMODE
        {
            let obRect=CGSize(width: 128, height: 128)
            let obstacle=SKShapeNode(rectOf: obRect, cornerRadius: 5)
            obstacle.position=pos
            obstacle.zPosition = -5
            obstacle.fillColor=NSColor.blue
            obstacle.name="Water"
            addChild(obstacle)
        }
        
    } // touchDown
    
    func touchMoved(toPoint pos : CGPoint) {

    } // touchMoved
    
    func touchUp(atPoint pos : CGPoint) {

    } // touchUp
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {

        case 0:
            leftPressed=true
            
        case 1:
            downPressed=true
            
        case 2:
            rightPressed=true

        case 3: // F
            if followModeOn
            {
                followModeOn=false
                msg.sendCustomMessage(message: "Follow mode off")
            }
            else
            {
                followModeOn=true
                msg.sendCustomMessage(message: "Follow mode on.")
            }
        case 13:
            upPressed=true
            
            

            
        case 27:
            zoomOutPressed=true
            
        case 24:
            zoomInPressed=true
            
        case 23: // 5
            currentMode=WATERZONEMODE
            msg.sendCustomMessage(message: "Spawn water zone mode.")
            selectedEntity=nil
            isSelected=false

        case 22: // 6
            currentMode=FOODZONEMODE
            msg.sendCustomMessage(message: "Spawn food zone mode.")
            selectedEntity=nil
            isSelected=false
            
        case 26:
            currentMode=RESTZONEMODE
            msg.sendCustomMessage(message: "Spawn rest zone mode.")
            selectedEntity=nil
            isSelected=false
            
        case 25: // 9
            currentMode=ELEPHANTMODE
            msg.sendCustomMessage(message: "Spawn elephant mode.")
            selectedEntity=nil
            isSelected=false
            
        case 29: // 0
            currentMode=ENTITYMODE
            msg.sendCustomMessage(message: "Spawn entity mode.")
            selectedEntity=nil
            isSelected=false
            
            
        case 34: // I
            if infoBG.isHidden
            {
                infoBG.isHidden=false
            }
            else
            {
                infoBG.isHidden=true
            }
            
        case 35: // P
            currentMode=SELECTMODE
            msg.sendCustomMessage(message: "Select mode.")
            
            
        case 37: // L
            currentMode=OBSTACLEMODE
            msg.sendCustomMessage(message: "Spawn obstacle mode.")
            
        case 46:
            if msgBG.isHidden
            {
                msgBG.isHidden=false
            }
            else
            {
                msgBG.isHidden=true
            }
            
        case 48: // <tab>
            if isSelected
            {
                if selectedEntity!.name.contains("Elephant")
                {
                    
                    var index:Int = -1
                    // find the entity
                    for i in 0..<map.elephantList.count
                    {
                        if selectedEntity!.name==map.elephantList[i].name
                        {
                            
                            index=i+1
                        } // if
                        
                    } // for each elephant
                    
                    if index >= map.elephantList.count-1
                    {
                        index=0
                    }
                    
                    selectedEntity=map.elephantList[index]
                    
                }
            }
        case 49:
            myCam.position=CGPoint(x: 0, y: 0)
        
        case 51: // Backspace
            if currentMode==SELECTMODE && isSelected
            {
                var index:Int = -1
                for i in 0..<map.entList.count
                {
                    if map.entList[i].name==selectedEntity!.name
                    {
                        index=i
                    } // if it's a match
                    
                } // for each entity
                
                for i in 0..<map.elephantList.count
                {
                    if map.elephantList[i].name==selectedEntity!.name
                    {
                        index=i
                    } // if it's a match
                    
                }
                
                if index > -1 && selectedEntity!.name.contains("Entity")
                {
                    map.entList[index].removeSprite()
                    map.entList.remove(at: index)
                    selectedEntity=nil
                    isSelected=false
                }
                else if index > -1 && selectedEntity!.name.contains("Elephant")
                {
                    map.elephantList[index].die()
                    map.elephantList.remove(at: index)
                    selectedEntity=nil
                    isSelected=false
                }
                
                for i in 0 ..< map.elephantList.count
                {
                    print(map.elephantList[i].name)
                }
                
            } // if we're in select mode
            
        case 53: // esc
            map.clearAll()
            for node in self.children
            {
                if node.name!=="Water"
                {
                    node.removeFromParent()
                }
            } // for each node
            msg.clearAll()
            isSelected=false
            selectedEntity=nil
            
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    } // keyDown
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
            
        case 0:
            leftPressed=false
            
        case 1:
            downPressed=false
            
        case 2:
            rightPressed=false
            
        case 13:
            upPressed=false
            
        case 27:
            zoomOutPressed=false
            
        case 24:
            zoomInPressed=false
            
        default:
            break
        }
    } // keyUp
    
    func checkKeys()
    {
        if leftPressed
        {
            myCam.position.x -= 5
        }
        
        if rightPressed
        {
            myCam.position.x += 5
        }
        
        if upPressed
        {
            myCam.position.y += 5
        }
        
        if downPressed
        {
            myCam.position.y -= 5
        }
    
        if zoomInPressed
        {
            myCam.setScale(myCam.xScale-0.01)
        }
        
        if zoomOutPressed
        {
            myCam.setScale(myCam.xScale+0.01)
        }
        
    } // checkKeys
    
    func updateSelected()
    {
        if isSelected
        {
            selectedSquare.position=selectedEntity!.sprite.position
            selectedSquare.isHidden=false
            if followModeOn
            {
                myCam.position=selectedEntity!.sprite.position
            }
        } // if
        else
        {
            selectedSquare.isHidden=true
            
        } // else
        
    } // updateSelected
    
    func updateInfo()
    {
        if isSelected
        {
            infoBG.isHidden=false
            
            infoTitle.text=selectedEntity!.name
            infoAge.text=String(format: "Age: \(selectedEntity!.getAgeString()) - %2.1f / %2.1f", selectedEntity!.getAge(), selectedEntity!.getMaxAge())
                
                
            infoState.text="State: \(selectedEntity!.getCurrentStateString())"
            infoLeader.text="Leader: \(selectedEntity!.isHerdLeader)"
            if selectedEntity!.isMale
            {
                infoGender.text="Gender: Male"
            }
            else
            {
                infoGender.text="Gender: Female"
            }
            
            infoHunger.text=String(format: "Hunger: %2.3f", selectedEntity!.hunger)
            infoThirst.text=String(format: "Thirst: %2.3f", selectedEntity!.thirst)
            if selectedEntity!.name.contains("Elephant") && selectedEntity!.isHerdLeader==false
            {
                let eleph=selectedEntity as! ElephantClass
                if eleph.herdLeader != nil
                {
                    infoHerdLeader.text="Herd Leader: \(eleph.herdLeader!.name)"
                }
                else
                {
                    infoHerdLeader.text="Herd Leader: None"
                }
                
            }
            else
            {
                infoHerdLeader.text="Herd Leader: Self"
            }
        } // if something is selected
        else
        {
            infoBG.isHidden=true
        }
    
        timeLabel.text=map.getTimeAsString()
        
        if msg.getUnreadCount() > 0
        {
            msgBG.removeAllActions()
            msgBG.alpha=1.0
            msgLabel.text=msg.readNextMessage()
            msgBG.run(SKAction.fadeOut(withDuration: 5.0))
        }
        
        
        
        
    } // func updateInfo
    
    
    func spawnHerd(type: Int, loc: CGPoint)
    {
        if type==ENTITYHERD
        {
            let herdsize=Int(random(min: ENTITYHERDSIZE*0.5, max: ENTITYHERDSIZE*1.5))

            for _ in 1...herdsize
            {
                
                let tempEnt=EntityClass(theScene: self, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), message: msg, number: entityHerdCount)
                print("Entity\(entityHerdCount)")
                
                tempEnt.sprite.zRotation=random(min: 0, max: CGFloat.pi*2)
                map.entList.append(tempEnt)
                entityHerdCount+=1
                
            } // for each member of the herd
            
        } // if we're spawning EntityClass
        
        if type==ELEPHANTHERD
        {
            let herdsize=Int(random(min: ELEPHANTHERDSIZE*0.5, max: ELEPHANTHERDSIZE*1.5))
            
            let herdLeader=ElephantClass(theScene: self, pos: loc, message: msg, number: elephantHerdCount, isLeader: true, theMap: map)
            herdLeader.sprite.zRotation=random(min: 0, max: CGFloat.pi*2)
            map.elephantList.append(herdLeader)
            
            let leaderIndex=map.elephantList.count-1
            elephantHerdCount+=1
            
            for _ in 1..<herdsize
            {
                
                let tempEnt=ElephantClass(theScene: self, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), message: msg, number: elephantHerdCount, leader: map.elephantList[leaderIndex], theMap: map)
                print(tempEnt.name)
                
                tempEnt.sprite.zRotation=random(min: 0, max: CGFloat.pi*2)
                map.elephantList.append(tempEnt)
                elephantHerdCount+=1
                
            } // for each member of the herd
            
        } // if we're spawning ElephantClass
        
    } // func spawnHerd
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        map.timePlus()
        
        checkKeys()
        updateInfo()
        updateSelected()
        
        
        currentCycle+=1
        if currentCycle > 2
        {
            currentCycle=0
        }
        for i in 0..<map.entList.count
        {
            let updateReturn=map.entList[i].update(cycle: currentCycle)
            if updateReturn > -1 && isSelected
            {
                if map.entList[i].name==selectedEntity!.name
                {
                    isSelected=false
                    selectedEntity=nil
                } // if the selected entity dies
            } // if something dies
        } // for each entity
        
        for i in 0..<map.elephantList.count
        {
            let updateReturn=map.elephantList[i].update(cycle: currentCycle)
            if updateReturn > -1 && isSelected
            {
                if map.elephantList[i].name==selectedEntity!.name
                {
                    isSelected=false
                    selectedEntity=nil
                } // if the selected entity dies
            } // if something dies
        } // for each elephant
        
        // clean up entList
        for i in 0..<map.entList.count
        {
            if !map.entList[i].isAlive()
            {
                map.entList.remove(at: i)
                break
            }
        } // for each entity
        
        // clean up entList
        for i in 0..<map.elephantList.count
        {
            if !map.elephantList[i].isAlive()
            {
                map.elephantList.remove(at: i)
                break
            }
        } // for each entity

        
    } // update
} // GameScene

