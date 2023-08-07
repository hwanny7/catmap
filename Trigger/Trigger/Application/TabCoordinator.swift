//
//  TabCoordinator.swift
//  Trigger
//
//  Created by yun on 2023/08/07.
//

import UIKit

enum TabType : CaseIterable {
    case home
    case profile
}


final class TabCoordinator: Coordinator {
    var parentCoordinator: ParentCoordinator?
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var tabBarController = UITabBarController()
    // TabCoordinator 프로토콜을 생성해서 추가해야 하는가?
    
    private let appDIContainer: AppDIContainer

    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        setupTabBarController()
    }
}

// MARK: - Set up Tab bar with dicontainer and coordinator

extension TabCoordinator {
    
    func setupTabBarController() {
        var navControllers = [UIViewController]()
        for tab in TabType.allCases {
            let navigationController = UINavigationController()
            navControllers.append(navigationController)
            makeDIContainerAndCoordinator(for: tab, with: navigationController)
        }
        tabBarController.setViewControllers(navControllers, animated: false)
        navigationController.viewControllers = [tabBarController]
    }
    
    func makeDIContainerAndCoordinator(for tab: TabType, with navigationController: UINavigationController) {
        switch tab {
        case .home:
            let homeDIContainer = appDIContainer.makeHomeDIContainer()
            let homeCoordinator = homeDIContainer.makeHomeCoordinator(navigationController: navigationController)
            homeCoordinator.start()
            // return coordinator and append child
        case .profile:
            let profileDIContainer = appDIContainer.makeProfileDIContainer()
            let profileCoordinator = profileDIContainer.makeProfileCoordinator(navigationController: navigationController)
            profileCoordinator.start()
        }
    }
    
}


// MARK: - Delegate tab bar


// Tab 만큼 Navigation 생성 및 Tab Bar에 삽입
// DI, coordi 생성
// Coordi Start
// TabBar를 AppNavigation에 삽입
