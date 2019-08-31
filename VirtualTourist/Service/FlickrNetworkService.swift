//
//  FlickrNetworkService.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 28.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class FlickrNetworkService: NSObject {
    
    class func search(lat: String, long: String, page: Int, completion: @escaping (APIFlickrPhotos?, Error?) -> Void) {
        
        let router = FlickrEndpointRouter.search(lat: lat, long: long, page: page)
        _ = NetworkService.request(router: router, responseType: APIFlickrResult.self) { (result, error) in
            
            if let photos = result?.photos {
                completion(photos, nil)
            } else {
                completion(nil, error)
            }
        }
    }

}
