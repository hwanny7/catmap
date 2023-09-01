//
//  AppDIContainer.swift
//  CatMap
//
//  Created by yun on 2023/08/05.
//

import UIKit

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!
            )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    
    
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
