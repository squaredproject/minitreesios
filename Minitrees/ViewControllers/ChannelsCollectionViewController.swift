//
//  ChannelsCollectionViewController.swift
//  Minitrees
//
//  Created by Kyle Fleming on 11/4/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class ChannelsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.sharedInstance.rac_valuesForKeyPath("channels", observer: self).subscribeNext { [unowned self] (_) in
            self.collectionView!.reloadData()
            if self.collectionView!.indexPathsForSelectedItems().first == nil {
                self.setSelectedItem()
            }
        }
    }
    
    func setSelectedItem() {
        let selectedItemIndex = DisplayState.sharedInstance.selectedChannelIndex
        
        if selectedItemIndex >= 0 && selectedItemIndex < self.collectionView!.numberOfItemsInSection(0) {
            self.collectionView!.selectItemAtIndexPath(NSIndexPath(forItem: selectedItemIndex, inSection: 0), animated: false, scrollPosition: .None)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return Model.sharedInstance.channels.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ChannelCollectionViewCell
    
        // Configure the cell
        cell.channel = Model.sharedInstance.channels[indexPath.item]
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        DisplayState.sharedInstance.selectedChannelIndex = indexPath.item
    }

}
