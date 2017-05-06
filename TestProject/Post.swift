//
//  Post.swift
//  Footy Headlines
//
//  Created by pat t on 4/4/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import Foundation

struct Post {
    let id: String
    let url: String
    let title: String
    let content: String
    let timestamp: Date
    let image: String
    let imageSquare: String
    let commentCount: Int
    let labels: String
    let ageLabel: String
    let zzz: Int
}

extension Post {
    init?(url: String, title: String, image: String, content: String, zzz: Int, commentCount: Int, ageLabel: String) {
        guard let title = title as? String,
        let image = image as? String
            else {
                return nil;
        }
        
        self.id = ""
        self.url = url
        self.title = title
        self.content = content
        self.timestamp = Date()
        self.image = image
        self.imageSquare = image
        self.commentCount = commentCount
        self.labels = ""
        self.ageLabel = ageLabel
        self.zzz = zzz
    }
}

/*
extension Post {
    private let urlComponents: URLComponents
    private let session: URLSession
    
    static func posts(matching page: String, completion: ([Post]) -> Void) {
        var searchURLComponents = urlComponents
        searchURLComponents.path = "/"
        searchURLComponents.queryItems = [URLQueryItem(name: "page", value: page)]
        let URL = searchURLComponents.url!
        
        session.dataTask(url: URL, completion: {(_, _, data, _)
        var posts: [Post] = []
        
        if let data = data,
        let json = try? JSONSerialization.jsonObject(with: data, options []) as? [String: Any] {
        for case let result in json["posts"] {
        if let post = Post (json: result) {
        posts.append(post)
        }
        }
        }
        completion(posts)
        }
        ).resume()
    }
}
*/
