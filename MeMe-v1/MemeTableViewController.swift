//
//  MemeTableViewController.swift
//  MeMe-v1
//
//  Created by John on 4/25/15.
//  Copyright (c) 2015 John. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var memes: [Meme]!
    var firstLoad = true
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure tab bar is not hidden
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Whenever view appears, load Memes
        loadMemes()
        
        //Check if Memes exist and if this is first time loading
        if self.memes.count == 0 && firstLoad {
            
            // Bring up Meme Editor
            firstLoad = false
            addMeme()
        
        } else {
            
            // Otherwise, refresh table
           self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To be safe, load Memes right away for table delegate
        loadMemes()

    }
    
    
    
    ///////////////// MEME FUNCTIONS /////////////////////////////////
    
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
    
    
    
    ///////////////// TABLE VIEW DELEGATES ///////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Determine number of rows
        
        return self.memes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Populate table cell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        // Get a Meme
        let memeItem = self.memes[indexPath.row]
        
        // Set cell to Meme name and image
        cell.textLabel?.text = memeItem.textTop
        cell.imageView?.image = memeItem.imageMemed
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Table row has been selected
        
        // Get reference to Meme Detail View
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        
        // Set Detail View property to selected Meme
        detailController.meme = self.memes[indexPath.row]
        
        // Show Meme Detail View
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    


    ///////////////// SENT BUTTONS ///////////////////////////
    
    @IBAction func addPressed(sender: UIBarButtonItem) {
        addMeme()
        
    }



    
    
}
