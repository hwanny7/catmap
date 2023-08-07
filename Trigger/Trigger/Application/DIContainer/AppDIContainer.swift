//
//  AppDIContainer.swift
//  Trigger
//
//  Created by yun on 2023/08/05.
//

import UIKit

final class AppDIContainer {
    
    private let apiDataTransferService: DataTransferService = DefaultDataTransferService()
    
    
    // MARK: - Make Coordinator
    
    func makeTabCoordinator(navigationController: UINavigationController) -> TabCoordinator {
        return TabCoordinator(navigationController: navigationController, appDIContainer: self)
    }
    
    // MARK: - Make DIContainer
    
    func makeHomeDIContainer() -> HomeDIContainer {
        return HomeDIContainer(apiDataTransferService: apiDataTransferService)
    }
    
    func makeProfileDIContainer() -> ProfileDIContainer {
        return ProfileDIContainer(apiDataTransferService: apiDataTransferService)
    }
    
}


// home, friends, user DI Container, Coordinator 생성

// 각 Tab을 위한 Navigation Controller 생성
// DI Container를 생성, Di Container가 Coordinator 생성
// Coordinator에 Nav Controller 전달
// Coordinator.start()
