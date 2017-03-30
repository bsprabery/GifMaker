//
//  EditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Brittany Sprabery on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit


class EditorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var gifImageView: UIImageView!
    @IBOutlet var captionTextField: UITextField!
    
    var gif: GIF?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gifImageView.image = gif?.gifImage
        subscribeToKeyboardWillShowNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        subscribeToKeyboardWillHideNotification()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        captionTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        captionTextField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardWillShowNotification() {
        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillShow:")), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotification() {
        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillHide:")), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y >= 0  {
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
        } else {}
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y < 0 {
            view.frame.origin.y += getKeyboardHeight(notification: notification)
        } else {}
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @IBAction func presentPreview(sender: AnyObject) {
        let previewVC: PreviewViewController = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        self.gif?.caption = self.captionTextField.text
        let regift = Regift(sourceFileURL: self.gif?.videoURL as! URL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        
        let captionFont = self.captionTextField.font
        let gifURL = regift.createGif(caption: self.captionTextField.text, font: captionFont)
        
        let newGif = GIF(url: gifURL! as NSURL, videoURL: (self.gif?.videoURL)!, caption: self.captionTextField.text)
        previewVC.gif = newGif
        
        navigationController?.pushViewController(previewVC, animated: true)
    }
    

}
