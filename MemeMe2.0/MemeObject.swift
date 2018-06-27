//
//  MemeObject.swift
//  MemeMe2.0
//
//  Created by Sean Conrad on 6/26/18.
//  Copyright © 2018 Sean Conrad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeClass {
    
    static private var memeArray = [Meme]()
    
    static func numOfMemes() -> Int {
        return memeArray.count
    }
    
    static func getAllMemes() -> [Meme] {
        return memeArray
    }
    
    static func getMeme(indexPath: IndexPath) -> Meme {
        return memeArray[(indexPath as NSIndexPath).row]
    }
    
    static func add(meme: Meme) {
        self.memeArray.append(meme)
    }
    
//    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
//    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
    static func getCoreData(appDelegate: AppDelegate, viewContext: NSManagedObjectContext){
    
    do {
        let request = Meme.fetchRequest() as NSFetchRequest<Meme>
        let sort = NSSortDescriptor(key: #keyPath(Meme.bottomText), ascending:true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        var fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        try fetchedRC.performFetch()
        print(fetchedRC)
        for meme in fetchedRC.fetchedObjects! {
            add(meme: meme)
            //memeArray = fetchedRC.fetchedObjects!
        }
        //let meme = fetchedRC.object(at: indexPath)
        //MemeClass.add(meme: meme)
        // set the image
//        if let data = meme.memedImage as Data? {
//            cell.memeImageView?.image = UIImage(data:data)
//        }
        } catch {
            let error = error as NSError
        fatalError("Could not fetch. \(error), \(error.userInfo)")
    }
    }
    
}
