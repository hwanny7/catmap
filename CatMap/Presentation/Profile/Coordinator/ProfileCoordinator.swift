//
//  ProfileCoordinator.swift
//  CatMap
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
        let actions = LoginViewModelActions(showMyPage: showMyPage)
        let LoginVC = profileDIContainer.makeLoginViewController(actions: actions)
        navigationController.pushViewController(LoginVC, animated: false)
    }
    
    func showMyPage() {
        let MyPageVC = profileDIContainer.makeMyPageViewController()
        navigationController.setViewControllers([MyPageVC], animated: true)
    }
}
