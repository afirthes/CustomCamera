//
//  CameraViewController.swift
//  CustomCamera
//
//  Created by Afir Thes on 10.09.2021.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var thumbnail: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     
     ShowVideoSegue
    }
    */
    
    @IBAction func viewVideoAction(_ sender: Any) {
    }
    @IBAction func recordAction(_ sender: Any) {
    }
    
}
