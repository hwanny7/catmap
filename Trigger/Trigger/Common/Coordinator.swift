//
//  Coordinator.swift
//  Trigger
//
//  Created by yun on 2023/08/06.
//


import UIKit

// MARK: - Coordinator protocol

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    var navigationController: UINavigationController { get set }
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    
    func finish()
    
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.CoordinatorDidFinish(childCoordinator: self)
    }
}


