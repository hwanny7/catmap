//
//  CustomMapViewController.swift
//  Trigger
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        view.addSubview(map)
        locationManager.delegate = self
        map.delegate = self
        
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
            centerMapOnUser()
            // 이 부분 필요 없을 듯
        case .denied, .restricted:
            let title = "Location Access Denied"
            let message = "To use this app, please enable location access in Settings."
            let action = UIAlertAction(title: "설정", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            showAlert(actions: [action], title: title, message: message)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
    
    @objc private func didTapCurrentLocationButton() {
        requestAuthorizationForCurrentLocation()
    }
    
    private func centerMapOnUser() {
        guard let location = map.userLocation.location else { return }
        let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        map.setRegion(region, animated: false)
    }
}

extension BaseMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if isFirstLocationUpdate {
            centerMapOnUser()
            isFirstLocationUpdate = false
        }
    }
}

extension BaseMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             print("권한 설정 완료요@")
             centerMapOnUser()
         default:
             print("권한 설정 X")
         }
     }
}
