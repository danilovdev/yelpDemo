//
//  MapViewController.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 28.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import GoogleMaps
import ChameleonFramework

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var isCurrentLocationDefined = false
    
    var currentUserLocation: CLLocation!
    
    var selectedRestaurant: Restaurant!
    
    var markersDict = Dictionary<String, GMSMarker>()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var segmentedContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
        
        self.segmentedContainer.backgroundColor = UIColor(hexString: "64a9c3")!
        
        self.mapView.delegate = self
        self.mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !self.isCurrentLocationDefined {
            self.currentUserLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
            self.mapView.camera = GMSCameraPosition.camera(withTarget: self.currentUserLocation.coordinate, zoom: 15.0)
            self.mapView.settings.myLocationButton = true
            self.isCurrentLocationDefined = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRestaurantDetail" {
            if let dest = segue.destination as? RestaurantDetailViewController {
                dest.restaurant = self.selectedRestaurant
            }
        }
    }
    
    func setuplocationMarker(restaurant: Restaurant) -> GMSMarker {
        let locationMarker = GMSMarker(position: restaurant.coordinate)
        
        locationMarker.appearAnimation = .pop
        locationMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
        locationMarker.opacity = 0.75
        
        let userData = ["restaurant": restaurant]
        locationMarker.userData = userData
        locationMarker.map = self.mapView
        return locationMarker
    }
    
    @IBAction func mapTypeChanged(_ sender: Any) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .normal
            break
        case 1:
            self.mapView.mapType = .terrain
            break
        case 2:
            self.mapView.mapType = .hybrid
            break
        default:
            break
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.loadData()
    }
    

}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.mapView.isMyLocationEnabled = true
        }
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let allViewsInXibArray = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil) {
            let customInfoWindow = allViewsInXibArray.first as! CustomInfoWindow
            if let userData = marker.userData as? Dictionary<String, Any> {
                let restaurant = userData["restaurant"] as! Restaurant
                customInfoWindow.restaurant = restaurant
                self.selectedRestaurant = restaurant 
            }
            return customInfoWindow
        }
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.performSegue(withIdentifier: "ShowRestaurantDetail", sender: self)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.loadData()
        
    }
    
    func loadData() {
        let lat = self.mapView.camera.target.latitude
        
        let lng = self.mapView.camera.target.longitude
        
        DataService.sharedInstance.loadRestaurantsForLatLong(latitude: Double(lat), longitude: Double(lng), successCallback: { array in
            
            var newRestaurantsDict = Dictionary<String, Restaurant>()
            for item in array {
                let restaurant = Restaurant.fromJSON(json: item)
                newRestaurantsDict[restaurant.id] = restaurant
            }
            let newIds = Set(newRestaurantsDict.map { $0.key })
            let oldIds = Set(self.markersDict.map { $0.key })
            
            let toDelete = oldIds.subtracting(newIds)
            let toAdd = newIds.subtracting(oldIds)
            
            for id in toDelete {
                self.markersDict[id]?.map = nil
                self.markersDict[id] = nil
            }
            
            for id in toAdd {
                self.markersDict[id] = self.setuplocationMarker(restaurant: newRestaurantsDict[id]!)
            }
            
        }, errorHandler: { errorMessage in
            self.showAlert(title: "Error", message: errorMessage)
        })

    }
    
    
}


