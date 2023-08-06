
import UIKit

final class AppCoordinator: Coordinator {
    
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

extension AppCoordinator {
    
}

// MARK: - Create DIContainer and Coordinator
