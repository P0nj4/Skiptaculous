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
    let block1 = SKSpriteNode(imageNamed: "block1")
    let block2 = SKSpriteNode(imageNamed: "block2")
    let footballPlayer = SKSpriteNode(imageNamed: "footballPlayer")
    let ball = SKSpriteNode(imageNamed: "ball")
    var originBarPosition = CGFloat(0)
    var xMaxBar = CGFloat(0)
    var groundSpeed = CGFloat(2)
    var velocityY = CGFloat(0)
    var onTheGround = true
    var gravity = CGFloat(0.6)
    var blockStatuses : Dictionary <String, BlockStatus> = [:]
    var scoreText = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0
    var initialBallPosition = CGPointMake(0, 0)
    var jugglingBallMaxPosY = CGFloat(0)
    var ballMovement = CGFloat(-1)
    
    enum colliderType:UInt32 {
        case ballCategory = 1
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

        
        
        //football player
        self.footballPlayer.position = CGPointMake(self.footballPlayer.frame.width / 2 + 4, self.runningBar.frame.height + self.footballPlayer.frame.height / 2)
        
        
        //ball
        self.ball.position = CGPointMake((self.footballPlayer.position.x + self.footballPlayer.frame.width / 2) - self.ball.frame.width / 2, self.runningBar.frame.height + self.footballPlayer.frame.height / 2 - 4)
        self.ball.name = "ball"
        
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: (self.ball.frame.width / 2))
        self.ball.physicsBody!.affectedByGravity = false
        self.ball.physicsBody!.dynamic = true
        self.ball.physicsBody!.categoryBitMask = colliderType.ballCategory.toRaw()
        self.ball.physicsBody!.contactTestBitMask = colliderType.blockType.toRaw()
        self.ball.physicsBody!.collisionBitMask = colliderType.blockType.toRaw()
        
        self.initialBallPosition = self.ball.position
        self.jugglingBallMaxPosY = self.ball.position.y + 10
        
        
        

        //adding blocks
        self.block1.position = CGPointMake(CGRectGetMaxX(self.view.bounds) + self.block1.frame.size.width / 2, self.runningBar.size.height + self.block1.size.height / 2);
        
        self.block2.position = CGPointMake(CGRectGetMaxX(self.view.bounds) + self.block2.frame.size.width / 2 + self.block1.size.width  , self.runningBar.size.height + self.block2.size.height / 2);
        
        self.block1.name = "block1";
        self.block2.name = "block2";
        

        self.blockStatuses["block1"] = BlockStatus(isRunning: false, timeGapForNextRun: self.random(), currentInterval: UInt32(0))
        self.blockStatuses["block2"] = BlockStatus(isRunning: false, timeGapForNextRun: self.random(), currentInterval: UInt32(0))
        
        self.addPhysicsBody(self.block1)
        self.addPhysicsBody(self.block2)
        
        self.addChild(self.block1)
        self.addChild(self.block2)
        self.addChild(self.footballPlayer)
        self.addChild(self.ball)
        
        
        //ScoreText
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.height - self.scoreText.frame.height - 10)
        self.addChild(self.scoreText)
    }
    
    var fpsCount = 0
    override func update(currentTime: NSTimeInterval) {
        // ground move
        if(self.runningBar.position.x <= xMaxBar){
            self.runningBar.position.x = self.originBarPosition
        }
        self.runningBar.position.x -= self.groundSpeed * 2;
        
        
        // hero rotation
        var degreeRotation = (self.groundSpeed * 3) * 3.14 / 180
        self.ball.zRotation += CGFloat(degreeRotation)
        
        

        // Jump
        self.velocityY += self.gravity
        if !self.onTheGround {
            self.ball.position.y -= self.velocityY;
        }
        if self.ball.position.y < self.initialBallPosition.y{
            self.ball.position = self.initialBallPosition
            velocityY = 0.0
            self.onTheGround = true
        }
        
        fpsCount++
        self.blockRunning()
        self.jugglingBall()
    }
    
    func myceil(f: CGFloat) -> CGFloat {
        return ceil(f)
    }
    
    
    func jugglingBall(){
        
        fpsCount = (fpsCount > 16 ? 0 : fpsCount)
        
        if fpsCount % 1 == 0 {
            if Int(self.ball.position.y) == Int(self.initialBallPosition.y) {
                self.ballMovement *= -1
            }
            if Int(self.ball.position.y) == Int(self.jugglingBallMaxPosY){
                    self.ballMovement *= -1
            }
            self.ball.position.y += self.ballMovement
        }
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
                var cannotRun = (block1.position.x > CGRectGetMinX(block2.frame) && block1.position.x < CGRectGetMaxX(block2.frame)) || (block2.position.x > CGRectGetMinX(block1.frame) && block2.position.x < CGRectGetMaxX(block1.frame))
                if !cannotRun {
                    currStatus.timeGap = self.random()
                    currStatus.currentInterval = 0
                    currStatus.isRunning = true
                }
                
            }
            if currStatus.isRunning {
                if let thisBlock = self.childNodeWithName(blk) {
                    
                    if thisBlock.position.x > (thisBlock.frame.size.width) * -1 {
                        // in movement
                        thisBlock.position.x -= CGFloat(self.groundSpeed * 2)
                    }else{
                        // off the screen
                        if thisBlock.name != "block2"{
                            thisBlock.position.x = CGRectGetMaxX(self.view.bounds) + thisBlock.frame.size.width / 2;
                        }else{
                            thisBlock.position.x = CGRectGetMaxX(self.view.bounds) + self.block2.frame.size.width / 2 + self.block1.size.width
                        }
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
    
    func addPhysicsBody(enemyPlayer:SKSpriteNode) {
        println("adding physics to sprite " + enemyPlayer.name)
        
        if enemyPlayer.name == "block1" {
            var offsetX = enemyPlayer.frame.size.width * enemyPlayer.anchorPoint.x;
            var offsetY = enemyPlayer.frame.size.height * enemyPlayer.anchorPoint.y;
            
            var path:CGMutablePathRef = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, nil, 18 - offsetX, 56 - offsetY);
            CGPathAddLineToPoint(path, nil, 11 - offsetX, 46 - offsetY);
            CGPathAddLineToPoint(path, nil, 6 - offsetX, 37 - offsetY);
            CGPathAddLineToPoint(path, nil, 10 - offsetX, 33 - offsetY);
            CGPathAddLineToPoint(path, nil, 20 - offsetX, 36 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 23 - offsetY);
            CGPathAddLineToPoint(path, nil, 15 - offsetX, 16 - offsetY);
            CGPathAddLineToPoint(path, nil, 26 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 59 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 26 - offsetX, 53 - offsetY);
            
            CGPathCloseSubpath(path);
            
            enemyPlayer.physicsBody = SKPhysicsBody(polygonFromPath: path)
            
        }else {
            
            var offsetX = enemyPlayer.frame.size.width * enemyPlayer.anchorPoint.x;
            var offsetY = enemyPlayer.frame.size.height * enemyPlayer.anchorPoint.y;
            
            var path:CGMutablePathRef = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, nil, 2 - offsetX, 55 - offsetY);
            CGPathAddLineToPoint(path, nil, 9 - offsetX, 4 - offsetY);
            CGPathAddLineToPoint(path, nil, 26 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 21 - offsetX, 52 - offsetY);
            
            CGPathCloseSubpath(path);
            
            enemyPlayer.physicsBody = SKPhysicsBody(polygonFromPath: path)
            
            
            
        }
        enemyPlayer.physicsBody!.dynamic = false
        enemyPlayer.physicsBody!.categoryBitMask = colliderType.blockType.toRaw()
        //enemyPlayer.physicsBody!.contactTestBitMask = colliderType.ballCategory.toRaw()
        enemyPlayer.physicsBody!.collisionBitMask = colliderType.ballCategory.toRaw()

        
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
        println("hero has been touched by a something \(contact.bodyA.node.name) and \(contact.bodyB.node.name)")
        /*
        if contact.bodyB.categoryBitMask == colliderType.ballCategory.toRaw() {
            println("hero has been touched by a something")
        }
*/
        died()
    }
    
}