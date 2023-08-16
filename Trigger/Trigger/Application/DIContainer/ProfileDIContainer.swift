//
//  ProfileDIContainer.swift
//  Trigger
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
    func makeMyPageListViewController() -> UIViewController {
        return MyPageViewController(with: DefaultMyPageViewModel())
    }
}
