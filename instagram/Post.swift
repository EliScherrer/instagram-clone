//
//  Post.swift
//  instagram
//
//  Created by Eli Scherrer on 2/1/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit

class Post: NSObject {
    let owner: String?
    let postedDate: Date?
    let photoUrl: URL?
    let location: String?
    let caption: String?
    let comments: [String]?
    let likes: Int?
    
    init(owner: String, postedDate: Date, photoUrl: String, location: String, caption: String, comments: [String], likes: Int) {
        
        self.owner = owner
        self.postedDate = postedDate
        self.photoUrl = URL(string: photoUrl)
        self.location = location
        self.caption = caption
        self.comments = comments
        self.likes = likes
    }
}
