//
//  PostViewController.swift
//  instagram
//
//  Created by Eli Scherrer on 1/31/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

// TODO
// 1. figure out how to post pictures from the user's photo library
// 2. save the photo in firebase
    // 2a. save the refrence to where the photo was saved
// 3. collect other information and user infromation to fill out the rest of the information that goes along witha post




import UIKit
import Firebase
import FirebaseAuth

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var captionField: UITextField!
    
    var postImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //setup the image to be clicked on
        postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleImagePick(_:)) ))
        postImageView.isUserInteractionEnabled = true
        
    }
    
    //when the image is clicked it shows the imagepickcontroller
    @objc func handleImagePick(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    
        self.present(picker, animated: true, completion: nil)
    }
    
    //set the selected image to the imageview
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] {
            postImage = (editedImage as! UIImage)
        }
        else {
            postImage = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        }
        
        // set the image view to be the image
        postImageView.image = postImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    //post button clicked
    @IBAction func postClicked(_ sender: Any) {
        
//        self.owner = owner
//        self.postedDate = postedDate
//        self.photoUrl = URL(string: photoUrl)
//        self.location = location
//        self.caption = caption
//        self.comments = comments
//        self.likes = likes
        
        //collect information
        let location = locationField.text
        let caption = captionField.text
        let comments = [""]
        let likes = 0
        
        //get the display name from the current firebase user
        let user = Auth.auth().currentUser
        let owner: String?
        if let user = user {
            owner = user.displayName
        }
        
        //convert date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: Date())
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
