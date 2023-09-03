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
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
    // Coordinate에 id 값 추가
}



final class DefaultLoginUseCase: LoginUseCase {

    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(requestValue: LoginUseCaseRequestValue, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        return authRepository.login(with: requestValue.identityToken) { result in
            print(result)
            // 여기서 유저 정보를 default에 저장한 다음에 View Model에 성공 여부를 알려준다.
        }
    }
    
    
    
}


struct LoginUseCaseRequestValue {
    let identityToken: Data
}
