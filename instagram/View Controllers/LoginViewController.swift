
//
//  LoginViewController.swift
//  instagram
//
//  Created by Eli Scherrer on 1/29/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {


    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //attach handler that listens for when the user gets logged in
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("handler triggered")
            if let user = user {
                 self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                // No User is signed in. Show user the login screen
            }
        }
        
        //set delegates for google signin
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        
        googleSignInButton.style = .wide
        
        
        //set background gradient
        let grad = CAGradientLayer()
        grad.colors = [
            UIColor.red.cgColor, // top color
            UIColor.blue.cgColor // bottom color
        ]
        grad.locations = [
            0.0, // start gradating at top of view
            1.0  // end gradating at bottom of view
        ]
        grad.frame = view.bounds
        view.layer.insertSublayer(grad, at: 0)
        
        //add borders to the buttons
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.borderWidth = 1
        
        //change display of text fields
        emailField.borderStyle = UITextBorderStyle.roundedRect
        passwordField.borderStyle = UITextBorderStyle.roundedRect
        
        //dismiss the keyboard when you tap somewhere else
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false //so that google sign in button still works
        view.addGestureRecognizer(tap)
        
    }
    
    //normal sign in with email/password
    @IBAction func onSignIn(_ sender: Any) {
        
        //firebase handles email/password signin
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if let user = user {
                print("successfully logged in");
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                print("couldn't log in")
            }
        }
        
    }
    
    //normal sign up with email/password
    @IBAction func onSignUp(_ sender: Any) {

        //firebase handles email/password signup
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if let user = user {
                print("successfully signed up");
                 self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                print("couldn't sign up")
            }

        }
        
    }
    
    //hide the keyboard
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
