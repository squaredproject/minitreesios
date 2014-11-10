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
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var spinSlider: UISlider!
    @IBOutlet weak var blurSlider: UISlider!
    @IBOutlet weak var staticSlider: UISlider!
    
    @IBOutlet var sliders: [UISlider]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServerController.sharedInstance.connect()
        
        Model.sharedInstance.rac_valuesForKeyPath("loaded", observer: self).subscribeNext { [unowned self] (connected: AnyObject!) in
            self.controllerView.hidden = !Model.sharedInstance.loaded
            self.connectingView.hidden = Model.sharedInstance.loaded
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
        
        Model.sharedInstance.rac_valuesForKeyPath("staticEffect", observer: self).subscribeNext { [unowned self] (_) in
            self.staticSlider.value = Model.sharedInstance.staticEffect
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func speedChanged(sender: AnyObject) {
        Model.sharedInstance.speed = self.speedSlider.value
    }
    
    @IBAction func spinChanged(sender: AnyObject) {
        Model.sharedInstance.spin = self.spinSlider.value
    }
    
    @IBAction func blurChanged(sender: AnyObject) {
        Model.sharedInstance.blur = self.blurSlider.value
    }
    
    @IBAction func staticChanged(sender: AnyObject) {
        Model.sharedInstance.staticEffect = self.staticSlider.value
    }

}
