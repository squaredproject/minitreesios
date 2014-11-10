//
//  EffectsTableViewController.swift
//  Minitrees
//
//  Created by Kyle Fleming on 11/5/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class EffectsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.sharedInstance.rac_valuesForKeyPath("colorEffects", observer: self).subscribeNext { [unowned self] (_) in
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Model.sharedInstance.colorEffects.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as EffectTableViewCell

        // Configure the cell...
        if indexPath.row == 0 {
            cell.effect = nil
        } else {
            cell.effect = Model.sharedInstance.colorEffects[indexPath.row - 1]
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 || Model.sharedInstance.activeColorEffectIndex == indexPath.row - 1 {
            Model.sharedInstance.activeColorEffectIndex = -1
        } else {
            Model.sharedInstance.activeColorEffectIndex = indexPath.row - 1
        }
    }

}
