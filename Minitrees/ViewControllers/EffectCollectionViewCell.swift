//
//  EffectCollectionViewCell.swift
//  Minitrees
//
//  Created by Kyle Fleming on 10/31/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class EffectCollectionViewCell: UICollectionViewCell {
    
    dynamic var effect: Effect!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enabledIndicatorView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.rac_values(forKeyPath: "effect.name", observer: self).subscribeNext { [unowned self] (name: Any?) in
            if let name = name as? String {
                self.nameLabel.text! = name
            }
        }
        RACSignal.merge([self.rac_values(forKeyPath: "effect", observer: self), Model.sharedInstance.rac_values(forKeyPath: "activeColorEffect", observer: self)] as NSArray).subscribeNext { [unowned self] (_) in
            if self.effect != nil {
                self.enabledIndicatorView.alpha = Model.sharedInstance.activeColorEffect == self.effect ? 1 : 0
            }
        }
    }
    
}
