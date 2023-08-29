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
    
    
    static func addMarkers(from addMarkerRequestDTO: MultipartFormDataConvertible) -> Endpoint<addMarkerResponseDTO> {

        return Endpoint(
            path: "",
            method: .post,
            bodyParametersConvertible: addMarkerRequestDTO
        )

    }
    
}
