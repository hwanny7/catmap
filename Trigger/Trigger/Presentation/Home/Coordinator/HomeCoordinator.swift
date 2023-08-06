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
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    
}
