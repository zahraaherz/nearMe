//
//  PlaceDeatailsViewController.swift
//  NearMe
//
//  Created by Zahraa Herz on 21/09/2023.
//

import UIKit

class PlaceDeatailsViewController: UIViewController {}

//    let place: AnnotationPlace
//    var mapRout: MapViewController = MapViewController()
//    @IBOutlet var placeName: UILabel!
//    @IBOutlet var placeAddress: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.placeName.text = place.placeName
//        self.placeAddress.text = place.address
//    }
//
//    // MARK: - Navigation
//
//    init(place: AnnotationPlace) {
//        self.place = place
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - BUTTON
//
//    @IBAction func directionButton(_ sender: UIButton) {
//        let corrdinate = place.location.coordinate
//        print(place.location.coordinate)
//
//        mapRout.showRouteOnMap(userCoordinate:  corrdinate, destinationCoordinate: corrdinate)
////        guard let url = URL(string: "http://maps.apple.com/?daddr=\(corrdinate.latitude),\(corrdinate.longitude)") else {return}
//
//       // UIApplication.shared.open(url)
//    }
//
//    @IBAction func callButton(_ sender: UIButton) {
//
//        guard let url = URL(string: "tel://\(place.phone.formatPhoneCall)") else {return}
//        UIApplication.shared.open(url)
//    }
//
//
//}
//MARK: - Protocol Delegate Methods
