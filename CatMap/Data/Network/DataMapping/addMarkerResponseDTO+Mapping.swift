//
//  addMarkerResponseDTO+Mapping.swift
//  CatMap
//
//  Created by yun on 2023/08/29.
//

import Foundation


struct addMarkerResponseDTO: Decodable {
    private enum CodingKeys: CodingKey {
        case id
    }
    
    let id: Int
}

extension addMarkerResponseDTO {
    func toDomain() -> DetailId {
        return .init(id: id)
    }
}
