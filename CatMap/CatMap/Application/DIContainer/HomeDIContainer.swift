//
//  HomeSceneDIContainer.swift
//  CatMap
//
//  Created by yun on 2023/08/05.
//

import UIKit



final class HomeDIContainer {
    
    private let apiDataTransferService: DataTransferService
    
    init(apiDataTransferService: DataTransferService) {
        self.apiDataTransferService = apiDataTransferService
    }
}


// MARK: - Make Coordinator

extension HomeDIContainer {
    func makeHomeCoordinator(navigationController: UINavigationController) -> Coordinator {
        return HomeCoordinator(navigationController: navigationController, homeDIContainer: self)
    }
}

// MARK: - Make Controllers

extension HomeDIContainer {
    func makeMapViewController(actions: MapViewModelActions) -> MapViewController {
        MapViewController(with: makeMapViewModel(actions: actions))
    }
    
    func makeCreatePostViewController(actions: PostViewModelActions) -> CreatePostViewController {
        CreatePostViewController(with: makePostViewModel(actions: actions))
    }
    
    func createMapCoordinateViewController(action: @escaping didSelectCoordinateAction) -> MapCoordinateViewController {
        MapCoordinateViewController(with: makeMapCoordinateViewModel(action: action))
    }
    
    func makeDetailViewController(id: Int) -> DetailViewController {
        DetailViewController(with: makeDetailViewModel(id: id))
    }
    
}

// MARK: - Make ViewModel

extension HomeDIContainer {
    func makeMapViewModel(actions: MapViewModelActions) -> MapViewModel {
        DefaultMapViewModel(actions: actions, fetchMarkerUseCase: makeFetchMarkerUseCase())
    }
    
    func makePostViewModel(actions: PostViewModelActions) -> PostViewModel {
        DefaultPostViewModel(actions: actions, addMarkerUseCase: makeAddMarkerUseCase())
    }
    
    func makeMapCoordinateViewModel(action: @escaping didSelectCoordinateAction) -> CoordinateViewModel {
        DefaultCoordinateViewModel(didSelectCoordinate: action)
    }
    
    func makeDetailViewModel(id: Int) -> DetailViewModel {
        DefaultDetailViewModel(id: id, imageRepository: makeImageRepository(), fetchDetailUseCase: makeFetchDetailUseCase())
    }
}

// MARK: - Make UseCase

extension HomeDIContainer {
    func makeFetchMarkerUseCase() -> FetchMarkerUseCase {
        DefaultFetchMarkerUseCase(markerRepository: makeMarkerRepository())
    }
    
    func makeAddMarkerUseCase() -> AddMarkerUseCase {
        DefaultAddMarkerUseCase(markerRepository: makeMarkerRepository())
    }
    
    func makeFetchDetailUseCase() -> FetchDetailUseCase {
        DefaultFetchDetailUseCase(detailRepository: makeDetailRepository())
    }
}


// MARK: - Make Repository

extension HomeDIContainer {
    func makeMarkerRepository() -> MarkerRepository {
        DefaultMarkerRepository(dataTransferService: apiDataTransferService)
    }
    
    func makeImageRepository() -> ImageRepository {
        DefaultImageRepository(dataTransferService: apiDataTransferService)
    }
    
    func makeDetailRepository() -> DetailRepository {
        DefaultDetailRepository(dataTransferService: apiDataTransferService)
    }
    
}
