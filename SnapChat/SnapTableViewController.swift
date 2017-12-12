//
//  SnapTableViewController.swift
//  SnapChat
//
//  Created by Burak Firik on 12/9/17.
//  Copyright © 2017 Code Path. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SnapTableViewController: UITableViewController {
  
  var snaps: [FIRDataSnapshot] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let uid = FIRAuth.auth()?.currentUser?.uid {
      FIRDatabase.database().reference().child("users").child(uid).child("snaps").observe(.childAdded) { (snapshot) in
        self.snaps.append(snapshot)
        self.tableView.reloadData()
        FIRDatabase.database().reference().child("users").child(uid).child("snaps").observe(.childRemoved, with: { (snapshot) in
          var index = 0
          for snap in self.snaps {
            if snapshot.key == snap.key {
              self.snaps.remove(at: index)
            }
            index = index + 1
           }
          self.tableView.reloadData()
        })
      }
    }
  }
  
  @IBAction func logoutTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return snaps.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "snapCell", for: indexPath)
    
    // Configure the cell...
    
    
    let snap = snaps[indexPath.row]
    
    if let snapDict = snap.value as? NSDictionary {
      if let from = snapDict["from"] as? String {
        cell.textLabel?.text = from
      }
    }
    //cell.textLabel?.text = "Selam"
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "snapViewSegue", sender: snaps[indexPath.row])
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    
    if let snapVC = segue.destination as? SnapViewController {
      if let snapData = sender as? FIRDataSnapshot {
        snapVC.snapshot = snapData
      }
    }
  }
  
}
