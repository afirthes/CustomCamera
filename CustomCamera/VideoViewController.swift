//
//  ViewViewController.swift
//  CustomCamera
//
//  Created by Afir Thes on 10.09.2021.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
        
    var videoURL: URL!
    
    var avPlayer = AVPlayer()
    
    var avPlayerLayer: AVPlayerLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = view.bounds
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.insertSublayer(avPlayerLayer, at: 0)
        view.layoutIfNeeded()
        
        let playerItem = AVPlayerItem(url: videoURL)
        
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
    }

    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
