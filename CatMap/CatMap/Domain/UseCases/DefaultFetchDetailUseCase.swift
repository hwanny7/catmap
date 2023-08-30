//
//  DefaultFetchDetailUseCase.swift
//  CatMap
//
//  Created by yun on 2023/08/30.
//

import Foundation

protocol FetchDetailUseCase {
    func execute(
        requestValue: FetchDetailUseCaseRequestValue,
        completion: @escaping (Result<Detail, Error>) -> Void
    ) -> Cancellable?
    // Coordinate에 id 값 추가
}



final class DefaultFetchDetailUseCase: FetchDetailUseCase {

    private let detailRepository: DetailRepository
    
    init(detailRepository: DetailRepository) {
        self.detailRepository = detailRepository
    }
    
    func execute(requestValue: FetchDetailUseCaseRequestValue, completion: @escaping (Result<Detail, Error>) -> Void) -> Cancellable? {
        return detailRepository.fetchDetail(id: requestValue.id) { result in
            
        }
    }
    
    
    
}


struct FetchDetailUseCaseRequestValue {
    let id: Int
}
