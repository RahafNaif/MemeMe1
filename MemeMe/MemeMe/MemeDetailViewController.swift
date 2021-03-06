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
    
    var meme:Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView?.image = meme.memedImage
        
        view.addSubview(imageView)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFit
        self.imageView?.image = meme.memedImage
       
    }
    
    
}
