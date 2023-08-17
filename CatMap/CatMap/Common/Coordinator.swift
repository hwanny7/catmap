//
//  Coordinator.swift
//  CatMap
//
//  Created by yun on 2023/08/06.
//


import UIKit

// MARK: - Coordinator protocol

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    
    var childCoordinators: [Coordinator] { get set }
    
    var navigationController: UINavigationController { get set }
    
    func start()
    
    func finish()
    
    func remove(childCoordinator: Coordinator)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        parentCoordinator?.remove(childCoordinator: self)
    }
    
    func remove(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
    
}



