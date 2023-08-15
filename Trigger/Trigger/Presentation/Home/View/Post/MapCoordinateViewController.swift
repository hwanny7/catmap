//
//  MapCoordinateViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/15.
//

import UIKit
import MapKit
import CoreLocation

class MapCoordinateViewController: UIViewController, Alertable {
    
    private let locationManager = CLLocationManager()
    
    private var viewModel: DefaultCoordinateViewModel
    private let map = MKMapView()
    let coordinate = CLLocationCoordinate2D(
        latitude: 30.8025,
        longitude: 26.8206
    )

    
    init(with viewModel: DefaultCoordinateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let markerImageView = UIImageView(image: UIImage(named: "marker"))
        markerImageView.translatesAutoresizingMaskIntoConstraints = false
        map.addSubview(markerImageView)
        
        NSLayoutConstraint.activate([
            markerImageView.centerXAnchor.constraint(equalTo: map.centerXAnchor),
            markerImageView.centerYAnchor.constraint(equalTo: map.centerYAnchor)
        ])
    }
}

extension MapCoordinateViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             locationManager.startUpdatingLocation()
         case .restricted, .notDetermined:
             print("GPS 권한 설정되지 않음")
         case .denied:
             print("GPS 권한 요청 거부됨")
         default:
             print("GPS: Default")
         }
     }
    
    private func requestAuthorizationForCurrentLocation() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
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
}
