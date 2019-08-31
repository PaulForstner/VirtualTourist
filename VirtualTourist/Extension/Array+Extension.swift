//
//  Array+Extension.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 26.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

public extension Array {
    
    /// Element at the given index if it exists.
    ///
    /// - Parameter index: index of element.
    /// - Returns: optional element (if exists).
    func item(at index: Int) -> Element? {
        
        if 0..<count ~= index {
            return self[index]
        }
        
        return nil
    }
}
