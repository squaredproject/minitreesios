//
//  PatternCollectionViewCell.swift
//  Minitrees
//
//  Created by Kyle Fleming on 10/28/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class PatternCollectionViewCell: UICollectionViewCell {
    
    dynamic var pattern: Pattern!
    dynamic var currentlySelected = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deseletedImageView: UIImageView!
    @IBOutlet weak var selectedBlueImageView: UIImageView!
    @IBOutlet weak var selectedGreenImageView: UIImageView!
    @IBOutlet weak var selectedOrangeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rac_valuesForKeyPath("pattern.name", observer: self).subscribeNext { [unowned self] (name: AnyObject?) in
            if let name = name as? String {
                self.nameLabel.text! = name
            }
        }
        
        self.rac_valuesForKeyPath("pattern.channelSelectedOn.index", observer: self).subscribeNext { [unowned self] (_) in
            if self.pattern != nil {
                self.deseletedImageView.hidden = true
                self.selectedBlueImageView.hidden = true
                self.selectedGreenImageView.hidden = true
                self.selectedOrangeImageView.hidden = true
                
                if let channel = self.pattern.channelSelectedOn {
                    switch channel.index {
                    case 0:
                        self.selectedBlueImageView.hidden = false
                    case 1:
                        self.selectedOrangeImageView.hidden = false
                    case 2:
                        self.selectedGreenImageView.hidden = false
                    default:
                        break;
                    }
                } else {
                    self.deseletedImageView.hidden = false
                }
            }
        }
    }
    
}
