//
//  MemeCollectionViewController.swift
//  MeMe-v1
//
//  Created by John on 4/25/15.
//  Copyright (c) 2015 John. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {

    var memes: [Meme]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Whenever view appears, load memes
        loadMemes()
        
        //Check if Memes exist
        if self.memes.count > 0 {
             //Otherwise, refresh table
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To be safe, load Memes for table delegate
        loadMemes()

    }

    
    ///////////////// MEME FUNCTIONS //////////////////////////
    
    func loadMemes() {
        //Load Memes from AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    
    func addMeme() {
        //Add Memes by popping up the Meme Editor
        
        var controller: MemeEditViewController
        
        // Get reference to Edit View and show it
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditViewController") as! MemeEditViewController
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    ///////////////// COLLECTION VIEW DELGATES ///////////////////////
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Determine number of items in collection
        return self.memes.count
    }
    

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Populate collection cells
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        // Get a Meme
        let memeItem = self.memes[indexPath.row]
        
        // Set cell to Meme image using the background view
        let imageView = UIImageView(image: memeItem.imageMemed)
        cell.backgroundView = imageView
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)  {
        // Collection cell has been selected
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        
        // Set Detail View property to selected Meme
        detailController.meme = self.memes[indexPath.row]
        
        // Show Meme Detail View
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
    ///////////////// SENT BUTTON ACTIONS ////////////////////////
    
    @IBAction func addPressed(sender: UIBarButtonItem) {
        addMeme()
    }

}
