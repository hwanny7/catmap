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
    func makeGoodgleMapViewController(actions: MapViewModelActions) -> UIViewController {
        return MapViewController.create(with: DefaultMapViewModel(actions: actions))
    }
    
    func makeCreatePostViewViewController() -> UIViewController {
        return CreatePostViewController.create(with: DefaultPostViewModel())
    }
}
