//
//  Annotations.swift
//  NearMe
//
//  Created by Zahraa Herz on 07/09/2023.
//

import Foundation
import MapKit

class AnnotationPlace: MKPointAnnotation {
    
    let mapItem: MKMapItem
    var id = UUID()
    var isSelected : Bool = false
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
//        self.id = id
//        self.isSelected = isSelected
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
    
//    override init() {
//        var anotations: [AnnotationPlace] = 
//    //        Location(title: "Dio Con Dio",    latitude: 40.590130, longitude: 23.036610,subtitle: "cafe"),
//    //               Location(title: "Paradosiako - Panorama", latitude: 40.590102, longitude: 23.036180,subtitle: "cafe"),
//    //               Locat Location(title: "Dio Con Dio",    latitude: 40.590130, longitude: 23.036610,subtitle: "cafe"),
//    //        Location(title: "Paradosiako - Panorama", latitude: 40.590102, longitude: 23.036180,subtitle: "cafe"),
//    //
//        ]
//    }
    var placeName : String {
        mapItem.name ?? ""
    }
    
    var phone : String {
        mapItem.phoneNumber ?? ""
    }
    
    var address:String {
        "\(mapItem.placemark.subThoroughfare ?? "") \(mapItem.placemark.thoroughfare ?? "") \(mapItem.placemark.locality ?? "" ) \(mapItem.placemark.countryCode ?? "")"
    }
    
    var location: CLLocation {
        mapItem.placemark.location ?? CLLocation.defaultLocation
    }
    
    var placeLocation: CLLocationCoordinate2D{
        
        mapItem.placemark.coordinate
    }
    

    
    
    
    
}
