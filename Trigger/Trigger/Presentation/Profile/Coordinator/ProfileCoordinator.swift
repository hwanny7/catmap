//
//  ProfileCoordinator.swift
//  Trigger
//
//  Created by yun on 2023/08/07.
//

import UIKit


final class ProfileCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    private let profileDIContainer: ProfileDIContainer
    
    
    init(navigationController: UINavigationController, profileDIContainer: ProfileDIContainer) {
        self.navigationController = navigationController
        self.profileDIContainer = profileDIContainer
    }
    
    func start() {
        let profileVC = profileDIContainer.makeMyPageListViewController()
        navigationController.pushViewController(profileVC, animated: false)
    }
}
