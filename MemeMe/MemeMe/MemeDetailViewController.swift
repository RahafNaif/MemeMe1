//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Rahaf Naif on 05/10/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit

class MemeDetailViewController : UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: [MemeEditorViewController.Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.imageView!.image = UIImage(named: memes.memedImage)
    }
}
