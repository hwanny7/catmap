//
//  Coordinator.swift
//  Trigger
//
//  Created by yun on 2023/08/06.
//


import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get set }
//    var childCoordinators: [Coordinator] { get set }
    
    func start()
    
}
