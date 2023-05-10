//
//  PlaceVC.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 10.05.2023.
//

import UIKit
import MapKit
import Firebase
import FirebaseFirestore
import SDWebImage

class PlaceVC: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var placeimg: UIImageView!
    
    @IBOutlet weak var placeName: UILabel!
    
    @IBOutlet weak var placeComment: UILabel!
    
    @IBOutlet weak var placeLoc: MKMapView!
    
    var docId = ""
    var latitude = Double()
    var longitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        placeLoc.delegate = self
    }
    
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("Places").document(docId).getDocument { snapshot, error in
            if error != nil {
                self.showAlert(title: "error", message: error?.localizedDescription ?? "error")
            } else {
                if let document = snapshot, snapshot!.exists {
                    let dataDescription = document.data().map { map in
                        if let name = map["name"] as? String {
                            self.placeName.text = name
                        }
                        if let comment = map["comment"] as? String {
                            self.placeComment.text = comment
                        }
                        if let lat = map["latitude"] as? Double {
                            self.latitude = lat
                        }
                        if let long = map["longitude"] as? Double {
                            self.longitude = long
                        }
                        
                        if let url = map["imgUrl"] as? String {
                            self.placeimg.sd_setImage(with: URL(string: url))
                        }
                        
                        let location = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.placeLoc.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.placeName.text!
 
                        self.placeLoc.addAnnotation(annotation)
                        
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "pin"
        
        var pinview = placeLoc.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if pinview == nil {
            pinview = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinview?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinview?.rightCalloutAccessoryView = button
        }else {
            pinview?.annotation = annotation
        }
        return pinview
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.latitude != 0.0 && self.longitude != 0.0 {
            let requestLoc = CLLocation(latitude: self.latitude, longitude: self.longitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLoc) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlacemark)
                        mapItem.name =  self.placeName.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
        
        func showAlert(title: String,message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "ok", style: .default,handler: nil)
            alert.addAction(okButton)
            self.present(alert,animated: true,completion: nil)
        }
        
    }

