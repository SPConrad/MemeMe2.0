//
//  Meme.swift
//  MemeMe2.0
//
//  Created by Sean Conrad on 6/21/18.
//  Copyright © 2018 Sean Conrad. All rights reserved.
//

import UIKit

class MemeClass {
    
    var originalImage: UIImage
    var memedImage: UIImage
    var topText: String
    var bottomText: String
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    
    
    
}
