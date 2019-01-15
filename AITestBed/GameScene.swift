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
    let bgGrid=SKSpriteNode(imageNamed: "bgGrid01")
    
    let infoTitle=SKLabelNode(fontNamed: "Arial")
    let infoAge=SKLabelNode(fontNamed: "Arial")
    let infoState=SKLabelNode(fontNamed: "Arial")
    let infoLeader=SKLabelNode(fontNamed: "Arial")
    let infoGender=SKLabelNode(fontNamed: "Arial")
    let infoHunger=SKLabelNode(fontNamed: "Arial")
    let infoThirst=SKLabelNode(fontNamed: "Arial")
    let infoHerdLeader=SKLabelNode(fontNamed: "Arial")
    let infoTurning=SKLabelNode(fontNamed: "Arial")
    let infoHeading=SKLabelNode(fontNamed: "Arial")
    
    
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
    var isGamePaused:Bool=false
    
    
    var myCam=SKCameraNode()

    

    //var zoneList=[ZoneClass]()
    
    var currentCycle:Int=0
    var currentMode:Int=0
    var entityHerdCount:Int=0
    var saddlecatHerdCount:Int=0
    
    
    let SELECTMODE:Int=0
    let ENTITYMODE:Int=2
    let SADDLECATMODE:Int=4
    let SPRINGBOKMODE:Int=6
    let ZEBRAMODE:Int=8
    let CHEETAHMODE:Int=9
    let FOODZONEMODE:Int=10
    let WATERZONEMODE:Int=12
    let OBSTACLEMODE:Int=14
    let RESTZONEMODE:Int=16
    let BIRDMODE:Int=18
    
    let MAXUPDATECYCLES:Int=3
    
    var TIMESCALE:CGFloat=1.0
    
    let ENTITYHERD:Int=0
    let SADDLECATHERD:Int=2
    let BIRDFLOCK:Int=4
    let ZEBRAHERD:Int=6
    let SPRINGBOKHERD:Int=8
    let CHEETAHHERD:Int=10
    
    
    let BIRDCOUNT:Int=100
    
    let MAPHEIGHT:Int=32
    let MAPWIDTH:Int=32
    
    
    let ENTITYHERDSIZE:CGFloat=10
    let BIRDFLOCKSIZE:Int=20
    
    //var msg=MessageClass()
    
    
    
    
    
    override func didMove(to view: SKView) {
        backgroundColor=NSColor.white
        map.mapBorder=CGFloat(MAPWIDTH)*256/2-(128)
        
        camera=myCam
        myCam.name="myCamera"
        myCam.zPosition=999999999
        
        addChild(myCam)
        
        drawBGGrid()
        
        timeLabel.position.y = -size.height*0.45
        timeLabel.zPosition = 540
        timeLabel.fontSize = 48
        timeLabel.fontColor=NSColor.black
        timeLabel.name="timeLabel"
        myCam.addChild(timeLabel)
        
        
        
        infoBG.zPosition=500
        infoBG.name="infoBG"
        infoBG.position.x=size.width/2-infoBG.size.width/2
        infoBG.position.y=size.height/2-infoBG.size.height/2
        myCam.addChild(infoBG)
        
        msgBG.zPosition=500
        msgBG.name="msgBG"
        msgBG.position.x = -size.width/2+msgBG.size.width/2
        msgBG.position.y = -size.height/2+msgBG.size.height/2
        msgBG.alpha=0.0
        myCam.addChild(msgBG)
        
        msgLabel.zPosition=540
        msgLabel.text=""
        msgLabel.name="MsgLabel"
        msgLabel.fontSize=24
        msgLabel.fontColor=NSColor.yellow
        msgLabel.numberOfLines=3
        msgLabel.preferredMaxLayoutWidth=msgBG.size.width*0.95
        msgBG.addChild(msgLabel)
        
        
        infoTitle.zPosition=540
        infoTitle.fontColor=NSColor.yellow
        infoTitle.text="Entity000"
        infoTitle.name="InfoTitle"
        infoTitle.position.y=infoBG.size.height*0.40
        infoBG.addChild(infoTitle)
        
        infoAge.zPosition=540
        infoAge.fontColor=NSColor.yellow
        infoAge.fontSize=22
        infoAge.text="infoAge"
        infoAge.name="InfoAge"
        infoAge.position.y=infoBG.size.height*0.2
        infoBG.addChild(infoAge)
        
        infoState.zPosition=540
        infoState.fontColor=NSColor.yellow
        infoState.fontSize=22
        infoState.text="InfoState"
        infoState.name="InfoState"
        infoState.position.y=infoBG.size.height*0.15
        infoBG.addChild(infoState)
        
        infoLeader.zPosition=540
        infoLeader.fontColor=NSColor.yellow
        infoLeader.fontSize=22
        infoLeader.text="InfoLeader"
        infoLeader.name="InfoLeader"
        infoLeader.position.y = infoBG.size.height*0.1
        infoBG.addChild(infoLeader)
        
        infoGender.zPosition=540
        infoGender.fontColor=NSColor.yellow
        infoGender.fontSize=22
        infoGender.text="InfoGender"
        infoGender.name="InfoGender"
        infoGender.position.y = infoBG.size.height*0.05
        infoBG.addChild(infoGender)
        
        infoHunger.zPosition=540
        infoHunger.fontColor=NSColor.yellow
        infoHunger.fontSize=22
        infoHunger.text="infoHunger"
        infoHunger.name="infoHunger"
        infoHunger.position.y = 0
        infoBG.addChild(infoHunger)
        
        infoThirst.zPosition=540
        infoThirst.fontColor=NSColor.yellow
        infoThirst.fontSize=22
        infoThirst.text="infoThirst"
        infoThirst.name="infoThirst"
        infoThirst.position.y = -infoBG.size.height*0.05
        infoBG.addChild(infoThirst)
        
        infoHerdLeader.zPosition=540
        infoHerdLeader.fontColor=NSColor.yellow
        infoHerdLeader.fontSize=22
        infoHerdLeader.text="infoHerdLeader"
        infoHerdLeader.name="infoHerdLeader"
        infoHerdLeader.position.y = -infoBG.size.height*0.1
        infoBG.addChild(infoHerdLeader)
        
        infoTurning.zPosition=540
        infoTurning.fontColor=NSColor.yellow
        infoTurning.fontSize=22
        infoTurning.text="infoTurning"
        infoTurning.name="infoTurning"
        infoTurning.position.y = -infoBG.size.height*0.15
        infoBG.addChild(infoTurning)
        
        infoHeading.zPosition=540
        infoHeading.fontColor=NSColor.yellow
        infoHeading.fontSize=22
        infoHeading.text="infoHeading"
        infoHeading.name="infoHeading"
        infoHeading.position.y = -infoBG.size.height*0.20
        infoBG.addChild(infoHeading)
        
        centerPoint.fillColor=NSColor.black
        centerPoint.name="CenterPoint"
        centerPoint.zPosition=2
        addChild(centerPoint)
        
        selectedSquare.isHidden=true
        selectedSquare.name="selectedSquare"
        selectedSquare.zPosition=50
        addChild(selectedSquare)
        
        
    } // didMove
    
    func drawBGGrid()
    {
        
        let blx = -bgGrid.size.width*CGFloat(MAPWIDTH)/2
        let bly = -bgGrid.size.height*CGFloat(MAPHEIGHT)/2
        for y in 0..<MAPHEIGHT
        {
            for x in 0..<MAPWIDTH
            {
                let grid=bgGrid.copy() as! SKSpriteNode
                grid.position.x = blx+CGFloat(x)*grid.size.width
                grid.position.y = bly+CGFloat(y)*grid.size.height
                grid.zPosition = 0
                grid.name="bgGrid"
                addChild(grid)
                
            } // for each x
            
        } // for each y
    }
    
    func touchDown(atPoint pos : CGPoint) {

        if currentMode==SELECTMODE
        {
            var temp:String=""
            isSelected=false
            
            for node in nodes(at: pos)
            {
                if (node.name?.contains("ent"))! || (node.name?.contains("infoHunger"))!
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
                
            } // if we have something selected
    
        } // if we're in select mode
        
        if currentMode==ENTITYMODE
        {
            spawnHerd(type: ENTITYHERD, loc: pos)
            
        } // if we're in entity spawn mode
        
        if currentMode==SADDLECATMODE
        {
            spawnHerd(type: SADDLECATHERD, loc: pos)
        }
        
        if currentMode==ZEBRAMODE
        {
            spawnHerd(type: ZEBRAHERD, loc: pos)
        }
        
        if currentMode==CHEETAHMODE
        {
            spawnHerd(type: CHEETAHHERD, loc: pos)
        }
        
        if currentMode==SPRINGBOKMODE
        {
            spawnHerd(type: SPRINGBOKHERD, loc: pos)
        }
        
        if currentMode==BIRDMODE
        {
            spawnHerd(type: BIRDFLOCK, loc: pos)
        }
        
        if currentMode==FOODZONEMODE
        {
            let tempZone=ZoneClass(zoneType: ZoneType.FOODZONE, pos: pos, theScene: self)
            map.zoneList.append(tempZone)
        } // if we're spawning food zones
        
        if currentMode==WATERZONEMODE
        {
            let tempZone=ZoneClass(zoneType: ZoneType.WATERZONE, pos: pos, theScene: self)
            map.zoneList.append(tempZone)
        } // if we're spawnin water zones
        
        if currentMode==RESTZONEMODE
        {
            let tempZone=ZoneClass(zoneType: ZoneType.RESTZONE, pos: pos, theScene: self)
            map.zoneList.append(tempZone)
        } // if we're spawning rest zones
        
        if currentMode==OBSTACLEMODE
        {
            let obRect=CGSize(width: 128, height: 128)
            let obstacle=SKShapeNode(rectOf: obRect, cornerRadius: 5)
            obstacle.position=pos
            obstacle.zPosition = -5
            obstacle.fillColor=NSColor.blue
            obstacle.name="Water"
            addChild(obstacle)
        } // if we're spawning obstacles
        
    } // touchDown
    
    func touchMoved(toPoint pos : CGPoint) {

    } // touchMoved
    
    func touchUp(atPoint pos : CGPoint) {

    } // touchUp
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    } // mouseDown
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    } // mouseDragged
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    } // mouseUp
    
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
                map.msg.sendCustomMessage(message: "Follow mode off")
            }
            else
            {
                followModeOn=true
                map.msg.sendCustomMessage(message: "Follow mode on.")
            }
            
        case 11:
            currentMode=BIRDMODE
            map.msg.sendCustomMessage(message: "Spawn bird flock mode.")
            selectedEntity=nil
            isSelected=false
            
        case 13:
            upPressed=true
            
        case 18: // 1
            currentMode=SPRINGBOKMODE
            map.msg.sendCustomMessage(message: "Spawn springbok mode.")
            selectedEntity=nil
            isSelected=false
            
        case 19: // 2
            currentMode=ZEBRAMODE
            map.msg.sendCustomMessage(message: "Spawn zebra mode.")
            selectedEntity=nil
            isSelected=false
            
        case 20: // 3
            currentMode=CHEETAHMODE
            map.msg.sendCustomMessage(message: "Spawn cheetah mode.")
            selectedEntity=nil
            isSelected=false
            
        case 27: // -
            zoomOutPressed=true
            
        case 24: // +
            zoomInPressed=true
            
        case 23: // 5
            currentMode=WATERZONEMODE
            map.msg.sendCustomMessage(message: "Spawn water zone mode.")
            selectedEntity=nil
            isSelected=false

        case 22: // 6
            currentMode=FOODZONEMODE
            map.msg.sendCustomMessage(message: "Spawn food zone mode.")
            selectedEntity=nil
            isSelected=false
         
        case 25: // 9
            currentMode=SADDLECATMODE
            map.msg.sendCustomMessage(message: "Spawn saddlecat mode.")
            selectedEntity=nil
            isSelected=false
            
        case 26: // 7
            currentMode=RESTZONEMODE
            map.msg.sendCustomMessage(message: "Spawn rest zone mode.")
            selectedEntity=nil
            isSelected=false
            
            
        case 29: // 0
            currentMode=ENTITYMODE
            map.msg.sendCustomMessage(message: "Spawn entity mode.")
            selectedEntity=nil
            isSelected=false
            
        case 30: // [
            if !map.increaseTimeScale()
            {
                map.msg.sendCustomMessage(message: "16x - Maximum time acceleration.")
            }
            
        case 33: // ]
            if !map.decreaseTimeScale()
            {
                map.msg.sendCustomMessage(message: "1x - Minimum time acceleration.")
            }
            
            
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
            map.msg.sendCustomMessage(message: "Select mode.")
            
            
        case 37: // L
            currentMode=OBSTACLEMODE
            map.msg.sendCustomMessage(message: "Spawn obstacle mode.")
            
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

                var index:Int = -1
                for i in 0..<map.entList.count
                {
                    if map.entList[i].name==selectedEntity!.name
                    {
                        index=i
                    } // if it's a match
                    
                } // for each entity
                index+=1
                if index > map.entList.count-1
                {
                    index=0
                }
                selectedEntity=map.entList[index]
                if (!myCam.contains(selectedEntity!.sprite))
                {
                    myCam.position=selectedEntity!.sprite.position
                }
            } // if something is selected
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
                
                
                if index > -1 && selectedEntity!.name.contains("ent")
                {
                    map.msg.sendMessage(type: map.msg.DEATH_DISEASE, from: selectedEntity!.name)
                    selectedEntity!.die()
                    selectedEntity=nil
                    isSelected=false
                    
                } // if we have something to delete and it's an entity

                
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
            map.msg.clearAll()
            isSelected=false
            selectedEntity=nil
            
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        } // switch
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
        } // switch
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
            infoTurning.text="isTurning: \(selectedEntity!.checkTurning())"
            infoHeading.text=String(format: "Heading: %2.3f",selectedEntity!.sprite.zRotation)
            if selectedEntity!.herdLeader != nil
            {
                infoHerdLeader.text="Herd Leader: \(selectedEntity!.herdLeader!.name)"
            }
            
        } // if something is selected
        else
        {
            infoBG.isHidden=true
        }
    
        timeLabel.text="\(map.getTimeAsString()) - timeScale: \(map.getTimeScale())"
        
        if map.msg.getUnreadCount() > 0
        {
            msgBG.removeAllActions()
            msgBG.alpha=1.0
            msgLabel.text=map.msg.readNextMessage()
            let runAction=SKAction.sequence([SKAction.wait(forDuration: 4.0), SKAction.fadeOut(withDuration: 1.0)])
            msgBG.run(runAction)
            //msgBG.run(SKAction.fadeOut(withDuration: 5.0))
        } // if we have unread messages
        
        
        
        
    } // func updateInfo
    
    
    func spawnHerd(type: Int, loc: CGPoint)
    {
        if type==ENTITYHERD
        {
            let herdsize=Int(random(min: ENTITYHERDSIZE*0.5, max: ENTITYHERDSIZE*1.5))

            for _ in 1...herdsize
            {
                
                let tempEnt=EntityClass(theScene: self, theMap: map, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), number: entityHerdCount)
                print("Entity\(entityHerdCount)")
                
                tempEnt.sprite.zRotation=random(min: 0, max: CGFloat.pi*2)
                map.entList.append(tempEnt)
                entityHerdCount+=1
                
            } // for each member of the herd
            
        } // if we're spawning EntityClass
        
        
        if type==SADDLECATHERD
        {
            let herdsize=Int(random(min: ENTITYHERDSIZE*0.5, max: ENTITYHERDSIZE*1.5))
            
            for _ in 1...herdsize
            {
                
                let tempCat=SaddlecatClass(theScene: self, theMap: map, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), number: saddlecatHerdCount)
                print(tempCat.name)
                
                tempCat.sprite.zRotation=random(min: 0, max: CGFloat.pi*2)
                map.entList.append(tempCat)
                saddlecatHerdCount+=1
                
            } // for each member of the herd
            
        } // if saddlecat
        
        if type==CHEETAHHERD
        {
            let tempCheetah=CheetahClass(theScene: self, theMap: map, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), number: entityHerdCount)
            print(tempCheetah.name)
            
            tempCheetah.sprite.zRotation=random(min: 0, max: CGFloat.pi*2)
            map.entList.append(tempCheetah)
            entityHerdCount+=1
        } // if we're spawning a Cheetah (single)
        
        if type==ZEBRAHERD
        {
            let herdsize=Int(random(min: ENTITYHERDSIZE*0.5, max: ENTITYHERDSIZE*1.5))
            let tempZebraLeader=ZebraClass(theScene: self, theMap: map, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), number: entityHerdCount,leader: nil)
            map.entList.append(tempZebraLeader)
            for _ in 1...herdsize
            {
                
                let tempZebra=ZebraClass(theScene: self, theMap: map, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), number: entityHerdCount, leader: tempZebraLeader)
                print(tempZebra.name)
                
                tempZebra.sprite.zRotation=random(min: 0, max: CGFloat.pi*2)
                map.entList.append(tempZebra)
                entityHerdCount+=1
                
            } // for each member of the herd
        } // if we're spawning a Zebra herd
        
        if type==SPRINGBOKHERD
        {
            let herdsize=Int(random(min: ENTITYHERDSIZE*0.5, max: ENTITYHERDSIZE*1.5))
            let tempSBLeader=SpringbokClass(theScene: self, theMap: map, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), number: entityHerdCount, leader: nil)
            map.entList.append(tempSBLeader)
            for _ in 1...herdsize
            {
                
                let tempSpringbok=SpringbokClass(theScene: self, theMap: map, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), number: entityHerdCount, leader:tempSBLeader)
                print(tempSpringbok.name)
                
                tempSpringbok.sprite.zRotation=random(min: 0, max: CGFloat.pi*2)
                map.entList.append(tempSpringbok)
                entityHerdCount+=1
                
            } // for each member of the herd
            
        } // if we're spawning a Springbok herd
        
       if type==BIRDFLOCK
       {
            let tempLeaderBird=BirdClass(theMap: map, theScene: self, pos: loc, isLdr: true, ldr: nil)
            tempLeaderBird.sprite.zRotation=random(min:0, max:CGFloat.pi*2)
            map.birdList.append(tempLeaderBird)
            let birdNum=Int(random(min: 1, max: CGFloat(BIRDFLOCKSIZE)))
            for _ in 1...birdNum
            {
                let tempBird=BirdClass(theMap: map, theScene: self, pos: CGPoint(x: random(min: loc.x-size.width/10, max: loc.x+size.width/10), y: random(min: loc.y-size.height/10, max: loc.y+size.height/10)), isLdr: false, ldr: tempLeaderBird)
                tempBird.sprite.zRotation=random(min:0,max:CGFloat.pi*2)
                map.birdList.append(tempBird)
                
            } // for each bird in the flock
        } // if we're spawning a bird flock
        
    } // func spawnHerd
    
    func checkAmbientSpawns()
    {
        
        if map.birdList.count < BIRDCOUNT
        {
            let chance=random(min: 0, max: 1.0)
            if chance > 0.98
            {
            spawnHerd(type: BIRDFLOCK, loc: CGPoint(x: random(min: -map.mapBorder*0.8, max: map.mapBorder*0.8), y: random(min: -map.mapBorder*0.8, max: map.mapBorder*0.8)))
            } // chance
        } // if we have too few birds
        
    } // func checkAmbientSpawns
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if !isGamePaused
        {
            map.timePlus()
            
            checkKeys()
            updateInfo()
            updateSelected()
            checkAmbientSpawns()
            
            currentCycle+=1
            if currentCycle > MAXUPDATECYCLES
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
            
            // update birds
            for i in 0..<map.birdList.count
            {
                map.birdList[i].update(cycle: currentCycle)
            }
            
            
            map.cleanUpEntities()
            

            
        } // if we're not paused
    } // update
} // GameScene

