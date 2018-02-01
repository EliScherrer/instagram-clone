//
//  HomeViewController.swift
//  instagram
//
//  Created by Eli Scherrer on 1/31/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var window: UIWindow?
    var posts: [String] = ["a","b","c","d","e","a","b","c","d","e","a","b","c","d","e"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // print out the user info
        //in your apps, you can get the user's basic profile information from the FIRUser object. See Manage Users.
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
