//
//  PlayerNode.swift
//  MazApp
//
//  Created by Leonardo on 12/3/18.
//  Copyright © 2018 Leonardo. All rights reserved.
//

import SceneKit;

class CharacterNode: SCNNode {
    
    var scene: SCNScene!;
    var characterNode: SCNNode!;
    
        override init() {
            super.init();
            scene = SCNScene(named: "mainScene.scn");
            characterNode = scene.rootNode.childNode(withName: "Character", recursively: true)!;
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var directionAngle: SCNFloat = 0.0 {
        didSet {
            if directionAngle != oldValue {
                // action that rotates the node to an angle in radian.
                let action = SCNAction.rotateTo(
                    x: 0.0,
                    y: CGFloat(directionAngle),
                    z: 0.0,
                    duration: 0.1, usesShortestUnitArc: true
                )
                runAction(action)
            }
        }
    }
    
}
