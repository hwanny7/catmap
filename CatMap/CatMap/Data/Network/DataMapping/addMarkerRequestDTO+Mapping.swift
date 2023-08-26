//
//  addMarkerRequestDTO+Mapping.swift
//  CatMap
//
//  Created by yun on 2023/08/25.
//

import UIKit

struct addMarkerRequestDTO: MultipartFormDataConvertible {
    let latitude: Double
    let longitude: Double
    let images: [UIImage]
    let description: String
}
