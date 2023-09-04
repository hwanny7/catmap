//
//  DefaultLoginViewModel.swift
//  CatMap
//
//  Created by yun on 2023/08/16.
//


import Foundation

struct LoginViewModelActions {
    
}


protocol LoginViewModelInput {
    func didLogIn(identityToken: Data)
}

protocol LoginViewModelOutput {
    
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput


final class DefaultLoginViewModel: LoginViewModel {
    
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    private func didTryLogin(identityToken: Data){
        loginUseCase.execute(requestValue: .init(identityToken: identityToken)) { result in
            switch result {
            case .success():
                print("성공 계정 페이지를 보여준다.")
            case .failure(let error):
                print("로그인 중 에러 발생: \(error)")
            }
        }
    }
    
}

// MARK: - Input

extension DefaultLoginViewModel {
    func didLogIn(identityToken: Data) {
        didTryLogin(identityToken: identityToken)
    }
}

