//
//  HomeCoordinator.swift
//  Trigger
//
//  Created by yun on 2023/08/06.
//

import UIKit


final class HomeCoordinator: Coordinator {
    
    var parentCoordinator: ParentCoordinator?
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    private let homeDIContainer: HomeDIContainer
    
    
    init(navigationController: UINavigationController, homeDIContainer: HomeDIContainer) {
        self.navigationController = navigationController
        self.homeDIContainer = homeDIContainer
    }
    
    func start() {
        let mapVC = homeDIContainer.makeGoodgleMapViewController()
        navigationController.pushViewController(mapVC, animated: false)
    }
}
