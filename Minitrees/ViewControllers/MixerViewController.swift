//
//  MixerViewController.swift
//  Minitrees
//
//  Created by Kyle Fleming on 11/1/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class MixerViewController: UIViewController {

    @IBOutlet weak var controllerView: UIView!
    @IBOutlet weak var connectingView: UIView!
    @IBOutlet weak var connectedView: UIView!
    @IBOutlet weak var autoplayView: UIView!
    
    @IBOutlet weak var autoplaySwitch: UISwitch!
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var spinSlider: UISlider!
    @IBOutlet weak var blurSlider: UISlider!
    @IBOutlet weak var scrambleSlider: UISlider!
    
    @IBOutlet var sliders: [UISlider]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServerController.sharedInstance.connect()
        
        Model.sharedInstance.rac_values(forKeyPath: "loaded", observer: self).subscribeNext { [unowned self] (_) in
            self.connectingView.isHidden = Model.sharedInstance.loaded
            self.connectedView.isHidden = !Model.sharedInstance.loaded
        }
        
        Model.sharedInstance.rac_values(forKeyPath: "autoplay", observer: self).subscribeNext { [unowned self] (_) in
            self.autoplaySwitch.isOn = Model.sharedInstance.autoplay
            
            self.controllerView.isHidden = Model.sharedInstance.autoplay
            self.autoplayView.isHidden = !Model.sharedInstance.autoplay
        }
        
        Model.sharedInstance.rac_values(forKeyPath: "speed", observer: self).subscribeNext { [unowned self] (_) in
            self.speedSlider.value = Model.sharedInstance.speed
        }
        
        Model.sharedInstance.rac_values(forKeyPath: "spin", observer: self).subscribeNext { [unowned self] (_) in
            self.spinSlider.value = Model.sharedInstance.spin
        }
        
        Model.sharedInstance.rac_values(forKeyPath: "blur", observer: self).subscribeNext { [unowned self] (_) in
            self.blurSlider.value = Model.sharedInstance.blur
        }
        
        Model.sharedInstance.rac_values(forKeyPath: "scrambleEffect", observer: self).subscribeNext { [unowned self] (_) in
            self.scrambleSlider.value = Model.sharedInstance.scrambleEffect
        }
        
        for slider in self.sliders {
            slider.setThumbImage(UIImage(named: "channelSliderThumbNormal"),
                for: UIControlState());
            slider.setThumbImage(UIImage(named: "channelSliderThumbNormal"),
                for: .highlighted);
            slider.setMinimumTrackImage(UIImage(named: "channelSliderBarNormalMin"),
                for: UIControlState());
            slider.setMaximumTrackImage(UIImage(named: "channelSliderBarNormalMax"),
                for: UIControlState());
        }
    }
    
    @IBAction func autoplayChanged(_ sender: AnyObject) {
        Model.sharedInstance.autoplay = self.autoplaySwitch.isOn
    }
    
    @IBAction func speedChanged(_ sender: AnyObject) {
        Model.sharedInstance.speed = self.speedSlider.value
    }
    
    @IBAction func spinChanged(_ sender: AnyObject) {
        Model.sharedInstance.spin = self.spinSlider.value
    }
    
    @IBAction func blurChanged(_ sender: AnyObject) {
        Model.sharedInstance.blur = self.blurSlider.value
    }
    
    @IBAction func scrambleChanged(_ sender: AnyObject) {
        Model.sharedInstance.scrambleEffect = self.scrambleSlider.value
    }

}
