//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by BRIAN DUVERNEAY on 7/4/17.
//  Copyright © 2017 BRIAN DUVERNEAY. All rights reserved.
//

import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Note: this is not a perfect implementation, but would generally work without issue
        if let memeText = textField.text {
            if (memeText == "TOP") {
                textField.text = ""
            }
            if (memeText == "BOTTOM") {
                textField.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        var newText = textField.text! as NSString
//        print("textField.text = " + (newText as String))
//        newText = newText.replacingCharacters(in: range, with: string) as NSString
//        
//        return newText.length <= 5
//        return true
//    }

}
