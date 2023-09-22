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
    private let mainQueue: DispatchQueueType
    private var loginTask: Cancellable? { willSet { loginTask?.cancel() } }
    
    init(loginUseCase: LoginUseCase, actions: LoginViewModelActions, mainQueue: DispatchQueueType = DispatchQueue.main) {
        self.loginUseCase = loginUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    private func didTryLogin(identityToken: Data, authorizationCode: Data){
        guard let identityToken = String(data: identityToken, encoding: .utf8), let authorizationCode = String(data: authorizationCode, encoding: .utf8) else { return }

        loginTask = loginUseCase.execute(requestValue: .init(identityToken: identityToken, authorizationCode: authorizationCode)) { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success():
                    self?.actions.showMyPage()
                case .failure(let error):
                    print("Login Error: \(error)")
                }
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

