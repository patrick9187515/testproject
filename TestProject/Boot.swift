//
//  Boot.swift
//  TestProject
//
//  Created by pat t on 5/4/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import Foundation

let dateFormatter = DateFormatter()

struct Boot {
    let brand: String
    let name: String
    let collection: String
    let release_date: Date
    let not_sure: String
    let url: String
    let image: String
}

extension Boot {
    init?(brand: String, name: String, collection: String, releasedate: Date, notsure: String, url: String, image: String) {
        guard let name = name as? String,
            let image = image as? String
            else {
                return nil;
        }
        
        self.brand = brand
        self.name = name
        self.collection = collection
        self.release_date = releasedate
        self.not_sure = notsure
        self.url = url
        self.image = image
    }
}

extension Boot {
    init?(postDict: NSDictionary) {
        
    dateFormatter.dateFormat = "yyyy-MM-dd"
        
    let date = dateFormatter.date(from: postDict.value(forKey: "release_date") as! String)
    
    self.brand = postDict.value(forKey: "brand") as! String
    self.name = postDict.value(forKey: "name") as! String
    self.collection = postDict.value(forKey: "collection") as! String
    self.release_date = date!
    self.not_sure = postDict.value(forKey: "not_sure") as! String
    self.url = postDict.value(forKey: "url") as! String
    self.image = postDict.value(forKey: "image") as! String
    }
}
