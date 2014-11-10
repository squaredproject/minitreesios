//
//  ViewController.swift
//  Minitrees
//
//  Created by Kyle Fleming on 10/25/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

let bonjourServiceName = "_minitree._tcp."

class ViewController: UIViewController, NSNetServiceBrowserDelegate {
    
    var serviceBrowser = NSNetServiceBrowser()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configure Service Browser
        self.serviceBrowser.delegate = self
        self.serviceBrowser.searchForServicesOfType(bonjourServiceName, inDomain: "local.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didFindService aNetService: NSNetService, moreComing: Bool) {
        if aNetService.type == bonjourServiceName {
            println("got \(aNetService.addresses)")
        }
    }

}

