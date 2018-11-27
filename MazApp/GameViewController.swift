//
//  GameViewController.swift
//  MazApp
//
//  Created by Leonardo on 11/27/18.
//  Copyright © 2018 Leonardo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SceneKit

class GameViewController: UIViewController {

    var sceneView: SCNView!;
    var scene: SCNScene!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene();
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
    }

    func setupScene(){
        sceneView = (self.view as! SCNView);
        sceneView.allowsCameraControl = true;
        scene = SCNScene(named: "mainScene.scn");
        sceneView.scene = scene;
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
