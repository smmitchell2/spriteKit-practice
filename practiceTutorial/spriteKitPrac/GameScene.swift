//
//  GameScene.swift
//  spriteKitPrac
//
//  Created by Aime Student2 on 1/17/17.
//  Copyright © 2017 Aime Student2. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None       : UInt32 = 0
    static let All        : UInt32 = UInt32.max
    static let Monster    : UInt32 = 0b1
    static let Projectile : UInt32 = 0b10
}

func + (left: CGPoint, right: CGPoint) -> CGPoint{
    return CGPoint(x: left.x + right.x, y:left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
    #endif

extension CGPoint{
    func length() -> CGFloat{
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate{

    //1
    let player = SKSpriteNode(imageNamed: "player")
    override func didMove(to view: SKView) {
        //2
        backgroundColor = SKColor.green
        //3
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        //4
        addChild(player)
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMonster),SKAction.wait(forDuration: 1.0)])))
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random())) / 0xFFFFFFFF
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func addMonster(){
        //create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        //determines where to spawn monster on Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        addChild(monster)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove,actionMoveDone]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        //set up  initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        
        // determine offset of location to projectile
        let offset = touchLocation - projectile.position
        //bail out if shooting down are backwards
        if(offset.x < 0){return}
        
        addChild(projectile)
        
        //get direction of where to shoot
        let direction = offset.normalized()
        
        //make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        //add shoot amount to current position
        let realDest = shootAmount + projectile.position
        //create the action
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove,actionMoveDone]))
    }
        
}
