//
//  MarkersResponseDTO+Mapping.swift
//  CatMap
//
//  Created by yun on 2023/08/23.
//

import Foundation

struct MarkersResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case markers
    }
    
    let markers: [MarkerDTO]
}

extension MarkersResponseDTO {
    struct MarkerDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case latitude
            case longitude
        }
        
        let id: Int
        let latitude: Double
        let longitude: Double
    }
}

extension MarkersResponseDTO {
    func toDomain() -> MapMarkers {
        return .init(markers: markers.map { $0.toDomain() } )
    }
}

extension MarkersResponseDTO.MarkerDTO {
    func toDomain() -> Marker {
        return .init(id: id, latitude: latitude, longitude: longitude)
    }
}

