//
//  AddImageViewController.swift
//  SnapChat
//
//  Created by Burak Firik on 12/9/17.
//  Copyright © 2017 Code Path. All rights reserved.
//

import UIKit
import FirebaseStorage

class AddImageViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descTextField: UITextField!
  
  
  var imageName = "\(NSUUID().uuidString).jpeg"
  var imageURL = ""
  var imagePicker =  UIImagePickerController()
  override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func cameraTapped(_ sender: Any) {
    imagePicker.sourceType = .camera
    present(imagePicker, animated: true, completion: nil)
  }
  @IBAction func photoTapped(_ sender: Any) {
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true, completion: nil)
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = chosenImage
    }
    imagePicker.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func nextButtonTapped(_ sender: Any) {
    let imageFolder = FIRStorage.storage().reference().child("images")
    if let image = imageView.image {
      if let imageData =  UIImageJPEGRepresentation(image, 0.1) {
        imageFolder.child(imageName).put(imageData, metadata: nil, completion: { (metadata, error) in
          if let error = error {
            print(error)
          } else {
            if let imageURL = metadata?.downloadURL()?.absoluteString {
              self.imageURL = imageURL
              self.performSegue(withIdentifier: "userSegue", sender: nil)
            }
          }
        })
        
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let userVC = segue.destination as? UserTableViewController {
      userVC.imageName = self.imageName
      userVC.imageURL = self.imageURL
      if let message = descTextField.text {
         userVC.message = message
      }
     
    }
  }
  
}
