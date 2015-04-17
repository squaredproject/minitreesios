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
        
        Model.sharedInstance.rac_valuesForKeyPath("loaded", observer: self).subscribeNext { [unowned self] (_) in
            self.connectingView.hidden = Model.sharedInstance.loaded
            self.connectedView.hidden = !Model.sharedInstance.loaded
        }
        
        Model.sharedInstance.rac_valuesForKeyPath("autoplay", observer: self).subscribeNext { [unowned self] (_) in
            self.autoplaySwitch.on = Model.sharedInstance.autoplay
            
            self.controllerView.hidden = Model.sharedInstance.autoplay
            self.autoplayView.hidden = !Model.sharedInstance.autoplay
        }
        
        Model.sharedInstance.rac_valuesForKeyPath("speed", observer: self).subscribeNext { [unowned self] (_) in
            self.speedSlider.value = Model.sharedInstance.speed
        }
        
        Model.sharedInstance.rac_valuesForKeyPath("spin", observer: self).subscribeNext { [unowned self] (_) in
            self.spinSlider.value = Model.sharedInstance.spin
        }
        
        Model.sharedInstance.rac_valuesForKeyPath("blur", observer: self).subscribeNext { [unowned self] (_) in
            self.blurSlider.value = Model.sharedInstance.blur
        }
        
        Model.sharedInstance.rac_valuesForKeyPath("scrambleEffect", observer: self).subscribeNext { [unowned self] (_) in
            self.scrambleSlider.value = Model.sharedInstance.scrambleEffect
        }
        
        for slider in self.sliders {
            slider.setThumbImage(UIImage(named: "channelSliderThumbNormal"),
                forState: .Normal);
            slider.setThumbImage(UIImage(named: "channelSliderThumbNormal"),
                forState: .Highlighted);
            slider.setMinimumTrackImage(UIImage(named: "channelSliderBarNormalMin"),
                forState: .Normal);
            slider.setMaximumTrackImage(UIImage(named: "channelSliderBarNormalMax"),
                forState: .Normal);
        }
    }
    
    @IBAction func autoplayChanged(sender: AnyObject) {
        Model.sharedInstance.autoplay = self.autoplaySwitch.on
    }
    
    @IBAction func speedChanged(sender: AnyObject) {
        Model.sharedInstance.speed = self.speedSlider.value
    }
    
    @IBAction func spinChanged(sender: AnyObject) {
        Model.sharedInstance.spin = self.spinSlider.value
    }
    
    @IBAction func blurChanged(sender: AnyObject) {
        Model.sharedInstance.blur = self.blurSlider.value
    }
    
    @IBAction func scrambleChanged(sender: AnyObject) {
        Model.sharedInstance.scrambleEffect = self.scrambleSlider.value
    }

}
