
//
//  LoginViewController.swift
//  instagram
//
//  Created by Eli Scherrer on 1/29/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            
            if user != nil {
                print("logged in");
                self.performSegue(withIdentifier: "loginSeque", sender: nil)
                
            }
            
        }
        
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
            // initialize a user object
            let newUser = PFUser()
            
            // set user properties
            newUser.username = usernameField.text
            newUser.password = passwordField.text
        
            
            // call sign up function on the object
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    
                } else {
                    print("User Registered successfully")
                    self.performSegue(withIdentifier: "loginSeque", sender: nil)
                }
            }
        
    }
    
    
    
}
