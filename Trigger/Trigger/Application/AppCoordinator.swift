
import UIKit

final class AppFlowCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        
    }
    
    
}

// MARK: - Create TabBar

extension AppFlowCoordinator {
    
}

// MARK: - Create DIContainer and Coordinator
