//
//  MapViewModel.swift
//  Trigger
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


final class DefaultMapViewModel {
    private let actions: MapViewModelActions
    
    init(
        actions: MapViewModelActions
    ) {
        self.actions = actions
    }
}
extension DefaultMapViewModel: MapViewModelInput {
    func didTapFloatingButton() {
        actions.showCreatePost()
    }
}
