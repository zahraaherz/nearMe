//
//  MapController.swift
//  NearMe
//
//  Created by Zahraa Herz on 03/09/2023.
//

import Foundation
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet var map: MKMapView!
    
    @IBOutlet var searchTextField: UITextField!
    
    let locationManager = CLLocationManager()
    private var places: [AnnotationPlace] = []
    
    public var userLocation: CLLocation
//    var region: MKCoordinateRegion
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.userLocation = CLLocation.defaultLocation
//        self.region = MKCoordinateRegion.init()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    required init?(coder: NSCoder) {
        self.userLocation = CLLocation.defaultLocation
//        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 850, longitudinalMeters: 850)

        super.init(coder: coder)
                
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tableVC = TableViewController()
//        tableVC.placeDelegate = self
//
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Get User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        // track user location
        locationManager.startUpdatingLocation()
        
        
        searchTextField.delegate = self
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tableVC = TableViewController()
        tableVC.placeDelegate = self
        let  region =  MKCoordinateRegion(center:  tableVC.selectedPlace.coordinate , latitudinalMeters: 850, longitudinalMeters: 850)
            // self.mapView.zoomToLocation(location: tableVC.selectedPlace.coordinate)
        guard let location = locationManager.location else {return}

        print("Chooosen location \(region)")
        DispatchQueue.main.async {
            self.showRouteOnMap(userCoordinate: self.locationManager.location!.coordinate, destinationCoordinate: tableVC.selectedPlace.coordinate )

//            self.map.setRegion(region, animated: true)
        }
    }
    
    // checkLocationAuthorization
    private func checkLocationAuthorization() {
        guard let location = locationManager.location else {return}
        
        switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse: // center the regin
            ///self.map.zoomToUserLocation()
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 850, longitudinalMeters: 850) // zoom the map
            map.setRegion(region, animated: true)
                 print("user Region\(region)")
            print("AauthorizedAlways")

            case .denied:
                print("Location Service Has Been Denied.")
            case .notDetermined, .restricted:
                print("Location Cannot be determained or restricted.")
            @unknown default:
                print("UnKnown error. Unable To Get Location.")
        }
    }
    
    
    // Find A nearby place and view the annotation on it 
    private func findNearByPlaces(by query: String) {
        
        // clar all the annotation meaning that if we have any annotation in the map we have to clear them        
        map.removeAnnotations(map.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = map.region
         
        let search = MKLocalSearch(request: request)
        search.start {[weak self] response , error in
            guard let response = response, error == nil else {return}
            //pass every place to the Annotationplace which will give us the places we want
            
            self?.places = response.mapItems.map(AnnotationPlace.init)

            self?.places.forEach { place in
                // since the map is in the closure we are using self so it may cupture a refrance so we have to add weak self in the first closer and useing the weak cell "self?"
                self?.map.addAnnotation(place)
            }
            if let places = self?.places{
                self?.presentPlacesData(places: places)
            }
        }
    }
    
    // present the data whent clicking on the location
    private func presentPlacesData(places: [AnnotationPlace]){
        guard let location = locationManager.location else {return}
        
        let sortedPlaces = places.sorted { placeOne, placeTwo in
            location.distance(from: placeOne.location) < location.distance(from: placeTwo.location)
        }
        
        let placeTV = TableViewController(userLocation: location, annotationPlaces: sortedPlaces)
        placeTV.modalPresentationStyle = .pageSheet


        if let sheet = placeTV.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium() , .large()]
            present(placeTV, animated: true)
        }
    }
    
    func showRouteOnMap(userCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile

            let directions = MKDirections(request: request)

            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                //for getting just one route
                if let route = unwrappedResponse.routes.first {
                    //show on map
                    self.map.addOverlay(route.polyline)
                    //set the map area to show the route
                    self.map.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                }
 
                //if you want to show multiple routes then you can get all routes in a loop in the following statement
                //for route in unwrappedResponse.routes {}
            }
        }
        
}

//MARK: - CLLocationManagerDelegate to check the user location

extension MapViewController: CLLocationManagerDelegate {
    
    // must implement it
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let location = locationManager.location else {return}

        userLocation = locations.last ?? CLLocation.defaultLocation
        
       // userLocation = locations.first?.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    // print error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

//MARK: - UITextFieldDelegate for search

extension MapViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let text = textField.text ?? ""
               if !text.isEmpty {
                   textField.resignFirstResponder()
                   // Find NearBy Places
                   findNearByPlaces(by: text)
               }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // print(textField)
    }
    
}

//MARK: - MapKit Delegate

extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
         
        //clear all selection
        self.places = self.places.map{ place in
            place.isSelected = false
            return place
        }
        guard let placeAnotation = annotation as? AnnotationPlace else {return}
        
        let selectedAnnotationId = self.places.first(where: {$0.id == placeAnotation.id})
        selectedAnnotationId?.isSelected = true
        
        presentPlacesData(places: self.places)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let render = MKPolygonRenderer(overlay:  overlay as! MKPolyline)
        render.strokeColor = .blue
        render.lineWidth = 5.0
        return render
    }
    
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        <#code#>
//    }
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let currentRegion = mapView.region
//        self.saveMapPosition(currentRegion)
//    }
}

//MARK: - Protocol Delegate Methods

extension MapViewController:  selectedPlaceAnotationDelegate {
    
    func dropPinAndZoomIn(placemark: AnnotationPlace) {
        let selectedAnnotationId = self.places.first(where: {$0.id == placemark.id})
//
        let annotation = MKPointAnnotation()
        annotation.coordinate = selectedAnnotationId?.coordinate ?? CLLocationCoordinate2D.defaultLocation
        
        let region = MKCoordinateRegion(center: selectedAnnotationId?.coordinate ?? CLLocationCoordinate2D.defaultLocation, latitudinalMeters: 850, longitudinalMeters: 850) // zoom the map
        
//        DispatchQueue.main.async {
//             // Perform your async code here
//            print("____________HIII___________")
//            print(region)
//            self.map.setRegion(region, animated: true)
//        }
//        map.setRegion(region, animated: true)
        //map.setVisibleMapRect(annotation, animated: true)

    }
}

