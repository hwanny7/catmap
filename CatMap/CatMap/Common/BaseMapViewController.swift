//
//  CustomMapViewController.swift
//  CatMap
//
//  Created by yun on 2023/08/15.
//

import UIKit
import MapKit
import CoreLocation

class BaseMapViewController: UIViewController, Alertable {
    let locationManager = CLLocationManager()
    let map = MKMapView()
    private var isFirstLocationUpdate = true
    
    private let compassButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemIndigo
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var locationSearchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        view.addSubview(map)
        locationManager.delegate = self
        
        compassButton.addTarget(self, action: #selector(didTapCurrentLocationButton), for: .touchUpInside)
        map.addSubview(compassButton)
        
        NSLayoutConstraint.activate([
            compassButton.centerYAnchor.constraint(equalTo: map.centerYAnchor),
            compassButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            compassButton.widthAnchor.constraint(equalTo: map.widthAnchor, multiplier: 0.15),
            compassButton.heightAnchor.constraint(equalTo: compassButton.widthAnchor)
        ])
        
        requestAuthorizationForCurrentLocation()
    }
    
    func requestAuthorizationForCurrentLocation() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("첫번째!")
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            goTo(setting: .map)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    @objc private func didTapCurrentLocationButton() {
        requestAuthorizationForCurrentLocation()
    }
    
    private func centerMapOnUser(location: CLLocation) {
        let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        map.setRegion(region, animated: false)
    }
}


extension BaseMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        centerMapOnUser(location: location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             print("사용자가 위치 설정에 동의했습니다.")
             locationManager.startUpdatingLocation()
         case .denied, .restricted:
             print("사용자가 위치 설정에 동의하지 않았습니다.")
         case .notDetermined:
                 print("위치 설정 권한이 아직 결정되지 않았습니다.")
         default:
             print("권한 설정 X")
         }
     }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}


extension BaseMapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
