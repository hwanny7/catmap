//
//  CoordinateViewModel.swift
//  Trigger
//
//  Created by yun on 2023/08/15.
//

import Foundation
import CoreLocation

typealias didSelectCoordinateAction = (Coordinate) -> Void

protocol CoordinateViewModelInput {
    func didSelect(coordinate: CLLocationCoordinate2D)
}

protocol CoordinateViewModelOutput {
    
}

typealias CoordinateViewModel = CoordinateViewModelInput & CoordinateViewModelOutput

final class DefaultCoordinateViewModel {
//    private let actions: MapViewModelActions
    
    private let didSelectCoordinate: didSelectCoordinateAction
    
    init(
//        actions: MapViewModelActions
        didSelectCoordinate: @escaping didSelectCoordinateAction
    ) {
//        self.actions = actions
        self.didSelectCoordinate = didSelectCoordinate
    }
}

extension DefaultCoordinateViewModel: CoordinateViewModel {
    func didSelect(coordinate: CLLocationCoordinate2D) {
        let coordinate = Coordinate(coordinate: coordinate)
        didSelectCoordinate(coordinate)
    }
}
