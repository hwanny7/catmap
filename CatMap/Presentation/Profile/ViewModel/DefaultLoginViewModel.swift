//
//  DefaultLoginViewModel.swift
//  CatMap
//
//  Created by yun on 2023/08/16.
//


import Foundation

struct LoginViewModelActions {
    let showMyPage: () -> Void
}


protocol LoginViewModelInput {
    func didLogIn(identityToken: Data, authorizationCode: Data)
}

protocol LoginViewModelOutput {
    
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput


final class DefaultLoginViewModel: LoginViewModel {
    
    private let loginUseCase: LoginUseCase
    private let actions: LoginViewModelActions
    private var loginTask: Cancellable? { willSet { loginTask?.cancel() } }
    
    init(loginUseCase: LoginUseCase, actions: LoginViewModelActions) {
        self.loginUseCase = loginUseCase
        self.actions = actions
    }
    
    private func didTryLogin(identityToken: Data, authorizationCode: Data){
//        let userDefaults = UserDefaults.standard
//        userDefaults.set("승환", forKey: "nickname")
//        userDefaults.set("0421084210", forKey: "accessToken")
//        userDefaults.set(true, forKey: "isLogin")
//        actions.showMyPage()
        loginTask = loginUseCase.execute(requestValue: .init(identityToken: identityToken)) { result in
            switch result {
            case .success():
                self.actions.showMyPage()
            case .failure(let error):
                print("로그인 중 에러 발생: \(error)")
            }
        }
    }
    
}

// MARK: - Input

extension DefaultLoginViewModel {
    func didLogIn(identityToken: Data, authorizationCode: Data) {
        didTryLogin(identityToken: identityToken, authorizationCode: authorizationCode)
    }
}

