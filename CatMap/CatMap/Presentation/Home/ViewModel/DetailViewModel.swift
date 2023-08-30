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
    
}

typealias DetailViewModel = DetailViewModelInput & DetailViewModelOutput

final class DefaultDetailViewModel: DetailViewModel {
    
    private let detail: Detail?
    
    
    init(
        detail: Detail?
    ) {
        self.detail = detail
    }
}

// MARK: - Input methods

extension DefaultCoordinateViewModel {
    
}
