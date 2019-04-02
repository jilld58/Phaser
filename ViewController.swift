//
//  ViewController.swift
//  finalphaser
//
//  Created by Jillian Donahue on 4/22/18.
//  Copyright © 2018 Jillian Donahue. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PdListener {

    //MARK: Properties
    
    @IBOutlet weak var speed_label: UILabel!
    @IBOutlet weak var depth_label: UILabel!
    @IBOutlet weak var feedback_label: UILabel!
    
    
    let pd = PdAudioController()
    let dispatcher = PdDispatcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        let pdInit = pd.configurePlayback(withSampleRate: 44100,
                                          numberChannels: 2, inputEnabled: true, mixingEnabled:
            false)
        guard pdInit == PdAudioOK else { // 0 for success
            fatalError("Error, could not instantiate pd audio engine")
        }
        dispatcher.add(self, forSource: "output")
        PdBase.setDelegate(dispatcher)
        
        let pdPatch = "Phaser.pd"
        guard PdBase.openFile(pdPatch, path:
            Bundle.main.resourcePath) != nil else{
                fatalError("Failed to open the patch \(pdPatch)")
        }
        pd.isActive = true // The pd engine status is active!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions

    @IBAction func speed(_ sender: UISlider) {
        PdBase.send(sender.value, toReceiver: "speed")
        speed_label.text = String(format: "Speed %.2f", sender.value)
    }
    @IBAction func depth(_ sender: UISlider) {
        PdBase.send(sender.value, toReceiver: "depth")
        depth_label.text = String(format: "Depth %.2f", sender.value)
    }
    @IBAction func feedback(_ sender: UISlider) {
        PdBase.send(sender.value, toReceiver: "feedback")
        feedback_label.text = String(format: "Feedback %.2f", sender.value)
    }
    
}

