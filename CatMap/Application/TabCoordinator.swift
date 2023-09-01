//
//  TabCoordinator.swift
//  CatMap
//
//  Created by yun on 2023/08/07.
//

import UIKit


protocol TabNavigationControllable {
    func changeTab(to index: Int)
}


enum TabType : String,CaseIterable {
    case home = "Home"
    case profile = "Profile"
}


final class TabCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
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
    
    func toggleRootNavigationBar(hidden: Bool) {
        navigationController.setNavigationBarHidden(hidden, animated: true)
    }
}

// MARK: - Set up Tab bar with dicontainer and coordinator

extension TabCoordinator {
    
    func setupTabBarController() {
        var navControllers = [UIViewController]()
        for tab in TabType.allCases {
            let navigationController = UINavigationController()
            navControllers.append(navigationController)
            setTabBarItem(for: tab, with: navigationController)
            makeDIContainerAndCoordinator(for: tab, with: navigationController)
        }
        
        tabBarController.setViewControllers(navControllers, animated: false)
        navigationController.viewControllers = [tabBarController]
        
        toggleRootNavigationBar(hidden: true)
        // 하위 navigation bar랑 이중으로 나오는 거 방지
        
        // MARK: - style setting
        
        tabBarController.tabBar.backgroundColor = .white
        
    }
    
    func setTabBarItem(for tab: TabType, with navigationController: UINavigationController) {
        switch tab {
        case .home:
            navigationController.tabBarItem = UITabBarItem(title: tab.rawValue, image: UIImage(systemName: "house"), tag: 0)
        case .profile:
            navigationController.tabBarItem = UITabBarItem(title: tab.rawValue, image: UIImage(systemName: "person"), tag: 1)
        }
    }
    
    
    func makeDIContainerAndCoordinator(for tab: TabType, with navigationController: UINavigationController) {
        switch tab {
        case .home:
            let homeDIContainer = appDIContainer.makeHomeDIContainer()
            let homeCoordinator = homeDIContainer.makeHomeCoordinator(navigationController: navigationController)
            homeCoordinator.parentCoordinator = self
            homeCoordinator.start()
            childCoordinators.append(homeCoordinator)
            
        case .profile:
            let profileDIContainer = appDIContainer.makeProfileDIContainer()
            let profileCoordinator = profileDIContainer.makeProfileCoordinator(navigationController: navigationController)
            profileCoordinator.parentCoordinator = self
            profileCoordinator.start()
            childCoordinators.append(profileCoordinator)
        }
    }
}

extension TabCoordinator: TabNavigationControllable{
    func changeTab(to index: Int) {
        tabBarController.selectedIndex = index
    }
}


// MARK: - Delegate tab bar


// Tab 만큼 Navigation 생성 및 Tab Bar에 삽입
// DI, coordi 생성
// Coordi Start
// TabBar를 AppNavigation에 삽입
