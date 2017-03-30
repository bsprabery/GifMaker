//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Brittany Sprabery on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation


let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0

extension UIViewController: UINavigationControllerDelegate {
    
    @IBAction func launchVideoCamera(_ sender: AnyObject) {
        let recordVideoController = UIImagePickerController()
        recordVideoController.sourceType = UIImagePickerControllerSourceType.camera
        recordVideoController.mediaTypes = [kUTTypeMovie as String]
        recordVideoController.allowsEditing = false
        recordVideoController.delegate = self
        
        present(recordVideoController, animated: true, completion: nil)
    }
    
    func imagePicker(_ source: UIImagePickerControllerSourceType) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = true
        picker.delegate = self
        
        return picker
    }
    
    //TODO: Write a createPath function
    
    func createPath() -> String {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        let documentsDirectory = paths[0]
        let manager = FileManager.default
        let outputURL = documentsDirectory.appending("output")
        let url = URL(string: outputURL)
        
        do {
            try manager.createDirectory(at: url!, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("There was an error creating the directory.")
        }
        
        let urlToReturn = outputURL.appending("output.mov")

        return urlToReturn
    }
    
    func cropVideoToSquare(_ rawVideoURL: URL, start: NSNumber?, duration: NSNumber?) {
        let videoAsset = AVAsset(url: rawVideoURL as URL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        let instruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(60, 30))
        
        let transformer: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let firstTransform = CGAffineTransform(translationX: CGFloat(videoTrack.naturalSize.height),
                                               y: CGFloat(-(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2.0))
        let halfOfPi = CGFloat(M_PI_2)

        let secondTransform = firstTransform.rotated(by: halfOfPi)
        let finalTransform = secondTransform
        
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = videoComposition
        let path = createPath()
        exporter.outputURL = URL(fileURLWithPath: path)
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        
        var squareURL = URL(string: path)
        exporter.exportAsynchronously {
            squareURL = exporter.outputURL!
            self.convertVideoToGIF(squareURL!, start: start, duration: duration)
        }
    }
}

extension UIViewController: UIImagePickerControllerDelegate {
    
    @IBAction func presentVideoOptions() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            // launchPhotoLibrary()
        } else {
            let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let recordVideo = UIAlertAction(title: "Record a Video", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.launchVideoCamera(AnyObject.self as AnyObject)
            })
            
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                // self.launchPhotoLibrary()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            newGifActionSheet.addAction(recordVideo)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            
            present(newGifActionSheet, animated: true, completion: nil)
            let pinkColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            newGifActionSheet.view.tintColor = pinkColor
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeMovie as String {
            let url = info[UIImagePickerControllerMediaURL] as! URL
            let start: NSNumber? = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let end: NSNumber? = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(value: (end!.floatValue) - (start.floatValue))
            } else {
                duration = nil
            }
            
            convertVideoToGIF(url, start: start, duration: duration)
            cropVideoToSquare(url, start: start, duration: duration)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func convertVideoToGIF(_ videoURL: URL, start: NSNumber?, duration: NSNumber?) {
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        
        let regift: Regift
        if let start = start {
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, startTime: start.floatValue, duration: duration!.floatValue, frameRate: frameCount, loopCount: loopCount)
        } else {
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }
        
        let gifURL = regift.createGif()
        let gif = GIF(url: gifURL! as NSURL, videoURL: videoURL as NSURL, caption: nil)
        
        displayGIF(gif)
    }
    
    func displayGIF(_ gif: GIF) {
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! EditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
    }

}
