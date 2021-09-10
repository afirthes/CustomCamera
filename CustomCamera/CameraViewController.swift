//
//  CameraViewController.swift
//  CustomCamera
//
//  Created by Afir Thes on 10.09.2021.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    

    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    let captureSession = AVCaptureSession()
    
    var activeInput: AVCaptureDeviceInput!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let movieOutput = AVCaptureMovieFileOutput()
    
    var isSessionSetup = false
    
    var recordedVideoURL: URL?
    
    var outputURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureButton.backgroundColor = UIColor.red
    }
    
    override func viewDidLayoutSubviews() {
        captureButton.layer.cornerRadius = captureButton.layer.frame.width / 2
    }
    
    func startSession() {
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.main.async {
            self.captureSession.stopRunning()
        }
    }
    
    func setupSession() -> Bool {
        guard let camera = AVCaptureDevice.default(for: AVMediaType.video) else { return false }
        guard let microphone = AVCaptureDevice.default(for: .audio) else { return false }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
                
            } else {
                print("Was not able to add input")
                captureSession.commitConfiguration()
                return false
            }
        } catch {
            print("Could not get camera device input")
            captureSession.commitConfiguration()
            return false
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: microphone)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
                
            } else {
                print("Was not able to add mic input")
                captureSession.commitConfiguration()
                return false
            }
        } catch {
            print("Could not get camera device mic input")
            captureSession.commitConfiguration()
            return false
        }
        
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        } else {
            print("Could not setup video output")
            captureSession.commitConfiguration()
            return false
        }
        
        captureSession.commitConfiguration()
        
        isSessionSetup = true
        
        return true
    }
    
    func setupPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isSessionSetup {
            if setupSession() {
                setupPreview()
                startSession()
            }
        } else {
            if !captureSession.isRunning {
                startSession()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            stopSession()
        }
    }
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        } else {
            return nil
        }
    }
    
    func startRecording() {
        if !movieOutput.isRecording {
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            captureButton.backgroundColor = UIColor.blue
        } else {
            stopRecording()
        }
    }
    
    func stopRecording() {
        if movieOutput.isRecording {
            movieOutput.stopRecording()
            captureButton.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func viewVideoAction(_ sender: Any) {
        guard recordedVideoURL != nil else { return }
        
        performSegue(withIdentifier: "ShowVideoSegue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowVideoSegue" {
            let destinationVC = segue.destination as! VideoViewController
            destinationVC.videoURL = recordedVideoURL
        }
    }
    
    @IBAction func recordAction(_ sender: Any) {
        startRecording()
    }
    
}


extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let error = error {
            print("Error recording video \(error.localizedDescription)")
            return
        }
        
        let videoRecorded = outputURL as URL
        
        if let thumbnail = videoRecorded.makeThumbnail() {
            
            thumbnailButton.setBackgroundImage(thumbnail, for: .normal)
            
        }
        
        self.recordedVideoURL = videoRecorded
    }
}
