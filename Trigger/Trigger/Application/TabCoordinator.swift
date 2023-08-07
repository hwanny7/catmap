//
//  TabCoordinator.swift
//  Trigger
//
//  Created by yun on 2023/08/07.
//

import UIKit


final class TabCoordinator: Coordinator {
    var parentCoordinator: ParentCoordinator?
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    private let appDIContainer: AppDIContainer

    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        
    }
    
    
}
