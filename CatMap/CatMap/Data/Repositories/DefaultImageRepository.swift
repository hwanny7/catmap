//
//  DefaultImagesRepository.swift
//  CatMap
//
//  Created by yun on 2023/08/30.
//

import Foundation

final class DefaultImageRepository {
    
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

extension DefaultImageRepository: ImageRepository {
    
    func fetchImage(
        with imagePath: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable? {
        
        let endpoint = APIEndpoints.getMoviePoster(path: imagePath)
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
}
