//
//  RootViewController.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 11/26/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var navDisplayViewController: NDViewController?

    @IBOutlet var modeButton: UIButton!
    @IBOutlet var nav1Button: UIButton!
    @IBOutlet var nav2Button: UIButton!
    @IBOutlet var rangeButton: UIButton!
    @IBOutlet var startBITButton: UIButton!
    
    
    @IBAction func incrementMode(_ sender: AnyObject) {
        if let navDisplay = navDisplayViewController {
            navDisplay.incrementMode()
        }
    }
    
    @IBAction func incrementNav1Source(_ sender: AnyObject) {
        if let navDisplay = navDisplayViewController {
            navDisplay.incrementNav1Source()
        }
    }
    
    @IBAction func incrementNav2Source(_ sender: AnyObject) {
        if let navDisplay = navDisplayViewController {
            navDisplay.incrementNav2Source()
        }
    }
    
    @IBAction func incrementRange(_ sender: AnyObject) {
        if let navDisplay = navDisplayViewController {
            navDisplay.incrementRange()
        }
    }
    
    @IBAction func startBIT(_ sender: AnyObject) {
        if let navDisplay = navDisplayViewController {
            modeButton.isEnabled = false
            nav1Button.isEnabled = false
            nav2Button.isEnabled = false
            rangeButton.isEnabled = false
            startBITButton.isEnabled = false
            navDisplay.startBIT() { (finished: Bool) in
                self.modeButton.isEnabled = true
                self.nav1Button.isEnabled = true
                self.nav2Button.isEnabled = true
                self.rangeButton.isEnabled = true
                self.startBITButton.isEnabled = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedNDView" {
            navDisplayViewController = segue.destination as? NDViewController
        }
    }
}

