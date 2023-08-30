//
//  DefaultImagesRepository.swift
//  CatMap
//
//  Created by yun on 2023/08/30.
//

import Foundation

protocol PosterImagesRepository {
    func fetchImage(
        with imagePath: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable?
}
