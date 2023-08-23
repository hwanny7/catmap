//
//  Markers.swift
//  CatMap
//
//  Created by yun on 2023/08/23.
//

import Foundation


struct Marker {
    let id: Int
    let latitude: Double
    let longitude: Double
}

struct MapMarkers {
    let markers: [Marker]
}

