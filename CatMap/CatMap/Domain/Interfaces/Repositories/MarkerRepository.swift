//
//  MarkerRepository.swift
//  CatMap
//
//  Created by yun on 2023/08/23.
//

import Foundation


protocol MarkerRepository {
    @discardableResult
    func fetchMarkerList(
        centerCoordinate: Coordinate,
        distance: Double,
        completion: @escaping (Result<MapMarkers,Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func addMarker(
        body: AddMarkerUseCaseRequestValue,
        completion: @escaping (Result<Void,Error>) -> Void
    ) -> Cancellable?
}
