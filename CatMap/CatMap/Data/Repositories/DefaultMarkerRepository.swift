//
//  DefaultCoordinateRepository.swift
//  CatMap
//
//  Created by yun on 2023/08/22.
//

import Foundation


final class DefaultMarkerRepository {
    
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

extension DefaultMarkerRepository: MarkerRepository {
    
    func addMarker(
        body: AddMarkerUseCaseRequestValue,
        completion: @escaping (Result<DetailId, Error>) -> Void
    ) -> Cancellable? {

        let requestDTO = addMarkerRequestDTO(latitude: body.coordinate.latitude, longitude: body.coordinate.longitude, images: body.images, content: body.content)
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.addMarkers(from: requestDTO)
        
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
    
    
    func fetchMarkerList(
        centerCoordinate: Coordinate, distance: Double, completion: @escaping (Result<MapMarkers, Error>) -> Void
    ) -> Cancellable? {
        
        
        let requestDTO = MarkersRequestDTO(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude, distance: distance)
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.getMarkers(with: requestDTO)
        
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
