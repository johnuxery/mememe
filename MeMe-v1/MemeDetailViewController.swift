//
//  MemeDetailViewController.swift
//  MeMe-v1
//
//  Created by John on 5/2/15.
//  Copyright (c) 2015 John. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var memeDetail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide tab bar
        self.tabBarController?.tabBar.hidden = true
        
        //Display Meme image
        self.memeDetail.image = meme.imageMemed
    }
    


}
