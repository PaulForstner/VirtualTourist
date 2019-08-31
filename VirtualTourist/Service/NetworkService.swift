//
//  NetworkService.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 26.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class NetworkService: NSObject {
    
    class func request<T: Decodable, U: EndpointRouter>(router: U, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) -> URLSessionDataTask? {
        
        guard let urlRequest = router.urlRequest else {
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(T.self, from: data) as? Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
        return task
    }
    
    class func downloadImage(from url: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask? {
 
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        
        task.resume()
        return task
    }
}
