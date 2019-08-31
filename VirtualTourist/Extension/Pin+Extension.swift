//
//  Pin+Extension.swift
//  VirtualTourist
//
//  Created by Paul Forstner on 31.08.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

extension Pin {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
