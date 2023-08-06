
import UIKit

final class AppCoordinator: Coordinator {
    
    var parentCoordinator: ParentCoordinator?

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
        print("시작합니다.")
        let TabBarVC = UITabBarController()
        let first = FirstViewController()
        let second = SecondViewController()
        let third = ThirdViewController()
        
        TabBarVC.setViewControllers([first, second, third], animated: false)
        TabBarVC.modalPresentationStyle = .fullScreen
        navigationController.viewControllers = [TabBarVC]
    }
}

class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "fisrt"
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        title = "second"
    }
}

class ThirdViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        title = "third"
    }
}



// MARK: - Create TabBar

extension AppCoordinator {
    
}

// MARK: - Create DIContainer and Coordinator

extension AppCoordinator {
    func makeCoordinators() {
        let homeDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let navigationController = UINavigationController()
        let homeCoordinator = homeDIContainer.makeHomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        self.childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}


// MARK: - Parent Coordinator

extension AppCoordinator: ParentCoordinator {
    func remove(childCoordinator: Coordinator) {
        
    }
}
