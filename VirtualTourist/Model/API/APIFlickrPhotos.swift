//
//  APIFlickrPhotos.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 31.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct APIFlickrPhotos: Codable {
    
    let page: Int
    let pages: Int
    let items: [APIFlickrPhoto]
    
    enum CodingKeys: String, CodingKey {
        
        case page
        case pages
        case items = "photo"
    }
}
