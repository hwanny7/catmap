//
//  MapViewModel.swift
//  CatMap
//
//  Created by yun on 2023/08/08.
//

import Foundation
import CoreLocation



struct MapViewModelActions {
    let showCreatePost: () -> Void
    let showDetail: (Int) -> Void
}


// MARK: - Actions
// Controller를 위한 Interface 및 추상화

protocol MapViewModelInput {
    func didTapFloatingButton()
    func didRequestFetchMarker(latitudeDelta: CLLocationDegrees, centerCoordinate: CLLocationCoordinate2D)
    func deactivateFirstLocation()
}

protocol MapViewModelOutput {
    var markers: Observable<[Marker]> { get }
    var isFirstLocation: Bool { get }
}

typealias MapViewModel = MapViewModelInput & MapViewModelOutput

final class DefaultMapViewModel: MapViewModel {
    private let actions: MapViewModelActions
    private let fetchMarkerUseCase : FetchMarkerUseCase
    private let mainQueue: DispatchQueueType
    private var markerLoadTask: Cancellable? { willSet { markerLoadTask?.cancel() } }
    
    let markers: Observable<[Marker]> = Observable([])
    var isFirstLocation: Bool = true
    
    
    init(
        actions: MapViewModelActions,
        fetchMarkerUseCase: FetchMarkerUseCase,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.actions = actions
        self.fetchMarkerUseCase = fetchMarkerUseCase
        self.mainQueue = mainQueue
    }
    
    private func load(distance: Double, centerCoordinate: Coordinate) {
        print(distance, centerCoordinate)
        appendMarker()
        markerLoadTask = fetchMarkerUseCase.execute(requestValue: .init(distance: distance, centerCoordinate: centerCoordinate), completion: { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success(let markers):
                    self?.appendMarker()
                case .failure(let error):
                    print(error)
//                    self?.handle(error: error)
//                    self?.loading.value = .none
                }
            }

        })
        
    }
    
    private func appendMarker() {
        let marker1 = Marker(id: 1, latitude: 36.29534255486295, longitude: 127.5687921843418)
        let marker2 = Marker(id: 2, latitude: 36.296111378080916, longitude: 127.56914565764805)
        let marker3 = Marker(id: 3, latitude: 36.296323459233655, longitude: 127.56813413430666)
        let marker4 = Marker(id: 4, latitude: 36.29517650673096, longitude: 127.56959807847188)
        let marker5 = Marker(id: 5, latitude: 36.29575955373106, longitude: 127.57064042185205)
        let marker6 = Marker(id: 6, latitude: 36.2953347377883, longitude: 127.56759260817795)
        markers.value = [marker1, marker2, marker3, marker4, marker5, marker6]
        // load 함수가 이 메소드를 실행한다.
        
    }
    
}

// MARK: - Input view event methods

extension DefaultMapViewModel {
    func didTapFloatingButton(){
        actions.showCreatePost()
    }
    
    func didRequestFetchMarker(latitudeDelta: CLLocationDegrees, centerCoordinate: CLLocationCoordinate2D){
        let distance = latitudeDelta * 111
        load(distance: distance, centerCoordinate: .init(coordinate: centerCoordinate))
    }
    
    func deactivateFirstLocation() {
        isFirstLocation = false
    }
    
}
