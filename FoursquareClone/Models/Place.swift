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
    var longitude = ""
    var latitude = ""
    var image = UIImage()
    
    private init() {}
}
