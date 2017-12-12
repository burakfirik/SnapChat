//
//  UserTableViewController.swift
//  SnapChat
//
//  Created by Burak Firik on 12/10/17.
//  Copyright © 2017 Code Path. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserTableViewController: UITableViewController{
  
  var users: [User] = []
  
  var imageName = ""
  var message = ""
  var imageURL = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    FIRDatabase.database().reference().child("users").observe(.childAdded) { (snapshot) in
      if let userDict = snapshot.value as? NSDictionary {
        if let email = userDict["email"] as? String {
          
          let user = User()
          user.email = email
          user.uid = snapshot.key
          self.users.append(user)
          self.tableView.reloadData()
        }
      }
    }
    
    
    
    
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return users.count
  }
  
 
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
    
    // Configure the cell...
    let user = users[indexPath.row]
    cell.textLabel?.text = user.email
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user = users[indexPath.row]
    if let fromEmail = FIRAuth.auth()?.currentUser?.email {
      let snapDict = ["from":fromEmail, "imageName":imageName,"imageURL":imageURL, "message":message]
      FIRDatabase.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snapDict)
      navigationController?.popToRootViewController(animated: true)
    }
    
  }
  
}



class User{
  var email = ""
  var uid = ""
  
}
