//
//  DefaultLoginUseCase.swift
//  CatMap
//
//  Created by yun on 2023/09/02.
//

import Foundation

protocol LoginUseCase {
    func execute(
        requestValue: LoginUseCaseRequestValue,
        completion: @escaping (Result<UserDetail, Error>) -> Void
    ) -> Cancellable?
    // Coordinate에 id 값 추가
}



final class DefaultLoginUseCase: LoginUseCase {

    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(requestValue: LoginUseCaseRequestValue, completion: @escaping (Result<UserDetail, Error>) -> Void) -> Cancellable? {
        return authRepository.login(with: LoginUseCaseRequestValue.identityToken) { result in
            
        }
    }
    
    
    
}


struct LoginUseCaseRequestValue {
    let identityToken: Data
}
