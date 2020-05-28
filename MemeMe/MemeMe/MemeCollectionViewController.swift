//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Rahaf Naif on 24/09/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    var memes: [MemeEditorViewController.Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    
}
