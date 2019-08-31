//
//  FlickrEndpointRouter.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 28.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

enum FlickrEndpointRouter: EndpointRouter {
    
    case search(lat: String, long: String, page: Int)
    
    var baseURL: String {
        return Constants.baseURL
    }
    
    var method: HTTPMethodType{
        
        switch self {
        case .search:   return .get
        }
    }
    
    var path: String{
        
        switch self {
        case .search:   return "services/rest"
        }
    }
    
    var parameters: [String : String]? {
        
        switch self {
        case .search(let lat, let long, let page):  return ["api_key": Constants.apiKey,
                                                            "method": "flickr.photos.search",
                                                            "per_page": "25",
                                                            "format": "json",
                                                            "nojsoncallback": "1",
                                                            "extras": "url_m",
                                                            "lat": lat,
                                                            "lon": long,
                                                            "page": "\(page)"]
        }
    }
    
    var httpHeaders: [String : String]? {
        
        switch self {
        case .search:   return nil
        }
    }
    
    var bodyParameters: [String : Any]? {
        
        switch self {
        case .search: return nil
        }
    }
}
