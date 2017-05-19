//
//  EffectTableViewCell.swift
//  Minitrees
//
//  Created by Kyle Fleming on 11/5/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class EffectTableViewCell: UITableViewCell {
    
    dynamic var effect: Effect!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enabledIndicatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rac_values(forKeyPath: "effect.name", observer: self).subscribeNext { [unowned self] (name: Any?) in
            if let name = name as? String {
                self.nameLabel.text = name
            } else {
                self.nameLabel.text = "None"
            }
        }
        RACSignal.merge([self.rac_values(forKeyPath: "effect", observer: self), Model.sharedInstance.rac_values(forKeyPath: "activeColorEffect", observer: self)] as NSArray).subscribeNext { [unowned self] (_) in
            print(Model.sharedInstance.activeColorEffect == self.effect)
            self.enabledIndicatorView.alpha = Model.sharedInstance.activeColorEffect == self.effect ? 1 : 0
        }
    }

}
