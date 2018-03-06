//
//  Model.swift
//  Minitrees
//
//  Created by Kyle Fleming on 10/27/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    class var sharedInstance : Model {
        struct Static {
            static let instance = Model()
        }
        return Static.instance
    }
    
    var isIniting = false
    @objc var loaded = false
    
    @objc var autoplay: Bool = false {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setAutoplay(self.autoplay)
            }
        }
    }
    
    @objc var channels: [Channel] = []
    @objc var patterns: [Pattern] = []
    
    @objc var colorEffects: [Effect] = []
    var activeColorEffectIndex: Int = -1 {
        didSet {
            self.activeColorEffect = activeColorEffectIndex == -1 ? nil : colorEffects[self.activeColorEffectIndex]
            if !self.isIniting {
                ServerController.sharedInstance.setActiveColorEffect(self.activeColorEffectIndex)
            }
        }
    }
    @objc var activeColorEffect: Effect?
    
    @objc var speed: Float = 0 {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setSpeed(self.speed)
            }
        }
    }
    @objc var spin: Float = 0 {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setSpin(self.spin)
            }
        }
    }
    @objc var scrambleEffect: Float = 0 {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setScramble(self.scrambleEffect)
            }
        }
    }
    @objc var blur: Float = 0 {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setBlur(self.blur)
            }
        }
    }
   
}
