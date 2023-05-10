//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 9.05.2023.
//

import UIKit
import MapKit

class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapview: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapview.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapview.addGestureRecognizer(recognizer)
        
    }
    
    @objc func selectLocation(gestureRecognizer : UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touches = gestureRecognizer.location(in: self.mapview)
            let coordinates = self.mapview.convert(touches, toCoordinateFrom: self.mapview)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = Place.sharedInstance.name
            annotation.subtitle = Place.sharedInstance.comment
            
            self.mapview.addAnnotation(annotation)
            
            Place.sharedInstance.latitude = String(annotation.coordinate.latitude)
            Place.sharedInstance.longitude = String(annotation.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapview.setRegion(region, animated: true)
        
    }
   
    
    @IBAction func saveClick(_ sender: Any) {
        performSegue(withIdentifier: "fromMaptoFeedVC", sender: nil)
    }
}
