//
//  MemeTextFieldDelegate.swift
//  MemeMe2.0
//
//  Created by Sean Conrad on 6/21/18.
//  Copyright © 2018 Sean Conrad. All rights reserved.
//

import UIKit

class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    var defaultText = ""
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let currentText = textField.text
        
        // If the current text is placeholder, clear it
        if currentText == textField.placeholder {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /// dismiss the keyboard
        if let currentText = textField.text {
            if currentText == "" {
                textField.text = textField.placeholder
            }
        } 
        textField.resignFirstResponder()
    }
    
    
}
