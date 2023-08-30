//
//  addMarkerResponseDTO+Mapping.swift
//  CatMap
//
//  Created by yun on 2023/08/29.
//

import Foundation


struct addMarkerResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case content
        case imagePaths = "images"
    }
    
    let id: Int
    let content: String
    let imagePaths: [String]
    
}

extension addMarkerResponseDTO {
    func toDomain() -> Detail {
        return .init(id: id, content: content, imagePaths: imagePaths)
    }
}
