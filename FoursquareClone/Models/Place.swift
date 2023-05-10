//
//  Place.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 9.05.2023.
//

import Foundation
import UIKit

class Place {
    static let sharedInstance = Place()
    
    
    var name = ""
    var comment = ""
    var longitude = Double()
    var latitude = Double()
    var image = UIImage()
    
    private init() {}
}
