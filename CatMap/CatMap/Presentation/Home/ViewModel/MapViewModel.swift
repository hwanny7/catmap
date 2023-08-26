//
//  MapViewModel.swift
//  CatMap
//
//  Created by yun on 2023/08/08.
//

import Foundation




struct MapViewModelActions {
    let showCreatePost: () -> Void
}


// MARK: - Actions
// Controller를 위한 Interface 및 추상화

protocol MapViewModelInput {
    func didTapFloatingButton()
    func didRefreshButtonTapped()
}

protocol MapViewModelOutput {
    var markers: Observable<[Marker]> { get }
}

typealias MapViewModel = MapViewModelInput & MapViewModelOutput

final class DefaultMapViewModel: MapViewModel {
    private let actions: MapViewModelActions
    private let fetchMarkerUseCase : FetchMarkerUseCase
    
    let markers: Observable<[Marker]> = Observable([])
    
    
    init(
        actions: MapViewModelActions,
        fetchMarkerUseCase: FetchMarkerUseCase
    ) {
        self.actions = actions
        self.fetchMarkerUseCase = fetchMarkerUseCase
    }
    
    private func load() {
        
//        markerLoadTask = fetchMarkerUseCase.execute(requestValue: .init(), completion: <#T##(Result<MapMarkers, Error>) -> Void#>)
        
    }
    
    private func appendMaker() {
        let marker1 = Marker(id: 1, latitude: 36.29534255486295, longitude: 127.5687921843418)
        let marker2 = Marker(id: 1, latitude: 36.29524297601406, longitude: 127.56841295925204)
        markers.value = [marker1, marker2]
        // load 함수가 이 메소드를 실행한다.
        
    }
    
}

// MARK: - Input view event methods

extension DefaultMapViewModel {
    func didTapFloatingButton(){
        actions.showCreatePost()
    }
    
    func didRefreshButtonTapped(){
        appendMaker()
        // 여기서 load 메소드를 실행한다.
    }
}
