//
//  ViewController.swift
//  MemeMe2.0
//
//  Created by Sean Conrad on 6/21/18.
//  Copyright © 2018 Sean Conrad. All rights reserved.
//

import UIKit
import AVKit
import NotificationCenter
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var textFields = [UITextField]()
    
    private var memes = [Meme]()
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var keyboardIsDisplayed = false
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 45)!,
        NSAttributedStringKey.strokeWidth.rawValue: -8]
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupTextFields() {
        textFields.append(self.topText)
        textFields.append(self.bottomText)
        
        for textfield in textFields {
            textfield.delegate = memeTextFieldDelegate
            textfield.defaultTextAttributes = memeTextAttributes
            textfield.text = textfield.placeholder
            textfield.textAlignment = .center
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        if !keyboardIsDisplayed {
            if bottomText.isFirstResponder {
                let amountToMove = (self.tabBarController?.tabBar.frame.height)! + (self.toolbar?.frame.height)!
                self.view.frame.origin.y -= getKeyboardHeight(notification) - amountToMove
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardDidShow(_ notification:Notification){
        keyboardIsDisplayed = true
    }
    
    @objc func keyboardDidHide(_ notification:Notification){
        keyboardIsDisplayed = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        setupTextFields()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showImagePicker(sourceType: UIImagePickerControllerSourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromAlbum(_ sender: Any){
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        switch photoStatus {
            case .authorized:
                self.showImagePicker(sourceType: .photoLibrary)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        self.showImagePicker(sourceType: .photoLibrary)
                    } else {}
                })
            case .denied:
                showAlert(title: "Unable to access photo library", message: "Please grant access to the photo library in your settings")
            case .restricted:
                showAlert(title: "Unable to access photo library", message: "Please grant access to the photo library in your settings")
        }
    
    }
    
    
    @IBAction func pickImageFromCamera(_sender: Any){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if !response {
                /// user has denied access to the camera, pop message requesting they enable it
                self.showAlert(title: "Unable to access camera", message: "Please grant access to the camera in your settings")
            } else {
                self.showImagePicker(sourceType: .camera)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    func generateMemedImage() -> UIImage {
        self.toolbar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.safeAreaLayoutGuide.layoutFrame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.toolbar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        return memedImage
    }
    
    func save(){
        if let originalImage = imageView.image {
            let memedImage = generateMemedImage()
            
            let imageToShare = [ memedImage ]
            
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            // so that iPads won't crash (but for why?) TODO: research this, don't submit without looking into it.
            /// REVIEWER: If I haven't edited this with why this helps, reject this submission
            
            activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook ]
            
            present(activityViewController, animated: true, completion: nil)
            
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                if success {
                    if activity?.rawValue == "com.apple.UIKit.activity.SaveToCameraRoll" {
                        guard let originalImageData = UIImagePNGRepresentation(originalImage) as Data?
                            else {
                            print("error when converting original image data")
                            return
                        }
                        guard let memedImageData = UIImagePNGRepresentation(memedImage) as Data?
                            else {
                            print("error when converting memed image data")
                            return
                        }
                        let meme = Meme(entity: Meme.entity(), insertInto: self.context)
                        
                        meme.topText = self.topText.text!
                        meme.bottomText = self.bottomText.text!
                        meme.originalImage = originalImageData
                        meme.memedImage = memedImageData
                        self.appDelegate.saveContext()
                        self.memes.append(meme)
                        self.imageView.image = nil
                        self.saveButton.isEnabled = false
                        self.topText.text = self.topText.placeholder
                        self.bottomText.text = self.bottomText.placeholder
                    }
                }
            }
        }
    }
    
    @IBAction func saveImage(_sender: Any){
        save()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            saveButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        super.viewWillDisappear(animated)
    }
}

