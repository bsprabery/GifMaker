//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Brittany Sprabery on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet var gifImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let firstLaunchGif = UIImage.gif(name: "tinaFeyHiFive")
        gifImageView.image = firstLaunchGif
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "WelcomeViewController")
    }
}
