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
        MapViewController(with: makeMapViewController(actions: actions))
    }
    
    func makeCreatePostViewViewController(actions: PostViewModelActions) -> CreatePostViewController {
        CreatePostViewController(with: makeCreatePostViewController(actions: actions))
    }
    
    func createMapCoordinateViewController(action: @escaping didSelectCoordinateAction) -> MapCoordinateViewController {
        MapCoordinateViewController(with: makeMapCoordinateViewController(action: action))
    }
    
}

// MARK: - Make ViewModel

extension HomeDIContainer {
    func makeMapViewController(actions: MapViewModelActions) -> MapViewModel {
        DefaultMapViewModel(actions: actions)
    }
    
    func makeCreatePostViewController(actions: PostViewModelActions) -> PostViewModel {
        DefaultPostViewModel(actions: actions)
    }
    
    func makeMapCoordinateViewController(action: @escaping didSelectCoordinateAction) -> CoordinateViewModel {
        DefaultCoordinateViewModel(didSelectCoordinate: action)
    }

    
}
