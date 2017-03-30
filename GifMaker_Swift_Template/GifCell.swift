//
//  GifCell.swift
//  GifMaker_Swift_Template
//
//  Created by Brittany Sprabery on 3/21/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet var gifImageView: UIImageView!
    
    func configureForGif(gif: GIF) {
        gifImageView.image = gif.gifImage
    }
}
