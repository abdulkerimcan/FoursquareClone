//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 9.05.2023.
//

import UIKit
import MapKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapview: MKMapView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
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
            
            Place.sharedInstance.latitude = annotation.coordinate.latitude
            Place.sharedInstance.longitude = annotation.coordinate.longitude
            
            saveButton.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapview.setRegion(region, animated: true)
        
    }
   
    
    @IBAction func saveClick(_ sender: Any) {
        let storage = Storage.storage()
        let ref = storage.reference()
        
        let mediaFolder = ref.child("media")
        
        if let data = Place.sharedInstance.image.jpegData(compressionQuality: 0.4) {
            let uuid = UUID().uuidString
            
            let imgRef = mediaFolder.child("\(uuid).jpg")
            imgRef.putData(data) { metadata, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error while uploading")
                } else {
                    imgRef.downloadURL { url, error in
                        if error != nil {
                            self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error while uploading")
                        } else {
                            let imgUrl = url?.absoluteString
                            
                            let db = Firestore.firestore()
                            var docRef : DocumentReference?
                            var place = Place.sharedInstance
                            var placeData = ["postedBy" : Auth.auth().currentUser?.email , "name" : place.name,"comment" : place.comment,"imgUrl" : imgUrl,"latitude":place.latitude,"longitude" : place.longitude] as [String : Any]
                            
                            docRef = db.collection("Places").addDocument(data: placeData,completion: { error in
                                if error != nil {
                                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    self.performSegue(withIdentifier: "fromMaptoFeedVC", sender: nil)
                                }
                            })
                        }
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
