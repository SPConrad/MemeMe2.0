//
//  MemeCollectionViewController.swift
//  MemeMe2.0
//
//  Created by Sean Conrad on 6/21/18.
//  Copyright © 2018 Sean Conrad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeCollectionViewController: UICollectionViewController {
    
    var fetchedRC: NSFetchedResultsController<Meme>! = nil
    
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("collection view will appear")
        MemeClass.getCoreData(appDelegate: appDelegate, viewContext: context)
//        do {
//            let request = Meme.fetchRequest() as NSFetchRequest<Meme>
//            let sort = NSSortDescriptor(key: #keyPath(Meme.bottomText), ascending:true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
//            request.sortDescriptors = [sort]
//            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//            try fetchedRC.performFetch()
//            self.collectionView?.reloadData()
//            print(fetchedRC)
//        } catch {
//            let error = error as NSError
//            fatalError("Could not fetch. \(error), \(error.userInfo)")
//        }
    }
    
    /// How many memes are in the list? 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemeClass.numOfMemes()
        //return fetchedRC.fetchedObjects?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        //let meme = fetchedRC.object(at: indexPath)
        let meme = MemeClass.getMeme(indexPath: indexPath)
        // set the image
        if let data = meme.memedImage as Data? {
            cell.memeImageView?.image = UIImage(data:data)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = MemeClass.getMeme(indexPath: indexPath)
    }
    
}
