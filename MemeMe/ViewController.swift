//
//  ViewController.swift
//  MemeMe
//
//  Created by BRIAN DUVERNEAY on 7/4/17.
//  Copyright © 2017 BRIAN DUVERNEAY. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    let memeTextDelegate = MemeTextFieldDelegate()

    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
    
    @IBOutlet var memeTopTextView: UITextField!
    @IBOutlet var memeBottomTextView: UITextField!
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    @IBAction func shareButtonPressed() {
        print ("share button pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup TextViews
        memeTopTextView.defaultTextAttributes = memeTextAttributes
        memeBottomTextView.defaultTextAttributes = memeTextAttributes
        memeTopTextView.textAlignment = NSTextAlignment.center
        memeBottomTextView.textAlignment = NSTextAlignment.center
        memeBottomTextView.delegate = memeTextDelegate
        memeTopTextView.delegate = memeTextDelegate
        
        // TEST
        generateMemedImage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func generateMemedImage() -> UIImage {
//        print ("generate memed image")
//        var memeView : UIView? = nil
//        for subview in self.view.subviews {
//            //print("subview: ", subview.tag)
//            if (subview.tag == 10) {
//                print("meme frame", subview.frame.size)
//                memeView = subview
//                break
//            }
//        }
//        if let meme = memeView {
//            UIGraphicsBeginImageContext(meme.frame.size)
//            view.drawHierarchy(in: meme.frame, afterScreenUpdates: true)
//        }
//        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return memedImage
        return UIImage()
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        print("pick an image from album")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        print("pick an image from camera")
        let imageCamera = UIImagePickerController()
        imageCamera.delegate = self
        imageCamera.sourceType = .camera
        present(imageCamera, animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("imagePicker didFinishPicking")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePicker didCancel")
        // dismiss the modally displayed viewcontroller
        dismiss(animated: true, completion: nil)
    }
    func keyboardWillShow(_ notification:Notification) {
        if (memeBottomTextView.isFirstResponder) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(_ notification:Notification) {
        if (memeBottomTextView.isFirstResponder) {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

}

