//
//  FetchMarkerCoordinatesUseCase.swift
//  CatMap
//
//  Created by yun on 2023/08/19.
//

import Foundation

protocol FetchMarkerUseCase {
    
    func execute(
        requestValue: FetchMarkerUseCaseRequestValue,
        completion: @escaping (Result<[Coordinate], Error>) -> Void
    ) -> Cancellable?
    
}



final class FetchMarkerCoordinatesUseCase {
    
    
    
    
}


struct FetchMarkerUseCaseRequestValue {
    let latitude: Double
    let longitude: Double
}
