//
//  ViewController.swift
//  SnapChat
//
//  Created by Burak Firik on 12/9/17.
//  Copyright © 2017 Code Path. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var topButton: UIButton!
  @IBOutlet weak var bottomButton: UIButton!
  
  var loginMode = true
  
  @IBAction func topTapped(_ sender: Any) {
    if let email = emailTextField.text {
      if let password = passwordTextField.text {
        if loginMode {
          FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
              print(error)
            } else {
              print("Login successful!")
              self.performSegue(withIdentifier: "authToSnaps", sender: nil)
            }
          })
        } else {
          FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
              print(error)
            } else {
              if let user = user {
                FIRDatabase.database().reference().child("users").child(user.uid).child("email").setValue(email)
                self.performSegue(withIdentifier: "authToSnaps", sender: nil)
              }
              
            }
            
          })
        }
      }
    }
    
    
  }
  
  @IBAction func bottomTapped(_ sender: Any) {
    if loginMode {
      // Swicth to Sign up
      topButton.setTitle("Sign Up", for: .normal)
      bottomButton.setTitle("Switch to Login", for: .normal)
      loginMode = false
    } else {
      // Switch to Login
      topButton.setTitle("Login", for: .normal)
      bottomButton.setTitle("Switch to Sign Up", for: .normal)
      loginMode = true
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  
  
  
}

