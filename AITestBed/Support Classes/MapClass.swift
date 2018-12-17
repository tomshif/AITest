//
//  MapClass.swift
//  AITestBed
//
//  Created by Tom Shiflet on 12/14/18.
//  Copyright © 2018 Liberty Game Dev. All rights reserved.
//

import Foundation
import SpriteKit

class MapClass
{
    var zoneList=[ZoneClass]()
    var entList=[EntityClass]()
    var elephantList=[ElephantClass]()
    
    func clearAll()
    {

        for zone in zoneList
        {
            zone.sprite.removeFromParent()
        }
        
        for ent in entList
        {
            ent.sprite.removeFromParent()
        }
        
        for ele in elephantList
        {
            ele.sprite.removeFromParent()
        }
        
        zoneList.removeAll()
        entList.removeAll()
        elephantList.removeAll()

        
    
    } // func removeAll
    
    
} // MapClass
