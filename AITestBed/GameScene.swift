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
    
    var centerPoint=SKShapeNode(circleOfRadius: 10)
    
    var infoBG=SKSpriteNode(imageNamed: "informationBG")
    var msgBG=SKSpriteNode(imageNamed: "messageBG")
    let selectedSquare=SKSpriteNode(imageNamed: "selectedSquare")
    
    
    let infoTitle=SKLabelNode(fontNamed: "Arial")
    let infoAge=SKLabelNode(fontNamed: "Arial")
    let infoState=SKLabelNode(fontNamed: "Arial")
    
    let msgLabel=SKLabelNode(fontNamed: "Arial")
    
    var selectedEntity:EntityClass?
    
    
    
    var upPressed:Bool=false
    var downPressed:Bool=false
    var leftPressed:Bool=false
    var rightPressed:Bool=false
    var zoomInPressed:Bool=false
    var zoomOutPressed:Bool=false
    var isSelected:Bool=false
    
    var myCam=SKCameraNode()

    
    var entList=[EntityClass]()
    
    
    var currentCycle:Int=0
    var currentMode:Int=0
    var entityHerdCount:Int=0
    
    let SELECTMODE:Int=0
    let ENTITYMODE:Int=2
    
    let ENTITYHERD:Int=0
    
    let ENTITYHERDSIZE:CGFloat=10
    
    var msg=MessageClass()
    
    
    
    
    
    override func didMove(to view: SKView) {
        backgroundColor=NSColor.white
        
        camera=myCam
        myCam.name="myCamera"
        addChild(myCam)
        
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
        
        centerPoint.fillColor=NSColor.black
        centerPoint.name="CenterPoint"
        addChild(centerPoint)
        
        selectedSquare.isHidden=true
        addChild(selectedSquare)
        
        
    } // didMove
    
    
    func touchDown(atPoint pos : CGPoint) {

        if currentMode==SELECTMODE
        {
            var temp:String=""
            isSelected=false
            
            for node in nodes(at: pos)
            {
                if (node.name?.contains("Entity"))!
                {
                    temp=node.name!
                    isSelected=true
                } // if we have a match

            } // for each node
           
            
            
            if isSelected
            {
                for i in 0..<entList.count
                {
                    if entList[i].name==temp
                    {
                        selectedEntity=entList[i]
                        break
                    } // if we have a match
                } // for each entity
            }
        } // if we're in select mode
        
        if currentMode==ENTITYMODE
        {
            spawnHerd(type: 0)
            
        } // if we're in entity spawn mode
        
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
            
        case 13:
            upPressed=true
            
        case 27:
            zoomOutPressed=true
            
        case 24:
            zoomInPressed=true
            
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
            
        case 46:
            if msgBG.isHidden
            {
                msgBG.isHidden=false
            }
            else
            {
                msgBG.isHidden=true
            }
        case 49:
            myCam.position=CGPoint(x: 0, y: 0)
        
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
            
        } // if something is selected
        else
        {
            infoBG.isHidden=true
        }
    
        if msg.getUnreadCount() > 0
        {
            msgBG.removeAllActions()
            msgBG.alpha=1.0
            msgLabel.text=msg.readNextMessage()
            msgBG.run(SKAction.fadeOut(withDuration: 5.0))
        }
        
        
    } // func updateInfo
    
    
    func spawnHerd(type: Int)
    {
        if type==ENTITYHERD
        {
            let herdsize=Int(random(min: ENTITYHERDSIZE*0.5, max: ENTITYHERDSIZE*1.5))
            for _ in 1...herdsize
            {
                
                let tempEnt=EntityClass(theScene: self, pos: CGPoint(x: random(min: -size.width/4, max: size.width/4), y: random(min: -size.height/4, max: size.height/4)), message: msg, number: entityHerdCount)
                print("Entity\(entityHerdCount)")
                
                tempEnt.sprite.zRotation=random(min: 0, max: CGFloat.pi*2)
                entList.append(tempEnt)
                entityHerdCount+=1
                
            } // for each member of the herd
            
        } // if we're spawning EntityClass
        
    } // func spawnHerd
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        checkKeys()
        updateInfo()
        updateSelected()
        
        
        currentCycle+=1
        if currentCycle > 2
        {
            currentCycle=0
        }
        for i in 0..<entList.count
        {
            let updateReturn=entList[i].update(cycle: currentCycle)
            if updateReturn > -1 && isSelected
            {
                if entList[i].name==selectedEntity!.name
                {
                    isSelected=false
                    selectedEntity=nil
                } // if the selected entity dies
            } // if something dies
        } // for each entity
        
        // clean up entList
        for i in 0..<entList.count
        {
            if !entList[i].isAlive()
            {
                entList.remove(at: i)
                break
            }
        }
        

        
    } // update
} // GameScene

