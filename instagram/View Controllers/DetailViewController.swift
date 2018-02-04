//
//  DetailViewController.swift
//  instagram
//
//  Created by Eli Scherrer on 2/4/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    var post: Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let post = post {
            usernameLabel.text = post.owner
            captionLabel.text = post.caption
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: (post.postedDate!))
            timestampLabel.text = dateString
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
