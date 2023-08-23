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
        completion: @escaping (Result<MapMarkers, Error>) -> Void
    ) -> Cancellable?
    // Coordinate에 id 값 추가
}



final class FetchMarkerCoordinatesUseCase: FetchMarkerUseCase {

    private let markerRepository: MarkerRepository
    
    init(markerRepository: MarkerRepository) {
        self.markerRepository = markerRepository
    }
    
    func execute(requestValue: FetchMarkerUseCaseRequestValue, completion: @escaping (Result<MapMarkers, Error>) -> Void) -> Cancellable? {
        return markerRepository.fetchMarkerList(query: requestValue.coordinate, completion: completion)
    }
    
    
    
}


struct FetchMarkerUseCaseRequestValue {
    let coordinate: Coordinate
}

// 유저가 보고 있는 지도의 좌표
// 이 좌표를 통해 근처 마커를 계산
// Presenter layer에서 사용하는 Model
// Repository에서 RequestDTO로 변환될 예정
