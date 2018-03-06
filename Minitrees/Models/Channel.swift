//
//  Channel.swift
//  Minitrees
//
//  Created by Kyle Fleming on 11/4/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class Channel: NSObject {
    
    init(index: Int, patterns: [Pattern], currentPattern: Pattern?, visibility: Float) {
        self.index = index
        self.patterns = patterns
        self.currentPattern = currentPattern
        self.visibility = visibility
        super.init()
        for pattern in patterns {
            pattern.channel = self
        }
        self.updateCurrentPattern()
    }
    
    @objc let index: Int
    var patterns: [Pattern]
    
    @objc var currentPattern: Pattern? {
        willSet {
            self.currentPattern?.channelSelectedOn = nil
        }
        didSet {
            ServerController.sharedInstance.setChannelPattern(self)
            self.updateCurrentPattern()
        }
    }
    func updateCurrentPattern() {
        self.currentPattern?.channelSelectedOn = self
    }
    
    @objc var visibility: Float {
        didSet {
            ServerController.sharedInstance.setChannelVisibility(self)
        }
    }
   
}
