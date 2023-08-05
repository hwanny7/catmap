//
//  AppDIContainer.swift
//  Trigger
//
//  Created by yun on 2023/08/05.
//

import Foundation

final class AppDIContainer {
    
    apiDataTransferService: DataTransferService = DefaultDataTransferService()
    
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        return HomeSceneDIContainer(apiDataTransferService: apiDataTransferService)
    }
    
    
}
