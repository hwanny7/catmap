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
        var vc: UIViewController
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")

        if isLogin {
            vc = profileDIContainer.makeMyPageViewController()
        } else {
            let actions = LoginViewModelActions(showMyPage: showMyPage)
            vc = profileDIContainer.makeLoginViewController(actions: actions)
        }
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showMyPage() {
        let MyPageVC = profileDIContainer.makeMyPageViewController()
        navigationController.setViewControllers([MyPageVC], animated: true)
    }
}
