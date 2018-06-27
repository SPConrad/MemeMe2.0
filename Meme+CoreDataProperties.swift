//
//  Meme+CoreDataProperties.swift
//  MemeMe2.0
//
//  Created by Sean Conrad on 6/26/18.
//  Copyright © 2018 Sean Conrad. All rights reserved.
//
//

import Foundation
import CoreData


extension Meme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meme> {
        return NSFetchRequest<Meme>(entityName: "Meme")
    }

    @NSManaged public var bottomText: String?
    @NSManaged public var memedImage: NSData?
    @NSManaged public var originalImage: NSData?
    @NSManaged public var topText: String?

}
