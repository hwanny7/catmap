//
//  DetailRepository.swift
//  CatMap
//
//  Created by yun on 2023/08/30.
//

import Foundation

protocol DetailRepository {
    @discardableResult
    func fetchDetail(
        id: Int,
        completion: @escaping (Result<Detail,Error>) -> Void
    ) -> Cancellable?
}
