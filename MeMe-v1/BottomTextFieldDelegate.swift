//
//  BottomTextFieldDelegate.swift
//  MeMe-v1
//
//  Created by John on 4/20/15.
//  Copyright (c) 2015 John. All rights reserved.
//

import Foundation
import UIKit

class BottomTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    // Delegate methods for bottom text field
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Clear text field when selecting it
        textField.text = ""
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Ensure text is all uppercase
        var newText : NSString = textField.text
        textField.text = newText.stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
        return false
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // If RETURN or DONE are pressed, hide keyboard
        textField.resignFirstResponder()
        return true
    }
}
