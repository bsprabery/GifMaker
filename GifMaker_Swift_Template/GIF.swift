//
//  GIF.swift
//  GifMaker_Swift_Template
//
//  Created by Brittany Sprabery on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class GIF: NSObject, NSCoding {
    
    let url: NSURL
    var caption: String?
    let gifImage: UIImage
    let videoURL: NSURL
    let gifData: NSData?
    
    init(url: NSURL, videoURL: NSURL, caption: String?) {
        
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifData = nil
        self.gifImage = UIImage.gif(url.absoluteString!)!
    }
    
//    init(name: String) {
//        self.gifImage = UIImage.gif(name: name)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey: "url") as! NSURL
        self.videoURL = aDecoder.decodeObject(forKey: "videoURL") as! NSURL
        self.caption = aDecoder.decodeObject(forKey: "caption") as? String
        self.gifImage = aDecoder.decodeObject(forKey: "gifImage") as! UIImage
        self.gifData = aDecoder.decodeObject(forKey: "gifData") as? NSData
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.videoURL, forKey: "videoURL")
        aCoder.encode(self.caption, forKey: "caption")
        aCoder.encode(self.gifData, forKey: "gifData")
        aCoder.encode(self.gifImage, forKey: "gifImage")
    }
}
