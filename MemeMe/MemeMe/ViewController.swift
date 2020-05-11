//
//  ViewController.swift
//  MemeMe
//
//  Created by Rahaf Naif on 16/09/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottom: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.topText.delegate = self
        self.bottom.delegate = self
        self.topText.textAlignment = .center
        self.bottom.textAlignment = .center
        self.topText.defaultTextAttributes = memeTextAttributes
        self.bottom.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }


    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    pickAnImage(UIImagePickerController.SourceType.photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(UIImagePickerController.SourceType.camera)
    }
    func pickAnImage(_ source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    //crash here
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black ,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key.strokeWidth: 0.2
    ]
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if topText.text=="TOP" || bottom.text=="BOTTOM"{
            topText.text=""
        }
    }
    
    func textFieldShouldReturn (_ textField: UITextField){
        self.dismiss(animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {

        view.frame.origin.y -= getKeyboardHeight(notification)
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
}

