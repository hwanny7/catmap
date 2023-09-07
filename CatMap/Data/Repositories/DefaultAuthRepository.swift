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
        identityToken: Data,
        authorizationCode: Data,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> Cancellable? {
        let endpoint = APIEndpoints.login(with: .init(identityToken: identityToken, authorizationCode: authorizationCode))
        let task = RepositoryTask()
        
        task.networkTask = dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
