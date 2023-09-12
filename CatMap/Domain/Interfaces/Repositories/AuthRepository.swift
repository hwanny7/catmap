//
//  AuthRepository.swift
//  CatMap
//
//  Created by yun on 2023/09/02.
//

import Foundation

protocol AuthRepository {
    @discardableResult
    func login(
        identityToken: String,
        authorizationCode: String,
        completion: @escaping (Result<User,Error>) -> Void
    ) -> Cancellable?
}
