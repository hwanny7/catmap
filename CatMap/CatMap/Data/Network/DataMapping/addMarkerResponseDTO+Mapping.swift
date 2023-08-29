//
//  addMarkerResponseDTO+Mapping.swift
//  CatMap
//
//  Created by yun on 2023/08/29.
//

import Foundation


struct addMarkerResponseDTO: Decodable {
    private enum CodingKeys: CodingKey {
        case content
        case images
    }
    
    let content: String
    let images: [String]
    
}

extension addMarkerResponseDTO {
    func toDomain() -> Detail {
        return .init(content: content, images: images)
    }
}
