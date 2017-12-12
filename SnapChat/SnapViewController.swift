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

class SnapViewController: UIViewController {
  
  var snapshot : FIRDataSnapshot?
  @IBOutlet weak var snapLabel: UILabel!
  @IBOutlet weak var snapImage: UIImageView!
  
  var snapImg: UIImage!
  var snapDsc: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let snapshot = snapshot {
      if let snapDict = snapshot.value as? NSDictionary {
        
        if let message = snapDict["message"] as? String {
          snapLabel.text = message
          if let imageName = snapDict["imageName"]  as? String{
            if let imageFolder = FIRStorage.storage().reference().child("images") as? NSDictionary {
              if let image =  imageFolder[imageName] as? UIImage {
               snapImg = image
              // snapLabel.text = message
              }
            }
          }
        }
      }}
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
}
