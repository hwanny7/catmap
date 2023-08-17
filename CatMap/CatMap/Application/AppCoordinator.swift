
import UIKit

final class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?

    var childCoordinators = [Coordinator]()
    
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
        let tabCoordinator = appDIContainer.makeTabCoordinator(navigationController: navigationController)
        tabCoordinator.parentCoordinator = self
        childCoordinators.append(tabCoordinator)
        tabCoordinator.start()
    }
}
