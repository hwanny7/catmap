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
        return authRepository.login(identityToken: requestValue.identityToken, authorizationCode: requestValue.authorizationCode) { result in
            switch result {
            case .success(let user):
                let userDefaults = UserDefaults.standard
                userDefaults.set(user.nickname, forKey: "nickname")
                userDefaults.set(user.accessToken, forKey: "accessToken")
                userDefaults.set(true, forKey: "isLogin")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
}


struct LoginUseCaseRequestValue {
    let identityToken: Data
    let authorizationCode: Data
}
