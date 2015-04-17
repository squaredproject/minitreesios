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
    
    dynamic var isIniting = false
    dynamic var loaded = false
    
    dynamic var autoplay: Bool = false {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setAutoplay(self.autoplay)
            }
        }
    }
    
    dynamic var channels: [Channel] = []
    dynamic var patterns: [Pattern] = []
    
    dynamic var colorEffects: [Effect] = []
    dynamic var activeColorEffectIndex: Int = -1 {
        didSet {
            self.activeColorEffect = activeColorEffectIndex == -1 ? nil : colorEffects[self.activeColorEffectIndex]
            if !self.isIniting {
                ServerController.sharedInstance.setActiveColorEffect(self.activeColorEffectIndex)
            }
        }
    }
    dynamic var activeColorEffect: Effect?
    
    dynamic var speed: Float = 0 {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setSpeed(self.speed)
            }
        }
    }
    dynamic var spin: Float = 0 {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setSpin(self.spin)
            }
        }
    }
    dynamic var scrambleEffect: Float = 0 {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setScramble(self.scrambleEffect)
            }
        }
    }
    dynamic var blur: Float = 0 {
        didSet {
            if !self.isIniting {
                ServerController.sharedInstance.setBlur(self.blur)
            }
        }
    }
   
}
