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
    let hero = SKSpriteNode(imageNamed: "hero")
    var originBarPosition = CGFloat(0)
    var xMaxBar = CGFloat(0)
    var groundSpeed = CGFloat(2)
    var heroBaseLine = CGFloat(0)
    var velocityY = CGFloat(0)
    var onTheGround = true
    var gravity = CGFloat(0.6)
    
    override func didMoveToView(view: SKView!) {
        println("play scene displayed")
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        
        self.runningBar.anchorPoint = CGPointMake(0, 0);

        self.runningBar.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.view.bounds))
        self.addChild(self.runningBar);
        
        self.xMaxBar = self.runningBar.size.width - CGRectGetMaxX(self.frame)
        self.xMaxBar *= -1

        self.hero.position = CGPointMake(CGRectGetMinX(self.frame) + self.hero.size.width / 2, self.runningBar.position.y + self.runningBar.size.height + (self.hero.size.height / 2))

        self.heroBaseLine = self.hero.position.y
        self.addChild(hero)
    }
    
    override func update(currentTime: NSTimeInterval) {
        // ground move
        if(self.runningBar.position.x <= xMaxBar){
            self.runningBar.position.x = self.originBarPosition
        }
        self.runningBar.position.x -= self.groundSpeed;
        
        
        // hero rotation
        var degreeRotation = (self.groundSpeed * 3) * 3.14 / 180
        self.hero.zRotation -= CGFloat(degreeRotation)
        
        

        // Jump
        self.velocityY += self.gravity
        self.hero.position.y -= self.velocityY;
        if self.hero.position.y < self.heroBaseLine {
            self.hero.position.y = self.heroBaseLine
            velocityY = 0.0
            self.onTheGround = true
        }
    
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        if onTheGround {
            self.velocityY = -18
            self.onTheGround = false
            
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        if self.velocityY < -9.0 {
            self.velocityY = -9.0
        }
    }
}