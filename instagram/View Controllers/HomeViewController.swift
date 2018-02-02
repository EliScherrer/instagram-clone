//
//  HomeViewController.swift
//  instagram
//
//  Created by Eli Scherrer on 1/31/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

// TODO
// 1. prompt user to create a username if they have no already and save it into the auth
// 2. get all of the database information from firebase and save it as a dictionary
    // 2a. might have to use a refrence from the database to access the photo which is stored elsewhere
// 3. parse all of the information to create post objects and put in them into the posts array


import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference(withPath: "posts")
    
    var posts: [String] = ["a","b","c","d","e","a","b","c","d","e","a","b","c","d","e"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = .none

        // print out the user info or prompt the user to create a username if they haven't already
        let user = Auth.auth().currentUser
        if let user = user {
            
            if user.displayName == nil {
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Create a username!", message: "enter a username", preferredStyle: .alert)
                
                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.text = ""
                }
                
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                    
                    let newUsername = textField?.text!
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = newUsername
                    changeRequest?.commitChanges { (error) in
                        print(error?.localizedDescription ?? "error in updating the user")
                    }
                }))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                let uid = user.uid
                let email = user.email
                let displayName = user.displayName
                print("uid: \(uid)")
                print("email: \(email!)")
                print("display name: \(displayName!)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signOut()
        try! Auth.auth().signOut()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        //        if posts != nil {
//            return posts.count
//        }
//        else {
//            return 0
//        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        
        return cell
    }
    
    
}
