//
//  ViewController.swift
//  GoogleMapDemo
//
//  Created by mac on 09/06/21.
//  Copyright © 2021 mac. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var googleMap: GMSMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let camera = GMSCameraPosition(latitude: 25.129690, longitude: 87.000850, zoom: 10.0)
//        googleMap.camera = camera
        
        googleMap.delegate = self
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled()
        {
          locationManager.requestLocation()
          googleMap.isMyLocationEnabled = true
          googleMap.settings.myLocationButton = true
        }
        else {
          locationManager.requestWhenInUseAuthorization()
        }
    }


    func showMarker(position:CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Jagdishpur Baghnagri"
        marker.snippet = "Muzaffarpur, Bihar"
        marker.map = self.googleMap
        marker.isDraggable = true
    }
}


extension ViewController : GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("Click on Marker")
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("Long press Marker")
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let title = UILabel(frame: CGRect.init(x: 0, y: 0, width: view.frame.width - 16, height: 15))
        title.text = "Hi There!"
        view.addSubview(title)
        
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("Dragging Start")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("Did Drag")
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Dragging End")
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
  
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    
    guard status == .authorizedWhenInUse else {
      return
    }
    
    locationManager.requestLocation()
    googleMap.isMyLocationEnabled = true
    googleMap.settings.myLocationButton = true
  }

  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

    
    googleMap.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
    self.showMarker(position: googleMap.camera.target)
  }


  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print(error)
  }
}
