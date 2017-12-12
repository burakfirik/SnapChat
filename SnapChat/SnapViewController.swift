//
//  SnapViewController.swift
//  SnapChat
//
//  Created by Burak Firik on 12/10/17.
//  Copyright © 2017 Code Path. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImage

class SnapViewController: UIViewController {
  
  var snapshot : FIRDataSnapshot?
  @IBOutlet weak var snapLabel: UILabel!
  @IBOutlet weak var snapImage: UIImageView!
  var imageName : String!
  var snapID : String!
  override func viewDidLoad() {
    super.viewDidLoad()
    if let snapshot = snapshot {
      if let snapDict = snapshot.value as? NSDictionary {
        
        if let message = snapDict["message"] as? String {
         
          if let imageName = snapDict["imageName"]  as? String{
            if let imageURL = snapDict["imageURL"] as? String {
               snapLabel.text = message
              if let url = URL(string: imageURL) {
                snapImage.sd_setImage(with: url)
              }
              self.imageName = imageName
              self.snapID  = snapshot.key
              
            }
          }
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if let uid = FIRAuth.auth()?.currentUser?.uid {
      FIRDatabase.database().reference().child("users").child(uid).child("snaps").child(snapID).removeValue()
      FIRStorage.storage().reference().child("images").child(imageName).delete(completion: nil)
    }
  }
  
}
