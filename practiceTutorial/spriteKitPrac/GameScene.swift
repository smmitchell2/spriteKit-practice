//
//  GameScene.swift
//  spriteKitPrac
//
//  Created by Aime Student2 on 1/17/17.
//  Copyright © 2017 Aime Student2. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    //1
    let player = SKSpriteNode(imageNamed: "player")
    override func didMove(to view: SKView) {
        //2
        backgroundColor = SKColor.green
        //3
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        //4
        addChild(player)
    }
}
