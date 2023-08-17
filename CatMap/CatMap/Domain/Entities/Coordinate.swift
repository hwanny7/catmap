//
//  Coordinate.swift
//  CatMap
//
//  Created by yun on 2023/08/15.
//

import Foundation
import CoreLocation


struct Coordinate {
    let latitude: Double
    let longitude: Double
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
