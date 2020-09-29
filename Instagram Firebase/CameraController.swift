//
//  CameraController.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/29/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Palette.white.color
        
        setupCaptureSession()
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        // 1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Could not setup camera input: \(error)")
        }
        
        // 2. Setup outputs
        
        // 3. setup output preview
        
    }
    
}
