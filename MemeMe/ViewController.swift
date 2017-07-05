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

    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

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

}

