//
//  DetailViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Brittany Sprabery on 3/22/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var gifImageView: UIImageView!
    
    var gif: GIF?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifImageView.image = gif?.gifImage
    }
    
    @IBAction func closeDetailView(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
