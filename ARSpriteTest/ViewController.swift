//
//  ViewController.swift
//  ARSpriteTest
//
//  Created by asdfgh1 on 03/08/2017.
//  Copyright © 2017 Roman Shevtsov. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import Vision

class ViewController: UIViewController, ARSKViewDelegate, ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSKView!

	let visionRequestHandler = VNSequenceRequestHandler()
	let backgroundQueue = DispatchQueue(label: "ARdelegateQueue", qos: .background)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
		configuration.planeDetection = .horizontal

		sceneView.session.delegate = self
		sceneView.session.delegateQueue = backgroundQueue

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate

	func session(_ session: ARSession, didUpdate frame: ARFrame) {
		let capturedImage = frame.capturedImage

		let rectanglesRequest = VNDetectRectanglesRequest { [weak self] (request, error) in
			guard let results = request.results, !results.isEmpty, error == nil else {
				return
			}

			print(results)
		}
//		rectanglesRequest.minimumAspectRatio = 0.1
//		rectanglesRequest.quadratureTolerance = 0
//		rectanglesRequest.maximumObservations = 10

		try? visionRequestHandler.perform([rectanglesRequest], on: capturedImage)
	}

	func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
		guard anchor is ARPlaneAnchor else {
			return nil
		}

		print("found a plane anchor")

        // Create and configure a node for the anchor added to the view's session.
//        let labelNode = SKLabelNode(text: "👾")
		let labelNode = SKLabelNode(text: "_")
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        return labelNode;
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
