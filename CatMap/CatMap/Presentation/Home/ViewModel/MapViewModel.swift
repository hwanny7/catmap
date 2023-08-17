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
}

protocol MapViewModelOutput {
    
}

typealias MapViewModel = MapViewModelInput & MapViewModelOutput

final class DefaultMapViewModel: MapViewModel {
    private let actions: MapViewModelActions
    
    init(
        actions: MapViewModelActions
    ) {
        self.actions = actions
    }
}

// MARK: - Input view event methods

extension DefaultMapViewModel {
    func didTapFloatingButton() {
        actions.showCreatePost()
    }
}
