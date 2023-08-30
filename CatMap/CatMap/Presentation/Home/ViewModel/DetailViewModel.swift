//
//  DetailViewModel.swift
//  CatMap
//
//  Created by yun on 2023/08/29.
//

import Foundation



protocol DetailViewModelInput {
    
}

protocol DetailViewModelOutput {
    var images: Observable<[Data?]> { get }
    var content: Observable<String> { get }
}

typealias DetailViewModel = DetailViewModelInput & DetailViewModelOutput

final class DefaultDetailViewModel: DetailViewModel {
    
    private let id: Int
    private var imagesPath = [String]()

    let content: Observable<String> = Observable("")
    let images: Observable<[Data?]> = Observable([])
    
    init(
        id: Int
    ) {
        self.id = id
    }
}

// MARK: - Input methods

extension DefaultCoordinateViewModel {
    
}
