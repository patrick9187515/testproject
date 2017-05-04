//
//  Boot.swift
//  TestProject
//
//  Created by pat t on 5/4/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import Foundation

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
