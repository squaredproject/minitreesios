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
        
        self.rac_valuesForKeyPath("effect.name", observer: self).subscribeNext { [unowned self] (name: AnyObject?) in
            if let name = name as? String {
                self.nameLabel.text = name
            } else {
                self.nameLabel.text = "None"
            }
        }
        RACSignal.merge([self.rac_valuesForKeyPath("effect", observer: self), Model.sharedInstance.rac_valuesForKeyPath("activeColorEffect", observer: self)]).subscribeNext { [unowned self] (_) in
            println(Model.sharedInstance.activeColorEffect == self.effect)
            self.enabledIndicatorView.alpha = Model.sharedInstance.activeColorEffect == self.effect ? 1 : 0
        }
    }

}
