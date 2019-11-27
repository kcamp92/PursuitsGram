//
//  Posts.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/25/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Post {
    let title: String
    let body: String
    let id: String
    let creatorID: String
    let dateCreated: Date?
    let imagePhoto: String?
    
    init(title: String, body: String, creatorID: String, dateCreated: Date?, imagePhoto: String? = nil) {
        self.title = title
        self.body = body
        self.creatorID = creatorID
        self.id = UUID().description
        self.dateCreated = dateCreated
        self.imagePhoto = imagePhoto
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let title = dict["title"] as? String,
            let body = dict["body"] as? String,
            let userID = dict["creatorID"] as? String,
            let imagePhoto = dict["imagePhoto"] as? String,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
        
        self.title = title
        self.body = body
        self.creatorID = userID
        self.id = id
        self.dateCreated = dateCreated
        self.imagePhoto = imagePhoto
    }
    
    var fieldsDict: [String: Any] {
        return [
            "title": self.title,
            "body": self.body,
            "creatorID": self.creatorID,
            "imagePhoto":self.imagePhoto
        ]
    }
}
