//
//  HomeSceneDIContainer.swift
//  Trigger
//
//  Created by yun on 2023/08/05.
//

import UIKit



final class HomeDIContainer {
    
    private let apiDataTransferService: DataTransferService
    
    init(apiDataTransferService: DataTransferService) {
        self.apiDataTransferService = apiDataTransferService
    }
}


// MARK: - Make Coordinator

extension HomeDIContainer {
    func makeHomeCoordinator(navigationController: UINavigationController) -> Coordinator {
        return HomeCoordinator(navigationController: navigationController, homeDIContainer: self)
    }
}

// MARK: - Make Controllers

extension HomeDIContainer {
    func makeGoodgleMapViewController(actions: MapViewModelActions) -> MapViewController {
        return MapViewController(with: DefaultMapViewModel(actions: actions))
    }
    
    func makeCreatePostViewViewController(actions: PostViewModelActions) -> CreatePostViewController {
        return CreatePostViewController(with: DefaultPostViewModel(actions: actions))
    }
    
    func createMapCoordinateViewController(action: @escaping didSelectCoordinateAction) -> MapCoordinateViewController {
        return MapCoordinateViewController(with: DefaultCoordinateViewModel(didSelectCoordinate: action))
    }
    
}
