//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 9.05.2023.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapview: MKMapView!
    
    var place : Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func saveClick(_ sender: Any) {
        performSegue(withIdentifier: "toFeedVC", sender: nil)
    }
}
