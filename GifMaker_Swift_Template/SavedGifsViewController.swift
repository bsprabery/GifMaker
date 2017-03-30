//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Brittany Sprabery on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class SavedGifsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PreviewViewControllerDelegate {
    
    var gifsFilePath: String {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsPath = directories[0]
        let gifsPath = documentsPath.appending("/savedGifs")
        return gifsPath
    }
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emptyView: UIStackView!
    
    let cellMargin: CGFloat = 12.0
    var savedGifs = [GIF]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyView.isHidden = (savedGifs.count != 0)
        collectionView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showWelcome()
        unarchiveObjectWithFile()
    }
    
    func showWelcome() {
        if UserDefaults.standard.bool(forKey: "WelcomeViewController") != true {
            let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            self.navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
    
    //This could be really wrong:
    func unarchiveObjectWithFile() {
         self.savedGifs = NSKeyedUnarchiver.unarchiveObject(withFile: gifsFilePath) as! [GIF]
    }
    
    @IBAction func recordButton(_ sender: AnyObject) {
        presentVideoOptions()
    }
    
    //MARK: CollectionView Delegate and Datasource Methods: 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif = savedGifs[indexPath.item]
        cell.configureForGif(gif: gif)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.gif = self.savedGifs[indexPath.row]
        present(detailController, animated: true, completion: nil)
        
    }
    
    //MARK: CollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2
        let size = CGSize(width: width, height: width)
        return size
    }
    
    //MARK: PreviewViewControllerDelegate
    
    func previewVC(preview: PreviewViewController, didSaveGif gif: GIF) {
        savedGifs.append(gif)
        NSKeyedArchiver.archiveRootObject(savedGifs, toFile: gifsFilePath)
    }
    
}
