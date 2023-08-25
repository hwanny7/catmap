//
//  DefaultAddMarkerUseCase.swift
//  CatMap
//
//  Created by yun on 2023/08/25.
//

import Foundation

protocol AddMarkerUseCase {
    func execute(
        requestValue: AddMarkerUseCaseRequestValue,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
    // Coordinate에 id 값 추가
}



final class DefaultAddMarkerUseCase: AddMarkerUseCase {

    private let markerRepository: MarkerRepository
    
    init(markerRepository: MarkerRepository) {
        self.markerRepository = markerRepository
    }
    
    func execute(
        requestValue: AddMarkerUseCaseRequestValue,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return 
    }
    
    
    
}


struct AddMarkerUseCaseRequestValue {
    let coordinate: Coordinate
}

// 유저가 보고 있는 지도의 좌표
// 이 좌표를 통해 근처 마커를 계산
// Presenter layer에서 사용하는 Model
// Repository에서 RequestDTO로 변환될 예정
