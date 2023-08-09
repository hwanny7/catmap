//
//  Coordinator.swift
//  Trigger
//
//  Created by yun on 2023/08/06.
//


import UIKit

// MARK: - Coordinator protocol

protocol Coordinator: AnyObject {
    var parentCoordinator: ParentCoordinator? { get set }
    
    var childCoordinators: [Coordinator] { get set }
    
    var navigationController: UINavigationController { get set }
    
    func start()
    
    func finish()
    
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        parentCoordinator?.remove(childCoordinator: self)
    }
}

protocol ParentCoordinator: AnyObject {
    func remove(childCoordinator: Coordinator)
}

extension ParentCoordinator {
    func remove(childCoordinator: Coordinator) {
        print(childCoordinator)
    }
}




