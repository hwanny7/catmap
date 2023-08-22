//
//  DefaultCoordinateRepository.swift
//  CatMap
//
//  Created by yun on 2023/08/22.
//

import Foundation


final class DefaultCoordinateRepository {
    
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }

}

