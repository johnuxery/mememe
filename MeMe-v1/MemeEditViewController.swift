//
//  MemeEditViewController.swift
//  MeMe-v1
//
//  Created by John on 4/19/15.
//  Copyright (c) 2015 John. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    
    let topDelegate = TopTextFieldDelegate()
    let bottomDelegate = BottomTextFieldDelegate()

    var memedImage : UIImage!
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do setup before loading the view.
        
        // Subscribe to keyboard notifications
        self.subscribeToKeyboardNotifications()
        
        // Set text field delegates
        self.topField.delegate = topDelegate
        self.bottomField.delegate = bottomDelegate
        
        // Set text field Attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -4,
        ]
        topField.defaultTextAttributes = memeTextAttributes
        bottomField.defaultTextAttributes = memeTextAttributes
        
        
        // Center text in text field
        topField.textAlignment = NSTextAlignment.Center
        bottomField.textAlignment = NSTextAlignment.Center
        
        
        
        // Check if camera available, if not, disable camera button
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // TODO: Check if imageView is empty and if so, hide Share button
        if imagePickerView.image == nil {
            shareButton.enabled = false
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        // Set default text for fields
        topField.text = "TOP"
        bottomField.text = "BOTTOM"
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Do the following before view disappears
        
        // Unsubscribe from keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    func dismissMemeEditor() {
        //Dismiss Meme Editor modal
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    ////////////////// IMAGE PICKER HANDLERS ////////////////////

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        //ImagePicker finished, check if an image was picked
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            // Enable Share button
            shareButton.enabled = true
        }
    }
    
    

    
    
    /////////////////// MEME FUNCTIONS ///////////////////////////
    
    func saveMeme() {

        //Save the Meme to the Memes array
        var meme = Meme( textTop: topField.text!, textBottom: bottomField.text!, imageOriginal:
            imagePickerView.image!, imageMemed: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    func doneSharing(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
        
        //Called when ActivityViewController completes
        if completed {
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
            self.dismissMemeEditor()
        }
    }
    
    
    func generateMemedImage() -> UIImage {
        //Generate MemedImage
        
        // Hide toolbar and navbar
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.topToolbar.hidden = false
        self.bottomToolbar.hidden = false
        
        return memedImage
    }
    
    

    ///////////////////// SENT BUTTON ACTIONS ///////////////////////

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        // If Album button pressed, bring up image picker for album
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }


    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        // If Camera button pressed, bring up image picker for camera
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        //Generate memedImage and call ActivityView
        
        self.memedImage = generateMemedImage()
        
        let activityVC = UIActivityViewController(activityItems: [self.memedImage!],
            applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = doneSharing
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        // If Cancel button pressed, dismiss editor modal
        self.dismissMemeEditor()
    }
    
    

    ////////////////////// KEYBOARD DELEGATE ///////////////////////////
    
    func subscribeToKeyboardNotifications() {
        // Subscribe to keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        // Unsubscribe from keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        // If keyboard appears while editing bottom text field, shift screen up height of keyboard
        if bottomField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        // If keyboard hides while editing bottom text field, shift screen back down
        if bottomField.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // Get keyboard height so we can move the rest of the screen up or down
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    

}

