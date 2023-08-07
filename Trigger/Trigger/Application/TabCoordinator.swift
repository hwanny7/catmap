//
//  TabCoordinator.swift
//  Trigger
//
//  Created by yun on 2023/08/07.
//

import UIKit

enum Tab : CaseIterable {
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
        navigationController.pushViewController(FirstViewController(), animated: <#T##Bool#>)
    }
}

class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "fisrt"
    }
}

// Tab 만큼 Navigation 생성 및 Tab Bar에 삽입
// DI, coordi 생성
// Coordi Start
// TabBar를 AppNavigation에 삽입
