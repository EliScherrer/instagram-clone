//
//  HomeViewController.swift
//  instagram
//
//  Created by Eli Scherrer on 1/31/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

// TODOS
// - change the loading method that it actually downloads more instead of showing more when you pull down
// - make it so the user can click on a photo and bring up a details screen
// - add autolayout
// - let the user comment on pics
// - let the user like a picture
// - change the date thing to show time since instead
// - make the keyboard shift up less


import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import AlamofireImage

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var filteredPosts = [Post]()
    var postCount = 5
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        createUserNamePrompt()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchAndStorePosts()
    }

    func fetchAndStorePosts() {
        
        let ref = Database.database().reference(fromURL: "https://instagram-clone-bf6e7.firebaseio.com/")
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let values = snapshot.value as? NSDictionary {

                //clean the array
                self.posts = [Post]()
                //make and store post objects for each item in the JSON
                for (key, value) in values {
                    if let obj = value as? [String: Any] {
                        print(key)
                        print(value)
                        
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
                        self.posts.append(post)
                    }
                }
                print("post count = \(self.posts.count)")
                self.sortPosts()
                self.tableView.reloadData()
            }
            
        }) { (error) in
            print("error: " + error.localizedDescription)
        }
    }
    
    //take all the posts downloaded, sort them, and throw them into filtered posts
    func sortPosts() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        filteredPosts = posts.sorted(by: { $0.postedDate! > $1.postedDate! })
        
        
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signOut()
        try! Auth.auth().signOut()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredPosts.count < postCount {
            return filteredPosts.count
        }
        else {
            return postCount
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = filteredPosts[indexPath.row]
        
        //TODO fix all of these values
        cell.postImage.af_setImage(withURL: post.photoUrl! )
        cell.usernameLabel.text = post.owner
        cell.usernameLabel2.text = post.owner
        cell.locationLabel.text = post.location
        cell.captionLabel.text = post.caption
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: post.postedDate!)
        cell.timestampLabel.text = dateString
        
        
        return cell
    }
    
    //scrolling down implements infinite scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                //don't try to load any more if there aren't anymore
                if (postCount < filteredPosts.count) {
                    //increase the number of posts and refresh
                    postCount += 5
                    self.tableView.reloadData()
                    
                    isMoreDataLoading = false
                }
            }
        }
    }
    
    //pulling up inmplements refresh
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchAndStorePosts()
        refreshControl.endRefreshing()
        return
    }

    //pop up for the user to create a username
    func createUserNamePrompt() {
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
    
    //when the user clicks on a post it takes them to the details page and passes the info
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "detailSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell ) {
                let post = filteredPosts[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.post = post
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
