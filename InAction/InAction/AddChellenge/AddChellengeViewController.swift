//
//  addChellengeViewController.swift
//  InAction
//
//  Created by Pavel Vasylchenko on 5/16/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AddChellengeViewController: UIViewController {
    
    
//
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var libraryView: LibraryView!
    @IBOutlet weak var photoView: PhotoView!
    
    //    ToolbarItems
    
    @IBOutlet weak var librarySectionButton: UIButton!
    @IBOutlet weak var photoSectionButton: UIButton!
    @IBOutlet weak var videoSectionButton: UIButton!
    
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryView.vc = self
        self.setupLibraryView()
        self.awakeCamera()
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        captureSession?.addOutput(capturePhotoOutput!)
//        DispatchQueue.global(qos: .background).async {
//            var photoLibraryTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: Selector("setupLibraryView"), userInfo: nil, repeats: true)
//        }
        
    }
    
    func setupLibraryView() {
        let photoGetter = PhotoDataConfig()
        photoGetter.collectionViewWidth = self.view.bounds.width
        libraryView.collection = photoGetter.getData()
        if libraryView.collection.count > 0 {
            libraryView.firstLoad()
        }
    }
    
    func awakeCamera() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            photoView.cameraView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
        } catch {
            print(error)
            return
        }
    }
    
    @IBAction func LibraryButtonTapped(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        librarySectionButton.titleLabel?.textColor = Colors.black
        photoSectionButton.titleLabel?.textColor = Colors.grey
        videoSectionButton.titleLabel?.textColor = Colors.grey
        
    }
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: view.bounds.width, y: 0), animated: true)
        photoScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        photoSectionButton.titleLabel?.textColor = Colors.black
        librarySectionButton.titleLabel?.textColor = Colors.grey
        videoSectionButton.titleLabel?.textColor = Colors.grey
    }
    
    @IBAction func videoButtonTapped(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: view.bounds.width, y: 0), animated: true)
        photoScrollView.setContentOffset(CGPoint(x: view.bounds.width, y: 0), animated: true)
        librarySectionButton.titleLabel?.textColor = Colors.grey
        photoSectionButton.titleLabel?.textColor = Colors.grey
        videoSectionButton.titleLabel?.textColor = Colors.black
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func capturePhotoButtonTapped(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
}

extension AddChellengeViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        // Initialise a UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save our captured image to photos album
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
