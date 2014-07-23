//
//  PlayScene.swift
//  Skiptaculous
//
//  Created by German Pereyra on 7/23/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

import SpriteKit

class PlayScene : SKScene {
    
    override func didMoveToView(view: SKView!) {
        println("play scene displayed")
        self.backgroundColor = UIColor(hex: 0x80D9FF)
    }
    
}