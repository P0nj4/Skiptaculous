//
//  GameScene.swift
//  Skiptaculous
//
//  Created by German Pereyra on 7/23/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed: "play")
    
    override func didMoveToView(view: SKView) {
        self.playButton.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
        self.backgroundColor = UIColor(hex: 0x80D9FF);
        self.addChild(self.playButton);
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self);
            if self.nodeAtPoint(location) == self.playButton{
                println("play button pressed")
                var scene = PlayScene(size: self.size);
                let skView = self.view as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
        }
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
