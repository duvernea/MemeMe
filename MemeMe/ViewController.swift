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
    @IBOutlet var memeView: UIView!

    
    var memedImage: UIImage!

    
    @IBAction func shareButtonPressed() {
        print ("share button pressed")
        memedImage = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [memedImage, "My Meme"], applicationActivities: nil)
        
        
        self.present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (activityType, completed, items, error) in
            
            guard completed else { print("User cancelled."); return }
            
            // save the meme
            self.save()
            
            print("Completed With Activity Type: \(activityType)")
            
        }
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
        
        setShareButton()
        self.imagePickerView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin]
        self.memeView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin]

        
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
        print ("generate memed image")
        var memeView : UIView? = nil
        for subview in self.view.subviews {
            //print("subview: ", subview.tag)
            if (subview.tag == 10) {
                print("meme frame", subview.frame.size)
                memeView = subview
                break
            }
        }
        if let meme = memeView {
            UIGraphicsBeginImageContext(meme.bounds.size)
            meme.layer.render(in: UIGraphicsGetCurrentContext()!)
            let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!

            //view.drawHierarchy(in: meme.frame, afterScreenUpdates: true)
            UIGraphicsEndImageContext()
            return img
        
    }
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
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
        setShareButton()
        resizeImageView()
        present(imageCamera, animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("imagePicker didFinishPicking")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        setShareButton()
        resizeImageView()
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePicker didCancel")
        // dismiss the modally displayed viewcontroller
        dismiss(animated: true, completion: nil)
    }
    func setShareButton() {
        if (imagePickerView.image == nil) {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
    }
    func save() {
        // Create the meme
        let meme = Meme(topText: memeTopTextView.text!, bottomText: memeBottomTextView.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
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
    func resizeImageView() {
        var widthRatio = imagePickerView.bounds.size.width / (imagePickerView.image?.size.width)!
        var heightRatio = imagePickerView.bounds.size.height / (imagePickerView.image?.size.height)!
        var scale =  widthRatio < heightRatio ? widthRatio : heightRatio
        var imageWidth = scale * (imagePickerView.image?.size.width)!
        var imageHeight = scale * (imagePickerView.image?.size.height)!
        
        memeView.frame = CGRect(x:0, y:0, width:imageWidth, height:imageHeight);
        memeView.center = (memeView.superview?.center)!;
        // imagePickerView.frame = CGRect(x:0, y:0, width:imageWidth, height:imageHeight);
        // imagePickerView.center = (imagePickerView.superview?.center)!;
        view.layoutIfNeeded()
        /// memeTopTextView.layoutIfNeeded()
        // memeBottomTextView.layoutIfNeeded()
        
    
    }

}

