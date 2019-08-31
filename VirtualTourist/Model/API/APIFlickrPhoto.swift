//
//  APIFlickrPhoto.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 31.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct APIFlickrPhoto: Codable {
    
    let id: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case url = "url_m"
    }
}
