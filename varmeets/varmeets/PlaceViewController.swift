//
//  PlaceViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/08/18.
//

import UIKit
import MapKit

class PlaceViewController: UIViewController {
    
    var place: String?
    var lonStr: String?
    var latStr: String?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let placeName = self.place {
            self.navigationItem.title = placeName
            print(placeName)
        }
        
        if let lonStr = self.lonStr, let latStr = self.latStr {
            print(lonStr)
            print(latStr)
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
