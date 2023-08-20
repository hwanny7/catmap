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
    // Coordinate에 id 값 추가
}



final class FetchMarkerCoordinatesUseCase: FetchMarkerUseCase {
    
//    func excute(
//        requestValue: FetchMarkerUseCaseRequestValue,
//        completion: @escaping (Result<[Coordinate], Error>) -> Void
//    ) -> Cancellable? {
//
//        return
//
//    }
    
}


struct FetchMarkerUseCaseRequestValue {
    let latitude: Double
    let longitude: Double
}
