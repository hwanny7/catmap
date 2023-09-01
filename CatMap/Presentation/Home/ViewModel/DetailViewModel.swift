//
//  DetailViewModel.swift
//  CatMap
//
//  Created by yun on 2023/08/29.
//

import Foundation



protocol DetailViewModelInput {
    func viewDidLoad()
}

protocol DetailViewModelOutput {
    var images: Observable<[Data?]> { get }
    var content: Observable<String> { get }
}

typealias DetailViewModel = DetailViewModelInput & DetailViewModelOutput

final class DefaultDetailViewModel: DetailViewModel {
    
    private let imageRepository: ImageRepository
    private let fetchDetailUseCase: FetchDetailUseCase
    private let mainQueue: DispatchQueueType
    
    private let id: Int
    private var imagesPath = [String]()

    let content: Observable<String> = Observable("")
    let images: Observable<[Data?]> = Observable([])
    
    init(
        id: Int,
        imageRepository: ImageRepository,
        fetchDetailUseCase: FetchDetailUseCase,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.id = id
        self.imageRepository = imageRepository
        self.fetchDetailUseCase = fetchDetailUseCase
        self.mainQueue = mainQueue
    }
    
    private func load() {
        
        fetchDetailUseCase.execute(requestValue: .init(id: id)) { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success(let detail):
                    self?.content.value = detail.content
                    self?.imagesPath = detail.imagePaths
                case .failure(let error):
                    print(error)
//                    self?.handle(error: error)
                }
            }
            // main큐에 넣지 않아도 될 것 같은데?
        }
        
        
    }
    
}

// MARK: - Input methods

extension DefaultDetailViewModel {
    
}

// MARK: - Ouput methods

extension DefaultDetailViewModel {
    func viewDidLoad() {
        
    }
}
