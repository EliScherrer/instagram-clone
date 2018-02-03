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
    var keyboardRealSize: CGRect?
    
    let storage = Storage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //setup the image to be clicked on
        postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleImagePick(_:)) ))
        postImageView.isUserInteractionEnabled = true
        
        //dismiss the keyboard when you click somewhere else
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        
        //collect information
        let location = locationField.text
        let caption = captionField.text
        let comments = [""]
        let likes = 0
        
        //get the display name from the current firebase user
        let user = Auth.auth().currentUser
        var owner: String = ""
        if let user = user {
            owner = user.uid
        }
        
        //convert date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: Date())
        
        //only proceed if an image has been selected
        if postImage != nil {
            //upload the photo with a unique id
            let imageName = NSUUID().uuidString
            let storageRef = storage.reference().child("\(imageName).png ")
        
            //async uploade the image
            if let uploadData = UIImagePNGRepresentation(postImage!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    //snag the uploaded image's url from metadata
                    let imageURL = metadata?.downloadURL()?.absoluteString
                    
                    let values = ["owner": owner, "location": location!, "caption": caption!, "comments": comments, "likes": likes, "date": date, "imageURL": imageURL!] as [String : Any]
                    
                    //setup database refrences
                    let ref = Database.database().reference(fromURL: "https://instagram-clone-bf6e7.firebaseio.com/")
                    let postRef = ref.child("posts").childByAutoId()
                    postRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err ?? "error?")
                        }
                        else {
                            print("data uploaded successfully")
                            self.postImageView.image = #imageLiteral(resourceName: "image_placeholder")
                            self.captionField.text = ""
                            self.locationField.text = ""
                        }
                    })
                    
                })
            }
        }
    }
    
    
    //hide the keyboard
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //shift the screen up when the keyboard pops up
    @objc func keyboardWillShow(notification: NSNotification) {
        
        //save the size as a constant on it's first appearance
        if keyboardRealSize == nil {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                keyboardRealSize = keyboardSize
                if self.view.frame.origin.y >= 0{
                    self.view.frame.origin.y -= (keyboardRealSize?.height)!
                }
                else {
                    self.view.frame.origin.y += (keyboardRealSize?.height)!
                }
            }
        }
        else {
            if self.view.frame.origin.y >= 0{
                self.view.frame.origin.y -= (keyboardRealSize?.height)!
            }
            else {
                self.view.frame.origin.y += (keyboardRealSize?.height)!
            }
        }
    
        
    }
    //shift the screen down when the keyboard pops up
    @objc func keyboardWillHide(notification: NSNotification) {
        //save the size as a constant on it's first appearance
        if keyboardRealSize == nil {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                keyboardRealSize = keyboardSize

                if self.view.frame.origin.y <= 0{
                    self.view.frame.origin.y += (keyboardRealSize?.height)!
                }
                else {
                    self.view.frame.origin.y -= (keyboardRealSize?.height)!
                }

            }
        }
        else {

            if self.view.frame.origin.y <= 0{
                self.view.frame.origin.y += (keyboardRealSize?.height)!
            }
            else {
                self.view.frame.origin.y -= (keyboardRealSize?.height)!
            }
            
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
