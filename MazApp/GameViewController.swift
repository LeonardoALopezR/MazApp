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

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate{
    
    let CategoryExit = 4;
    var contador = 0;
    
    static var offset: Float = 3;
    
    var gameView: GameView {
        return view as! GameView;
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
                characterNode.runAction(action);
            }
        }
    }
    
    var sceneView: SCNView!;
    var scene: SCNScene!;
    
    var characterNode: SCNNode!;
    var exitNode: SCNNode!;
//    var wallsNode: SCNNode!;
    var cameraNode: SCNNode!;
    
//    let playerNode = CharacterNode();
    var touch: UITouch?;
    var direction = float2(0, 0);
    var speed: Float = 0.1;
    
    var sounds:[String:SCNAudioSource] = [:];
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        gameView = view as! SCNView;
        setupScene();
        setupNodes();
        setupSounds();
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
    }

    func setupScene(){
        sceneView = (self.view as! SCNView);
        
//        sceneView.delegate = self;
        
//        sceneView.allowsCameraControl = true;
        scene = SCNScene(named: "mainScene.scn");
        sceneView.scene = scene;
        scene.physicsWorld.contactDelegate = self;
        
        let tapRecognizer = UITapGestureRecognizer();
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        tapRecognizer.addTarget(self, action: #selector(sceneViewTapped(recognizer:)));
        sceneView.addGestureRecognizer(tapRecognizer);
        gameView.scene = scene;
        gameView.delegate = self;
        gameView.isPlaying = true;
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        let character = characterNode.presentation;
//        let characterPosition = character.position;
//        let targetPosition = SCNVector3(characterPosition.x, characterPosition.y + 1, characterPosition.z + 2);
//        var cameraPosition = cameraNode.position;
//        let camDamping: Float = 0.3;
//        let xComponent = cameraPosition.x * (1-camDamping) + targetPosition.x * camDamping;
//        let yComponent = cameraPosition.y * (1-camDamping) + targetPosition.y * camDamping;
//        let zComponent = cameraPosition.z * (1-camDamping) + targetPosition.z * camDamping;
//
//        cameraPosition = SCNVector3(xComponent, yComponent, zComponent);
//        cameraNode.position = cameraPosition;
        let directionInV3 = float3(x: direction.x, y: 0, z: direction.y)
//        walkInDirection(directionInV3)
        let currentPosition = float3(characterNode.position);
        characterNode.position = SCNVector3(currentPosition + directionInV3 * speed);
        cameraNode.position.y = characterNode.presentation.position.y + 1 /*+ GameViewController.offset*/;
        cameraNode.position.x = characterNode.presentation.position.x /*- GameViewController.offset;*/
        cameraNode.position.z = characterNode.presentation.position.z + 3 /*+ GameViewController.offset*/;
    }
    
    func setupNodes(){
        characterNode = scene.rootNode.childNode(withName: "Character", recursively: true)!;
//        characterNode = CharacterNode.init();
        characterNode.physicsBody?.contactTestBitMask = CategoryExit;
        cameraNode = scene.rootNode.childNode(withName: "firstPerson", recursively: true)!;
        exitNode = scene.rootNode.childNode(withName: "exit", recursively: true)!;
//        wallsNode = scene.rootNode.childNode(withName: "wall", recursively: true)!;
//        let wallShape: SCNPhysicsShape = SCNPhysicsShape(geometry: wallsNode.geometry!, options: nil);
//        wallsNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: wallShape);
//        wallsNode.physicsBody?.restitution = 1;
//        wallsNode.physicsBody?.isAffectedByGravity = false;
        
    }
    
    func setupSounds(){
        
        let stepSound = SCNAudioSource(fileNamed: "footsteps.wav")!;
        stepSound.load();
        stepSound.volume = 0.3;
        sounds["steps"] = stepSound;
        
        let magicSound = SCNAudioSource(fileNamed: "magic.wav")!;
        magicSound.load();
        magicSound.volume = 0.3;
        sounds["magic"] = magicSound;
        
        let menuSound = SCNAudioSource(fileNamed: "menu.mp3")!;
        menuSound.volume = 0.1;
        menuSound.loops = true;
        menuSound.load();
        let musicPlayer = SCNAudioPlayer(source: menuSound);
        characterNode.addAudioPlayer(musicPlayer);
        sounds["menu"] = menuSound;
    }
    
    @objc func sceneViewTapped(recognizer: UITapGestureRecognizer){
        let location = recognizer.location(in: sceneView);
        let hitResults = sceneView.hitTest(location, options: nil);
        
        if (hitResults.count > 0){
            let result = hitResults.first;
            if let node = result?.node{
                if node.name == "Character"{
                    let stepSound = sounds["steps"]!;
                    characterNode.runAction(SCNAction.playAudio(stepSound, waitForCompletion: false));
                    characterNode.physicsBody?.applyForce(SCNVector3(x: 0, y: 4, z: -2), asImpulse: true);
                }
            }
        }
    }
    
//    func walkInDirection(_ direction: float3) {
//        let currentPosition = float3(characterNode.position);
//        characterNode.position = SCNVector3(currentPosition + direction * speed);
//    }
//
    override var shouldAutorotate: Bool {
        return false
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

extension GameViewController {
    // store touch in global scope
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first;
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touch {
            
            let touchLocation = touch.location(in: self.view)
            if gameView.virtualDPad().contains(touchLocation) {
                speed = 0.1;
                let middleOfCircleX = gameView.virtualDPad().origin.x + 75
                let middleOfCircleY = gameView.virtualDPad().origin.y + 75
                let lengthOfX = Float(touchLocation.x - middleOfCircleX)
                let lengthOfY = Float(touchLocation.y - middleOfCircleY)
                direction = float2(x: lengthOfX, y: lengthOfY)
                direction = normalize(direction)
                let degree = atan2(direction.x, direction.y)
                directionAngle = degree;
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        speed = 0;
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        var contactNode: SCNNode!;
        
        if (contact.nodeA.name == "Character"){
            contactNode = contact.nodeB;
        }else{
            contactNode = contact.nodeA;
        }
        
        if (contactNode.physicsBody?.categoryBitMask == CategoryExit){
            let magicSound = sounds["magic"]!;
            characterNode.runAction(SCNAction.playAudio(magicSound, waitForCompletion: false));
            exitNode.isHidden = true;
        }
    }
    
}
