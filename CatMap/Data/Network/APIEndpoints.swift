//
//  APIEndpoints.swift
//  CatMap
//
//  Created by yun on 2023/08/23.
//

import Foundation

struct APIEndpoints {
    
    static func getMarkers(with markersRequestDTO: MarkersRequestDTO) -> Endpoint<MarkersResponseDTO> {

        return Endpoint(
            path: "",
            method: .get,
            queryParametersEncodable: markersRequestDTO
        )
    }
    
    
    static func addMarkers(from addMarkerRequestDTO: MultipartFormDataConvertible) -> Endpoint<addMarkerResponseDTO> {

        return Endpoint(
            path: "",
            method: .post,
            bodyParametersConvertible: addMarkerRequestDTO
        )
    }
    
    static func getImage(path: String) -> Endpoint<Data> {

        return Endpoint(
            path: path,
            isFullPath: true,
            method: .get,
            responseDecoder: RawDataResponseDecoder()
        )
    }
    
    static func getDetail(with detailRequestDTO: DetailRequestDTO) -> Endpoint<DetailResponseDTO> {

        return Endpoint(
            path: "",
            method: .get,
            queryParametersEncodable: detailRequestDTO
        )
    }

    
}
