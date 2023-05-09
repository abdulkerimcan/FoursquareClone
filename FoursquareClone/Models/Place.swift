//
//  Place.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 9.05.2023.
//

import Foundation
import UIKit

class Place {
    var name : String?
    var comment : String?
    var image : UIImage?
    
    init(name: String? = nil, comment: String? = nil, image: UIImage? = nil) {
        self.name = name
        self.comment = comment
        self.image = image
    }
}
