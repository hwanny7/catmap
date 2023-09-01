//
//  DefaultDetailRepository.swift
//  CatMap
//
//  Created by yun on 2023/08/30.
//

import Foundation


final class DefaultDetailRepository {
    
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

extension DefaultDetailRepository: DetailRepository {
    
    func fetchDetail(
        id: Int, completion: @escaping (Result<Detail, Error>) -> Void
    ) -> Cancellable? {
        

        let requestDTO = DetailRequestDTO(id: id)
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.getDetail(with: requestDTO)
        
        task.networkTask = self.dataTransferService.request(with: endpoint, on: backgroundQueue, completion: { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        return task
    }
    
    
    
}
