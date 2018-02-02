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
    
    var posts: [Post]?
    
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
        
        //get the data and create Post objects
        fetchAndStorePosts()
        
    }

    func fetchAndStorePosts() {
//        let ref = Database.database().reference(fromURL: "https://instagram-clone-bf6e7.firebaseio.com/")
//        let postRef = ref.child("posts").childByAutoId()
        
        let ref = Database.database().reference(fromURL: "https://instagram-clone-bf6e7.firebaseio.com/")
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let values = snapshot.value as? NSDictionary {

                for (key, value) in values {
                    print(key)
                    print(value)
                    if let obj = value as? [String: Any] {
                        
                        let owner = obj["owner"] as! String
                        let dateString = obj["date"] as! String
                        let photoUrl = obj["imageURL"] as! String
                        let location = obj["location"] as! String
                        let caption = obj["caption"] as! String
                        let comments = ["comments"] 
                        let likes = obj["likes"] as! Int
                        
                        //convert the date string to a date object
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = dateFormatter.date(from: dateString)
                        
                        
                        
                        let post = Post(owner: owner, postedDate: date!, photoUrl: photoUrl, location: location, caption: caption, comments: comments, likes: likes)
                        self.posts?.append(post)
                    }
                }
            }
            
        }) { (error) in
            print("error: " + error.localizedDescription)
        }
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signOut()
        try! Auth.auth().signOut()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts != nil {
            return posts!.count
        }
        else {
            return 0
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts![indexPath.row]
        
        
        
        
        return cell
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
