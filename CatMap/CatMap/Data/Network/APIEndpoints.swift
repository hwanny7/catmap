//
//  APIEndpoints.swift
//  CatMap
//
//  Created by yun on 2023/08/23.
//

import Foundation

struct APIEndpoints {
    
    static func getMarkers(with MarkersRequestDTO: MarkersRequestDTO) -> Endpoint<MarkersResponseDTO> {

        return Endpoint(
            path: "",
            method: .get,
            queryParametersEncodable: MarkersRequestDTO
        )
    }
}
