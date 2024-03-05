//
//  ViewController.swift
//  NearMe
//
//  Created by Zahraa Herz on 30/08/2023.
//

import UIKit
import Foundation

import CoreLocation
import MapKit

import UserNotifications

protocol selectedPlaceAnotationDelegate : AnyObject{
    func dropPinAndZoomIn(placemark: AnnotationPlace)

}

class TableViewController: InitTableViewController {

    var userLocation: CLLocation
    var annotationPlaces : [AnnotationPlace]
    var selectedPlace : AnnotationPlace
    var mapView = MapViewController()
    weak var placeDelegate: selectedPlaceAnotationDelegate?
    //    let place: AnnotationPlace
    //    var mapRout: MapViewController = MapViewController()
//    @IBOutlet var tableView: UITableView!
    
    init(userLocation: CLLocation, annotationPlaces: [AnnotationPlace]) {
        self.userLocation = userLocation
        self.annotationPlaces = annotationPlaces
        self.selectedPlace = AnnotationPlace(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D.defaultLocation)))
        self.mapView = MapViewController()
        
     //   super.init(nibName: nil, bundle: nil)
        super.init()
//        register cell
//        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")


        self.annotationPlaces.swapAt(didSelectPlace ?? 00, 0)
    }
    
    override init() {
        self.userLocation = CLLocation.defaultLocation
        self.annotationPlaces = [
            AnnotationPlace(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D.defaultLocation)))]
        self.selectedPlace = AnnotationPlace(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D.defaultLocation)))
        super.init()
    }
    
    //MARK:  functions
    
    private var didSelectPlace: Int? {
        self.annotationPlaces.firstIndex(where: {$0.isSelected == true})
    }
    
    // calclated the distance
     private func calculateTheDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance{
        from.distance(from: to)
    }
    
     private func displayDistance(_ distance: CLLocationDistance) -> String {
        let meters = Measurement(value: distance, unit: UnitLength.meters)
         return meters.converted(to: .kilometers).formatted()
         
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       selectedPlace = annotationPlaces[indexPath.row]
        print(selectedPlace)
       placeDelegate?.dropPinAndZoomIn(placemark: selectedPlace)

       dismiss(animated: true)

   }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       annotationPlaces.count
   }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell

       let place = annotationPlaces[indexPath.row]
        
        cell.placeNameLabel.text = place.placeName
        cell.distanceLabel.text =  displayDistance(calculateTheDistance(from: userLocation, to: place.location))//place.address
        cell.googleButton.addTarget(self, action: #selector(self.googleMapButtonAction), for: .touchUpInside)
        cell.phoneButton.addTarget(self, action: #selector(self.callButtonAction), for: .touchUpInside)
        cell.backgroundColor = place.isSelected ? UIColor.lightGray : UIColor.clear

       
       return cell
   }

    @objc func googleMapButtonAction(_ sender:UIButton!){
        print("----------------------")
        print(selectedPlace.location.coordinate)
        
        let corrdinate = selectedPlace.location.coordinate
        
        mapView.showRouteOnMap(userCoordinate:  corrdinate, destinationCoordinate: corrdinate)
        guard let url = URL(string:"http://maps.apple.com/?daddr=\(corrdinate.latitude),\(corrdinate.longitude)") else {return}
        
        UIApplication.shared.open(url)
        
    }
    
    @objc func callButtonAction(_ sender:UIButton!)
    {
        print(selectedPlace.phone.formatPhoneCall)
        guard let url = URL(string: "tel://\(selectedPlace.phone.formatPhoneCall)") else {return}
        UIApplication.shared.open(url)
    }
}

