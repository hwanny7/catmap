//
//  DetailResponseDTO+Mapping.swift
//  CatMap
//
//  Created by yun on 2023/08/30.
//

import Foundation

struct DetailResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case content
        case imagePaths
    }
    
    let content: String
    let imagePaths: [String]
}

extension DetailResponseDTO {
    func toDomain() -> Detail {
        return .init(content: content, imagePaths: imagePaths)
    }
}
