//
//  GoogleMapViewController.swift
//  CatMap
//
//  Created by yun on 2023/08/07.
//

import UIKit
import MapKit
import CoreLocation

//func sendBoundingBoxToBackend(topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D) {
//    // Send the bounding box coordinates to the backend
//    // You can make an API request here with the bounding box information
//    print("Top Left Coordinate:", topLeft)
//    print("Bottom Right Coordinate:", bottomRight)
//}
// 백엔드에 바운더리 보내는 방법

final class MapViewController: BaseMapViewController {
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemIndigo
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemIndigo
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        let refreshImage = UIImage(systemName: "arrow.clockwise")
        button.setImage(refreshImage, for: .normal)
        return button
    }()
    
    
    
    private var viewModel: MapViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    

    init(with viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        map.delegate = self

//        addCustomPin()
//        사용자 위치 확인했을 때 Pin 가져와서 수행하기
    }
    
    override func addSubViews() {
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        map.addSubview(floatingButton)
        map.addSubview(refreshButton)
        
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            floatingButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            
            refreshButton.topAnchor.constraint(equalTo: compassButton.bottomAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            refreshButton.widthAnchor.constraint(equalTo: compassButton.widthAnchor),
            refreshButton.heightAnchor.constraint(equalTo: compassButton.heightAnchor),
        ])
    }

//    private func addCustomPin() {
//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinate
//        pin.title = "Bug"
//        pin.subtitle = "Go and catch them all"
//        map.addAnnotation(pin)
//    }
    
    override func setupSearchBarConstraint() {
        super.setupSearchBarConstraint()
        navigationItem.titleView = locationSearchBar
    }
    
    
// MARK: - Tab Floating Button
    
    @objc private func didTapFloatingButton() {
        viewModel.didTapFloatingButton()
    }
    
    @objc private func refreshButtonTapped() {
        print("Tapped")
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        // User의 위치 표시 마커는 변경하지 않는다. 원하면 변경하는 것도 가능할 듯?

        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        // tableView처럼 캐시를 사용해서 메모리를 효율적으로 사용한다.

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
//            annotationView?.rightCalloutAccessoryView => 더 자세한 페이지 보여주는 거인 듯
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(systemName: "house")

        return annotationView
    }
    
    // mapView func은 addCustomPin을 커스텀해서 이쁜 View로 보여준다.
}



