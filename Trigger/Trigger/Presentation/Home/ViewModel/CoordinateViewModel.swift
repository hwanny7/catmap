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

final class DefaultCoordinateViewModel: CoordinateViewModel {

    private let didSelectCoordinate: didSelectCoordinateAction
    
    init(
        didSelectCoordinate: @escaping didSelectCoordinateAction
    ) {
        self.didSelectCoordinate = didSelectCoordinate
    }
}

// MARK: - Input methods

extension DefaultCoordinateViewModel {
    func didSelect(coordinate: CLLocationCoordinate2D) {
        let coordinate = Coordinate(coordinate: coordinate)
        didSelectCoordinate(coordinate)
    }
}
