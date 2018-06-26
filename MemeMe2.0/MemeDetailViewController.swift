//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by Sean Conrad on 6/21/18.
//  Copyright © 2018 Sean Conrad. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        if let data = meme.memedImage as Data? {
            self.imageView.image = UIImage(data:data)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
