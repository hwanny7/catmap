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
    
    private var isActivate: Bool = true
    
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
    
    init(with viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("여기 실행!")
        
        fetchCurrentLocationCoordinate()
        // DidAppear 여러 번 실행되는 거 막아야함 (뒤로 가기로 돌아왔을 때도 갱신되고 있음)
    }
    
    
    private func bind(to viewModel: MapViewModel) {
        viewModel.markers.observe(on: self) { [weak self] in self?.addCustomPin($0) }
    }

    
    override func setupViews() {
        super.setupViews()
        map.delegate = self
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

    private func addCustomPin(_ markers: [Marker]) {
        map.removeAnnotations(map.annotations)
        // 맵에 이미 등록돼 있던 annotation 제거
        
        for marker in markers {
            let coordinate = CLLocationCoordinate2D(latitude: marker.latitude, longitude: marker.longitude)
            let id = marker.id
            let pin = CustomAnnotation(coordinate: coordinate, id: id)
            map.addAnnotation(pin)
            // array로 추가하는 방법도 있음
        }
    }
    
    
    override func setupSearchBarConstraint() {
        super.setupSearchBarConstraint()
        navigationItem.titleView = locationSearchBar
    }
    
    
// MARK: - Tab Floating Button
    
    @objc private func didTapFloatingButton() {
        viewModel.didTapFloatingButton()
    }
    
    @objc private func refreshButtonTapped() {
        fetchCurrentLocationCoordinate()
    }
    
    private func fetchCurrentLocationCoordinate() {
        let latitudeDelta = map.region.span.latitudeDelta
        let centerCoordinate = map.centerCoordinate
        viewModel.didRequestFetchMarker(latitudeDelta: latitudeDelta, centerCoordinate: centerCoordinate)
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        // User의 위치는 변경하면 안 됨
        
        

        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        // tableView처럼 캐시를 사용해서 메모리를 효율적으로 사용한다.

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
            // title 같은 추가 정보를 보여줄건지
//            annotationView?.rightCalloutAccessoryView => 더 자세한 페이지 보여주는 거인 듯
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.image = UIImage(named: "CatMarker1")

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Annotation이 선택되었을 때 호출되는 메서드입니다.
        if let annotation = view.annotation {
            // 선택된 Annotation에 대한 작업을 수행할 수 있습니다.
            // 예를 들어, 선택된 Annotation의 정보를 표시하거나 다른 동작을 수행할 수 있습니다.
            print("Annotation 선택됨: \(annotation.coordinate)")
        }
    }
}

// MARK: - location manager override

extension MapViewController {
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
        
        if viewModel.isFirstLocation {
            fetchCurrentLocationCoordinate()
        }
        viewModel.deactivateFirstLocation()
    }
    
}

class CustomAnnotation: NSObject, MKAnnotation {
    let id: Int
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    
    init(coordinate: CLLocationCoordinate2D, id: Int, title: String? = nil) {
        self.coordinate = coordinate
        self.id = id
        self.title = title
    }
    
}
