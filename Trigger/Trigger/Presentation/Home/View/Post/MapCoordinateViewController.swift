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
        view.backgroundColor = .white
        
        
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.text = "어디서 만난 고양이인가요? \n이웃들과 공유해주세요. 🐈‍⬛"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        ])
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        view.addSubview(map)
        locationManager.delegate = self
        
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
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
        
        let squareButton = UIButton(type: .system)
        squareButton.translatesAutoresizingMaskIntoConstraints = false
        squareButton.setTitle("선택 완료", for: .normal)
        squareButton.backgroundColor = .blue
        squareButton.layer.cornerRadius = 10.0
        squareButton.tintColor = .white
        map.addSubview(squareButton)
        squareButton.addTarget(self, action: #selector(getCenterCoordinate), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            squareButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            squareButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            squareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            squareButton.heightAnchor.constraint(equalTo: map.heightAnchor, multiplier: 1/14)
        ])
        

        requestAuthorizationForCurrentLocation()
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
    
    @objc private func getCenterCoordinate() {
        let centerCoordinate = map.centerCoordinate
        viewModel.didSelect(coordinate: centerCoordinate)
    }
    
    private func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension MapCoordinateViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Get the user's current location from the locations array
        let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        // Set the region for the map to center on the user's location
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        map.setRegion(region, animated: false)
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error requesting location: \(error.localizedDescription)")
    }
    

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
    
    // MARK: - Custom function
}




