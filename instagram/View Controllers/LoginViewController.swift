
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
        GIDSignIn.sharedInstance().signIn()
        
        googleSignInButton.style = .wide
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
}
