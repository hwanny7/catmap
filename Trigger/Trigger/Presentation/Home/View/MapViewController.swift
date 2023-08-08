//
//  GoogleMapViewController.swift
//  Trigger
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

class MapViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet weak var map: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var viewModel: DefaultMapViewModel!
    
    private var isRegionSet = false
    
    let coordinate = CLLocationCoordinate2D(latitude: 40.728, longitude: -74)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        
        map.delegate = self
        map.showsUserLocation = true
        locationManager.delegate = self
        requestAuthorizationForCurrentLocation()

//        addCustomPin()
//        사용자 위치 확인했을 때 Pin 가져와서 수행하기
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let frameWidth = view.frame.width
        let frameHeight = view.frame.height
        let tabBarHeight = tabBarController!.tabBar.frame.height
        floatingButton.frame = CGRect(x: frameWidth - 80, y: frameHeight - tabBarHeight - 80, width: 60, height: 60)
        // margin 20
    }
    
    
    static func create(
        with viewModel: DefaultMapViewModel
//        posterImagesRepository: PosterImagesRepository?
    ) -> MapViewController {
        let view = MapViewController.instantiateViewController()
        view.viewModel = viewModel
//        view.posterImagesRepository = posterImagesRepository
        return view
    }

    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Bug"
        pin.subtitle = "Go and catch them all"
        map.addAnnotation(pin)
    }
    
    private func setRegion() {
        
    }
    
// MARK: - Tab Floating Button
    
    @objc private func didTapFloatingButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
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

// MARK: - Delegate CLLocationManager

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !isRegionSet, let location = locations.last else { return }

        // Get the user's current location from the locations array
        let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        // Set the region for the map to center on the user's location
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        map.setRegion(region, animated: true)

        isRegionSet = true

        // You can also add a custom annotation (e.g., a marker) for the user's location on the map if needed
        // let annotation = MKPointAnnotation()
        // annotation.coordinate = userLocation
        // mapView.addAnnotation(annotation)
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
            showAlert(title: title, message: message, action: action)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MapViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        // edit image는 크기가 작아지니까 orginal이랑 크기 차이가 얼마나 나는지 확인하기
        viewModel.didTakePicture()
    }
}


