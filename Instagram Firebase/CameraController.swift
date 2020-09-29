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
    
    private let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "right_arrow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private var captureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = Palette.black.color
        
        view.addSubview(captureButton)
        view.addSubview(dismissButton)
    }
    
    private func setupConstraints() {
        captureButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 50)
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        // Inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Could not setup camera input: \(error)")
        }
        
        // Output
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        // Preview Layer
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.session = captureSession
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        self.captureSession = captureSession
        self.captureSession?.startRunning()
    }
    
    @objc private func handleCapturePhoto() {
        print("Capture Photo")
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true) {
            self.captureSession?.stopRunning()
        }
    }
    
}
