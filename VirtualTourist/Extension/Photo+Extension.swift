//
//  Photo+Extension.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 31.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
    
    convenience init(id: String, url: String, pin: Pin, context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: entity, insertInto: context)
            
            self.pin = pin
            self.id = id
            self.image = nil
            self.url = url
        } else {
            fatalError("Entity does not exist.")
        }
    }
}
