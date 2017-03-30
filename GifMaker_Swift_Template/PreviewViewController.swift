//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Brittany Sprabery on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

protocol PreviewViewControllerDelegate {
    func previewVC(preview: PreviewViewController, didSaveGif gif: GIF)
}

class PreviewViewController: UIViewController {
    
    var delegate: PreviewViewControllerDelegate?
    var gif : GIF?
    
    @IBAction func createAndSave(_ sender: AnyObject) {
        let _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    @IBAction func shareGif(_ sender: AnyObject) {
        let url: NSURL = (self.gif?.url)!
        let animatedGif = NSData(contentsOf: url as URL)!
        let itemsToShare = [animatedGif]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                let _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        navigationController?.present(activityVC, animated: true, completion: nil)
    }
    
    
}
