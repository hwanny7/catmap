//
//  HomeCoordinator.swift
//  Trigger
//
//  Created by yun on 2023/08/06.
//

import UIKit

// controller 만드는 함수 Protocol 생성, HomeDIContainer가 그걸 준수하도록 만든다.


final class HomeCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    private let homeDIContainer: HomeDIContainer
    
    
    init(navigationController: UINavigationController, homeDIContainer: HomeDIContainer) {
        self.navigationController = navigationController
        self.homeDIContainer = homeDIContainer
    }
    
    func start() {
        let actions = MapViewModelActions(showCreatePost: showCreatePost)
        let mapVC = homeDIContainer.makeGoodgleMapViewController(actions: actions)
        navigationController.pushViewController(mapVC, animated: false)
    }
    
    private func showCreatePost() {
        let postVC = homeDIContainer.makeCreatePostViewViewController()
        postVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(postVC, animated: true)
        if let tabCoordinator = parentCoordinator as? TabNavigationControllable {
            tabCoordinator.changeTab(to: 1)
        }
    }
    
}
