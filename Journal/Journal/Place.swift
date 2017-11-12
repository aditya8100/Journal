//
//  Place.swift
//  Journal
//
//  Created by Aditya Deepak on 11/11/17.
//  Copyright © 2017 Aditya Deepak. All rights reserved.
//

import Foundation
import CoreLocation

class Place {
    private var _location: [String: CLLocationDegrees]!
    private var _name: String!
    private var _userDescription: String!
    private var _placesDict: [String: Any]!
    
    var location: [String: CLLocationDegrees] {
        return _location
    }
    
    var name: String {
        return _name
    }
    
    var userDescription: String {
        return _userDescription
    }
    
    var placesDict: [String: Any] {
        return _placesDict
    }
    
    init(placeDict: [String: Any]) {
        if let location = placeDict["location"] as? [String: Double]{
            _location = location
        }
        
        if let name = placeDict["name"] as? String {
            _name = name
        }
        
        if let description = placeDict["description"] as? String {
            _userDescription = description
        }
        
        _placesDict = placeDict
    }
}
