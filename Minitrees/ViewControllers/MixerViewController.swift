//
//  MixerViewController.swift
//  Minitrees
//
//  Created by Kyle Fleming on 11/1/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class MixerViewController: UIViewController ,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var autoPilotInterActBt: UIButton!
    @IBOutlet weak var controllerView: UIView!
    @IBOutlet weak var connectingView: UIView!
    @IBOutlet weak var connectingLabel: UIView!
    @IBOutlet weak var connectedView: UIView!
    @IBOutlet weak var autoplayView: UIView!
    
    @IBOutlet weak var autoplaySwitch: UISwitch!
    @IBOutlet weak var brightnessSlider: UISlider!
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var spinSlider: UISlider!
    @IBOutlet weak var blurSlider: UISlider!
    @IBOutlet weak var brightnessEffectSlider: UISlider!
    
    @IBOutlet var sliders: [UISlider]!
    
    var imagesArr = [UIImage(named: "image1"),UIImage(named: "image2"),UIImage(named: "image4"),UIImage(named: "image4")]
    
    var timer:Timer? = nil
    
    //var secondsCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        reloadCollectionView()
        ServerController.sharedInstance.connect()
        
        Model.sharedInstance.reactive.producer(forKeyPath: #keyPath(Model.loaded)).startWithValues { [unowned self] (_) in
            //self.connectingView.isHidden = Model.sharedInstance.loaded
            //self.connectedView.isHidden = !Model.sharedInstance.loaded
            self.connectingLabel.isHidden = Model.sharedInstance.loaded
            self.connectingLabel.isHidden = !Model.sharedInstance.loaded
        }
        
        Model.sharedInstance.reactive.producer(forKeyPath: #keyPath(Model.autoplay)).startWithValues { [unowned self] (_) in
            self.autoplaySwitch.isOn = Model.sharedInstance.autoplay
            
            self.controllerView.isHidden = Model.sharedInstance.autoplay
            self.autoplayView.isHidden = !Model.sharedInstance.autoplay
            //if !self.autoplaySwitch.isOn{
                //self.runTimer()
            //}
        }
        
        Model.sharedInstance.reactive.producer(forKeyPath: #keyPath(Model.brightness)).startWithValues { [unowned self] (_) in
            self.brightnessSlider.value = Model.sharedInstance.brightness
            self.brightnessEffectSlider.value = Model.sharedInstance.brightness
        }
        
        Model.sharedInstance.reactive.producer(forKeyPath: #keyPath(Model.speed)).startWithValues { [unowned self] (_) in
            self.speedSlider.value = Model.sharedInstance.speed
        }
        
        Model.sharedInstance.reactive.producer(forKeyPath: #keyPath(Model.spin)).startWithValues { [unowned self] (_) in
            self.spinSlider.value = Model.sharedInstance.spin
        }
        
        Model.sharedInstance.reactive.producer(forKeyPath: #keyPath(Model.blur)).startWithValues { [unowned self] (_) in
            self.blurSlider.value = Model.sharedInstance.blur
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.userActivityTimeout(notification:)),
            name: .appTimeout,
            object: nil)
    }
    
    @objc func userActivityTimeout(notification: NSNotification){
        print("User In active")
        if !self.controllerView.isHidden && !self.autoplaySwitch.isOn {
            Model.sharedInstance.autoplay = !self.autoplaySwitch.isHidden
        }
    }
    
    @IBAction func autoplayChanged(_ sender: AnyObject) {
        Model.sharedInstance.autoplay = self.autoplaySwitch.isOn
        //if self.autoplaySwitch.isOn{
        //runTimer()
        //}
    }
    
    @IBAction func brightnessChanged(_ sender: UISlider) {
        Model.sharedInstance.brightness = sender.value
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
    
    
    @IBAction func autoPilotInterActBt(_ sender: Any) {
        Model.sharedInstance.autoplay = self.autoplaySwitch.isHidden
        
    }
    /*func runTimer() {
        secondsCounter = AUTO_PILOT_TIME_OUT
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(MixerViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        print("Timer changed \(secondsCounter)")
        secondsCounter -= 1
        
        if(secondsCounter == 1)
        {
            print("Auto play \(self.autoplaySwitch.isHidden)")
            Model.sharedInstance.autoplay = !self.autoplaySwitch.isHidden
            timer.invalidate()
            timer = nil
            secondsCounter = AUTO_PILOT_TIME_OUT
        }
    }*/
    func reloadCollectionView() {
        
        self.collectionView.reloadData()
        
        // Invalidating timer for safety reasons
        self.timer?.invalidate()
        
        // Below, for each 3.5 seconds MyViewController's 'autoScrollImageSlider' would be fired
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(MixerViewController.autoScrollImageSlider), userInfo: nil, repeats: true)
        
        //This will register the timer to the main run loop
        RunLoop.main.add(self.timer!, forMode: .commonModes)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width:collectionView.frame.width, height: collectionView.frame.height)
    }
}
extension MixerViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    
    
    @objc func autoScrollImageSlider() {
        
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.async {
                
                let firstIndex = 0
                let lastIndex = (self.imagesArr.count) - 1
                
                let visibleIndices = self.collectionView.indexPathsForVisibleItems
                let nextIndex = visibleIndices[0].row + 1
                
                let nextIndexPath: IndexPath = IndexPath.init(item: nextIndex, section: 0)
                let firstIndexPath: IndexPath = IndexPath.init(item: firstIndex, section: 0)
                
                if nextIndex > lastIndex {
                    
                    self.collectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
                    
                } else {
                    
                    self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                    
                }
                
            }
            
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.autoPilotImageView.image = imagesArr[indexPath.row]
        return cell
    }
    override func viewWillDisappear(_ animated: Bool) {
    self.timer?.invalidate()
    }
}
extension MixerViewController : UICollectionViewDelegate
{
    
}

