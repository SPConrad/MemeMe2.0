//
//  MemeCollectionViewController.swift
//  MemeMe2.0
//
//  Created by Sean Conrad on 6/21/18.
//  Copyright © 2018 Sean Conrad. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    private var memes = [Meme]()
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            memes = try context.fetch(Meme.fetchRequest())
        } catch {
            let error = error as NSError
            fatalError("Could not fetch. \(error), \(error.userInfo)")
        }
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    /// How many memes are in the list? 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // set the image
        if let data = meme.memedImage as Data? {
            cell.memeImageView?.image = UIImage(data:data)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
    }
    
}
