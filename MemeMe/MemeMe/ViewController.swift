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
    @IBOutlet weak var share: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.topText.delegate = self
        self.bottom.delegate = self
        self.topText.textAlignment = .center
        self.bottom.textAlignment = .center
        self.topText.text="TOP"
        self.bottom.text="BOTTOM"
        self.topText.defaultTextAttributes = memeTextAttributes
        self.bottom.defaultTextAttributes = memeTextAttributes
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        share.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }


    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    pickAnImage(UIImagePickerController.SourceType.photoLibrary)
        share.isEnabled = true
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(UIImagePickerController.SourceType.camera)
        share.isEnabled = true
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
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black ,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "impact", size: 40)!,
        NSAttributedString.Key.strokeWidth: 3
    ]
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if topText.text=="TOP" && textField == topText {
            topText.text=""
        }
        if bottom.text=="BOTTOM" && textField == bottom {
            bottom.text=""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottom.isFirstResponder{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y=0
    }
    
    struct Meme {
        
        var topText:String
        var bottomText:String
        var orginalImage:UIImage
        var memedImage:UIImage
        
    }
    
    func generateMemedImage() -> UIImage {
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = false
        
        return memedImage
    }
    
    func save() {
            // Create the meme
        
        _ = Meme(topText: topText.text!, bottomText: bottom.text!, orginalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    @IBAction func shareImage(_ sender: Any) {
        
        let memed = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memed], applicationActivities: nil)
        self.present(controller, animated: true, completion:nil )
        
        controller.completionWithItemsHandler = { (activity, success, items, error) in
        if(success) {
                self.save()
          }
         }
    }
    
    @IBAction func cancel(_ sender: Any) {
        share.isEnabled = false
        imageView.image = nil
        topText.text = "TOP"
        bottom.text = "BOTTOM"
    }
    
    
    
}//class
