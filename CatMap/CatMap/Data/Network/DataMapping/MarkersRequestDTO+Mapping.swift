//
//  MarkerRequestDTO+Mapping.swift
//  CatMap
//
//  Created by yun on 2023/08/23.
//

import Foundation


struct MarkersRequestDTO: Encodable {
    let latitude: Double
    let longitude: Double
    let distance: Double
}
