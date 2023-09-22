//
//  ProfileDIContainer.swift
//  CatMap
//
//  Created by yun on 2023/08/07.
//

import UIKit



final class ProfileDIContainer {
    
    private let apiDataTransferService: DataTransferService
    
    init(apiDataTransferService: DataTransferService) {
        self.apiDataTransferService = apiDataTransferService
    }
}


// MARK: - Make Coordinator

extension ProfileDIContainer {
    func makeProfileCoordinator(navigationController: UINavigationController) -> Coordinator {
        return ProfileCoordinator(navigationController: navigationController, profileDIContainer: self)
    }
}

// MARK: - Make Controllers

extension ProfileDIContainer {
    func makeMyPageViewController() -> MyPageViewController {
        return MyPageViewController(with: makeMyPageViewModel())
    }
    
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        return LoginViewController(with: makeLoginViewModel(actions: actions))
    }
}

// MARK: - Make ViewModel

extension ProfileDIContainer {
    
    func makeMyPageViewModel() -> MyPageViewModel {
        DefaultMyPageViewModel()
    }
    
    func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        DefaultLoginViewModel(loginUseCase: makeLoginUseCase(), actions: actions)
    }
    
}

// MARK: - Make usecase

extension ProfileDIContainer {
    
    func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(authRepository: makeAuthRepository())
    }
    
}

// MARK: - Make repository

extension ProfileDIContainer {
    
    func makeAuthRepository() -> AuthRepository {
        DefaultAuthRepository(dataTransferService: apiDataTransferService)
    }
    
}
