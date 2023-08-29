//
//  HomeCoordinator.swift
//  CatMap
//
//  Created by yun on 2023/08/06.
//

import UIKit

// controller 만드는 함수 Protocol 생성, HomeDIContainer가 그걸 준수하도록 만든다.


final class HomeCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    private lazy var animationFromBottomToTop: CATransition = {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .moveIn
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return transition
    }()
    
    private let homeDIContainer: HomeDIContainer
    
    
    init(navigationController: UINavigationController, homeDIContainer: HomeDIContainer) {
        self.navigationController = navigationController
        self.homeDIContainer = homeDIContainer
    }
    
    func start() {
        setupNavigationBar()
        let actions = MapViewModelActions(showCreatePost: showCreatePost)
        let mapVC = homeDIContainer.makeMapViewController(actions: actions)
        navigationController.pushViewController(mapVC, animated: false)
    }
    
    private func setupNavigationBar() {
        let backButtonImage = UIImage(systemName: "xmark")
        navigationController.navigationBar.backIndicatorImage = backButtonImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationController.navigationBar.tintColor = .systemIndigo
    }
    
    private func showCreatePost() {
        let actions = PostViewModelActions(showMap: showMap, dismissMap: dismissMap, showDetail: showDetail)
        let postVC = homeDIContainer.makeCreatePostViewController(actions: actions)
//        navigationController.view.layer.add(animationFromBottomToTop, forKey: nil)
        postVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(postVC, animated: true)
    }
    
    private func showMap(didSelect: @escaping (Coordinate) -> Void) {
        let mapVC = homeDIContainer.createMapCoordinateViewController(action: didSelect)
//        navigationController.view.layer.add(animationFromBottomToTop, forKey: nil)
        navigationController.pushViewController(mapVC, animated: true)
    }
    
    private func showDetail(_ detail: Detail) {
        let detailVC = homeDIContainer.makeDetailViewController()
        navigationController.popToRootViewController(animated: false)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    private func dismissMap() {
        navigationController.popViewController(animated: true)
    }
}


//if let tabCoordinator = parentCoordinator as? TabNavigationControllable {
//    tabCoordinator.changeTab(to: 1)
//}
