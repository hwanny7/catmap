//
//  DefaultAuthRepository.swift
//  CatMap
//
//  Created by yun on 2023/09/02.
//

import Foundation

final class DefaultAuthRepository {
    
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

extension DefaultAuthRepository: AuthRepository {
    
    func login(
        with identityToken: Data,
        completion: @escaping (Result<UserDetail, Error>) -> Void
    ) -> Cancellable? {
        
        let endpoint = APIEndpoints.getImage(path: imagePath)
        let task = RepositoryTask()
        
        task.networkTask = dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { (result: Result<Data, DataTransferError>) in

            let result = result.mapError { $0 as Error }
            completion(result)
        }
        return task
    }
