//
//  PlayScene.swift
//  Skiptaculous
//
//  Created by German Pereyra on 7/23/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

import SpriteKit

class PlayScene : SKScene , SKPhysicsContactDelegate {
    
    let runningBar = SKSpriteNode(imageNamed: "bar")
    let hero = SKSpriteNode(imageNamed: "hero")
    let block1 = SKSpriteNode(imageNamed: "block1")
    let block2 = SKSpriteNode(imageNamed: "block2")
    var originBarPosition = CGFloat(0)
    var xMaxBar = CGFloat(0)
    var groundSpeed = CGFloat(2)
    var heroBaseLine = CGFloat(0)
    var velocityY = CGFloat(0)
    var onTheGround = true
    var gravity = CGFloat(0.6)
    var blockStatuses : Dictionary <String, BlockStatus> = [:]
    var scoreText = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0
    
    enum colliderType:UInt32 {
        case heroType = 1
        case blockType = 2
    }
    
    override func didMoveToView(view: SKView!) {
        println("play scene displayed")
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        self.physicsWorld.contactDelegate = self
        
        
        //ground
        self.runningBar.anchorPoint = CGPointMake(0, 0);
        self.runningBar.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.view.bounds))
        self.addChild(self.runningBar);
        
        self.xMaxBar = self.runningBar.size.width - CGRectGetMaxX(self.frame)
        self.xMaxBar *= -1

        //hero
        self.hero.position = CGPointMake(CGRectGetMinX(self.frame) + self.hero.size.width / 2, self.runningBar.position.y + self.runningBar.size.height + (self.hero.size.height / 2))
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: self.hero.frame.width / 2)
        self.hero.physicsBody!.affectedByGravity = false
        self.hero.physicsBody!.categoryBitMask = colliderType.heroType.toRaw()
        self.hero.physicsBody!.contactTestBitMask = colliderType.blockType.toRaw()
        self.hero.physicsBody!.collisionBitMask = colliderType.blockType.toRaw()
        //self.hero.physicsBody!.usesPreciseCollisionDetection = true
        
        self.heroBaseLine = self.hero.position.y
        self.addChild(hero)
        
        //ading blocks
        self.block1.position = CGPointMake(CGRectGetMaxX(self.view.bounds) + self.block1.frame.size.width / 2, self.heroBaseLine);
        self.block2.position = CGPointMake(CGRectGetMaxX(self.view.bounds) + self.block2.frame.size.width / 2, self.runningBar.size.height + self.block2.size.height / 2);
        
        self.block1.name = "block1";
        self.block2.name = "block2";
        

        self.blockStatuses["block1"] = BlockStatus(isRunning: false, timeGapForNextRun: self.random(), currentInterval: UInt32(0))
        self.blockStatuses["block2"] = BlockStatus(isRunning: false, timeGapForNextRun: self.random(), currentInterval: UInt32(0))
        
        self.addPhysicsBody(self.block1)
        self.addPhysicsBody(self.block2)
        
        self.addChild(self.block1)
        self.addChild(self.block2)
        
        //ScoreText
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.height - self.scoreText.frame.height - 10)
        self.addChild(self.scoreText)
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        // ground move
        if(self.runningBar.position.x <= xMaxBar){
            self.runningBar.position.x = self.originBarPosition
        }
        self.runningBar.position.x -= self.groundSpeed * 2;
        
        
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
        
        self.blockRunning()
        
    
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        if onTheGround {
            self.velocityY = -22
            self.onTheGround = false
            
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        if self.velocityY < -9.0 {
            self.velocityY = -9.0
        }
    }
    
    
    // MARK: - Private methods
    
    func blockRunning(){
        for (blk, currStatus) in self.blockStatuses {
            if currStatus.isReadyToRun() {
                currStatus.timeGap = self.random()
                currStatus.currentInterval = 0
                currStatus.isRunning = true
                
            }
            if currStatus.isRunning {
                if let thisBlock = self.childNodeWithName(blk) {
                    
                    if thisBlock.position.x > (thisBlock.frame.size.width) * -1 {
                        // in movement
                        thisBlock.position.x -= CGFloat(self.groundSpeed * 2)
                    }else{
                        // off the screen
                        thisBlock.position.x = CGRectGetMaxX(self.view.bounds) + thisBlock.frame.size.width / 2;
                        currStatus.isRunning = false;
                        self.score++;
                        if self.score % 5 == 0 {
                            self.groundSpeed++;
                        }
                        self.scoreText.text = String(self.score);
                    }
                }
            }else{
                currStatus.currentInterval++;
            }
            
        }
    }
    
    func random() -> UInt32 {
        return arc4random_uniform(100)
    }
    
    func addPhysicsBody(block:SKSpriteNode) {
        println("blockSize:\(block.size)")
        block.physicsBody = SKPhysicsBody(rectangleOfSize: block.size)
        block.physicsBody!.dynamic = false
        block.physicsBody!.categoryBitMask = colliderType.blockType.toRaw()
        //block.physicsBody!.contactTestBitMask = colliderType.heroType.toRaw()
        block.physicsBody!.collisionBitMask = colliderType.heroType.toRaw()
        //block.physicsBody!.usesPreciseCollisionDetection = true
    }
    
    func died(){
        if let startAgainScene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            let skView = self.view as SKView
            skView.ignoresSiblingOrder = true
            startAgainScene.size = skView.bounds.size;
            startAgainScene.scaleMode = .AspectFill
            skView.presentScene(startAgainScene)
        }
    }
    
    
    // MARK: Contact Delegate
    func didBeginContact(contact: SKPhysicsContact!) {
        if contact.bodyB.categoryBitMask == colliderType.heroType.toRaw() {
            println("hero has been touched by a something")
        }
        died()
    }
    
}