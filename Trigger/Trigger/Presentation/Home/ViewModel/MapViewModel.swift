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


protocol MapViewModelInput {
    func didTakePicture()
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
    func didTakePicture() {
        actions.showCreatePost()
    }
}
