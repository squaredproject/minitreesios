//
//  ChannelCollectionViewCell.swift
//  Minitrees
//
//  Created by Kyle Fleming on 11/4/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {
    
    dynamic var channel: Channel!
    dynamic var currentlySelected = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var tapAPatternLabel: UILabel!
    @IBOutlet weak var visibilitySlider: UISlider!
    
    @IBOutlet weak var selectedBlueImageView: UIImageView!
    @IBOutlet weak var selectedOrangeImageView: UIImageView!
    @IBOutlet weak var selectedGreenImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.visibilitySlider.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2));
        
        RACSignal.merge([self.rac_valuesForKeyPath("channel", observer: self), DisplayState.sharedInstance.rac_valuesForKeyPath("selectedChannel", observer: self)]).subscribeNext { [unowned self] (_) in
            self.currentlySelected = self.channel != nil && DisplayState.sharedInstance.selectedChannel != nil && self.channel == DisplayState.sharedInstance.selectedChannel
        }
        
        self.rac_valuesForKeyPath("channel.index", observer: self).subscribeNext { [unowned self] (_) in
            if self.channel != nil {
                self.channelLabel.text = "Channel \(self.channel.index + 1)"
            }
        }
        
        RACSignal.merge([self.rac_valuesForKeyPath("channel.index", observer: self), self.rac_valuesForKeyPath("channel.currentPattern", observer: self)]).subscribeNext { [unowned self] (_) in
            if self.channel != nil {
                if self.channel.currentPattern == nil {
                    self.visibilitySlider.setThumbImage(UIImage(named: "channelSliderThumbGray"),
                        forState: .Normal);
                    self.visibilitySlider.setThumbImage(UIImage(named: "channelSliderThumbGray"),
                        forState: .Highlighted);
                    self.visibilitySlider.setMinimumTrackImage(UIImage(named: "channelSliderBarGray"),
                        forState: .Normal);
                    self.visibilitySlider.setMaximumTrackImage(UIImage(named: "channelSliderBarGray"),
                        forState: .Normal);
                } else {
                    switch self.channel.index {
                    case 0:
                        self.visibilitySlider.setThumbImage(UIImage(named: "channelSliderThumbBlue"),
                            forState: .Normal);
                        self.visibilitySlider.setThumbImage(UIImage(named: "channelSliderThumbBlue"),
                            forState: .Highlighted);
                        self.visibilitySlider.setMinimumTrackImage(UIImage(named: "channelSliderBarBlue"),
                            forState: .Normal);
                        self.visibilitySlider.setMaximumTrackImage(UIImage(named: "channelSliderBarDefault"),
                            forState: .Normal);
                    case 1:
                        self.visibilitySlider.setThumbImage(UIImage(named: "channelSliderThumbOrange"),
                            forState: .Normal);
                        self.visibilitySlider.setThumbImage(UIImage(named: "channelSliderThumbOrange"),
                            forState: .Highlighted);
                        self.visibilitySlider.setMinimumTrackImage(UIImage(named: "channelSliderBarOrange"),
                            forState: .Normal);
                        self.visibilitySlider.setMaximumTrackImage(UIImage(named: "channelSliderBarDefault"),
                            forState: .Normal);
                    case 2:
                        self.visibilitySlider.setThumbImage(UIImage(named: "channelSliderThumbGreen"),
                            forState: .Normal);
                        self.visibilitySlider.setThumbImage(UIImage(named: "channelSliderThumbGreen"),
                            forState: .Highlighted);
                        self.visibilitySlider.setMinimumTrackImage(UIImage(named: "channelSliderBarGreen"),
                            forState: .Normal);
                        self.visibilitySlider.setMaximumTrackImage(UIImage(named: "channelSliderBarDefault"),
                            forState: .Normal);
                    default:
                        break;
                    }
                }
            }
        }
        
        self.rac_valuesForKeyPath("channel.currentPattern.name", observer: self).subscribeNext { [unowned self] (_) in
            if self.channel != nil {
                self.nameLabel.text = self.channel.currentPattern?.name
            }
        }
        
        self.rac_valuesForKeyPath("currentlySelected", observer: self).subscribeNext { [unowned self] (_) in
            if self.channel != nil {
                self.selectedBlueImageView.hidden = true
                self.selectedOrangeImageView.hidden = true
                self.selectedGreenImageView.hidden = true
                if self.currentlySelected {
                    switch self.channel.index {
                    case 0:
                        self.selectedBlueImageView.hidden = false
                    case 1:
                        self.selectedOrangeImageView.hidden = false
                    case 2:
                        self.selectedGreenImageView.hidden = false
                    default:
                        break;
                    }
                }
            }
        }
        
        self.rac_valuesForKeyPath("channel.visibility", observer: self).subscribeNext { [unowned self] (_) in
            if self.channel != nil {
                self.visibilitySlider.value = self.channel.visibility
            }
        }
        
        RACSignal.merge([self.rac_valuesForKeyPath("channel.currentPattern.name", observer: self), self.rac_valuesForKeyPath("currentlySelected", observer: self), self.rac_valuesForKeyPath("channel.currentPattern", observer: self)]).subscribeNext { [unowned self] (_) in
            if self.channel != nil {
                self.nameLabel.hidden = true
                self.channelLabel.hidden = true
                self.tapAPatternLabel.hidden = true
                self.visibilitySlider.userInteractionEnabled = false
                if self.channel.currentPattern != nil {
                    self.nameLabel.hidden = false
                    self.visibilitySlider.userInteractionEnabled = true
                } else if self.currentlySelected {
                    self.tapAPatternLabel.hidden = false
                } else {
                    self.channelLabel.hidden = false
                }
            }
        }
    }
    
    @IBAction func channelVisibilityChanged(sender: AnyObject) {
        channel.visibility = self.visibilitySlider.value
        if !self.currentlySelected {
            DisplayState.sharedInstance.selectedChannelIndex = channel.index
        }
    }
    
}
