//
//  Meme.swift
//  MeMe-v1
//
//  Created by John on 4/25/15.
//  Copyright (c) 2015 John. All rights reserved.
//

import Foundation
import UIKit

// Create a struct for storing our Memes
struct Meme {
    let textTop : String
    let textBottom : String
    let imageOriginal : UIImage
    let imageMemed : UIImage
    
    init(textTop: String, textBottom: String, imageOriginal : UIImage, imageMemed : UIImage ) {
        self.textTop = textTop
        self.textBottom = textBottom
        self.imageOriginal = imageOriginal
        self.imageMemed = imageMemed
    }
    
}


