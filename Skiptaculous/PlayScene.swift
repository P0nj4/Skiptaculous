//
//  PlayScene.swift
//  Skiptaculous
//
//  Created by German Pereyra on 7/23/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

import SpriteKit

class PlayScene : SKScene {
    
    let runningBar = SKSpriteNode(imageNamed: "bar")
    var originBarPosition = CGFloat(0)
    var xMaxBar = CGFloat(0)
    var groundSpeed = CGFloat(2)
    
    override func didMoveToView(view: SKView!) {
        println("play scene displayed")
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        
        self.runningBar.anchorPoint = CGPointMake(0, 0);

        self.runningBar.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.view.bounds))
        self.addChild(self.runningBar);
        
        self.xMaxBar = self.runningBar.size.width - CGRectGetMaxX(self.frame)
        self.xMaxBar *= -1
    }
    
    override func update(currentTime: NSTimeInterval) {
        if(self.runningBar.position.x <= xMaxBar){
            self.runningBar.position.x = self.originBarPosition
        }
        
        self.runningBar.position.x -= self.groundSpeed;
    
    }
}