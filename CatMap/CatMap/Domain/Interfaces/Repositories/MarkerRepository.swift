//
//  MarkerRepository.swift
//  CatMap
//
//  Created by yun on 2023/08/23.
//

import Foundation


protocol MarkerRepository {
    @discardableResult
    func fetchMarkerList(
        query: Coordinate
//        completion: @escaping (Result< ,Error>) -> Void
    ) -> Cancellable?
}
