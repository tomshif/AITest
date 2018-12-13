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
    
    
    var upPressed:Bool=false
    var downPressed:Bool=false
    var leftPressed:Bool=false
    var rightPressed:Bool=false
    
    var myCam=SKCameraNode()

    override func didMove(to view: SKView) {
        backgroundColor=NSColor.white
        
        camera=myCam
        addChild(myCam)
        
        centerPoint.fillColor=NSColor.black
        addChild(centerPoint)

    } // didMove
    
    
    func touchDown(atPoint pos : CGPoint) {

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
    
        
    } // checkKeys
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        checkKeys()
        
        
    } // update
} // GameScene

