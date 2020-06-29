//
//  MapViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/02/26.
//  https://developer.apple.com/documentation/corelocation/
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupLocationManager()
        
        textField.delegate = self
        
        // キーボード以外をtapした際のアクションをviewに仕込む
        let hideTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKyeoboard))
        self.view.addGestureRecognizer(hideTap)
        
        // locationManager = CLLocationManager()  // 変数を初期化
        // guard let locationManager = locationManager else { return }
        // locationManager.delegate = self  // delegateとしてself(自インスタンス)を設定
        
        // locationManager.startUpdatingLocation()  // 位置情報更新を指示
        // locationManager.requestWhenInUseAuthorization()  // 位置情報取得の許可を得る
        
        mapView.showsUserLocation = true // 位置を地図に表示
        
        self.navigationItem.title = "地図" // タイトル文字列の設定
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func hideKyeoboard(recognizer : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // 位置情報更新時に呼び出される処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let longitude = (locations.last?.coordinate.longitude.description)!
        let latitude = (locations.last?.coordinate.latitude.description)!
        print("[DBG]longitude : " + longitude)
        print("[DBG]latitude : " + latitude)
                
        mapView.setCenter((locations.last?.coordinate)!, animated: true) // 現在地を中心に表示
        
        if let coordinate = locations.last?.coordinate {
            // 現在地を拡大して表示する
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.region = region
        }
 
    }
    /// キーボードの検索ボタン押下時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        self.view.endEditing(true)
        // 現在表示中のピンをすべて消す
        self.mapView.removeAnnotations(mapView.annotations)
        
        guard let address = textField.text else {
            return false
        }
        
        CLGeocoder().geocodeAddressString(address) { [weak mapView] placemarks, error in
            guard let loc = placemarks?.first?.location?.coordinate else {
                return
            }
            
            // 地図の中心を設定
            mapView?.setCenter(loc ,animated:true)
            // 縮尺を設定
            let region = MKCoordinateRegion(center: loc,
                                            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            
            Map.search(query: "駅", region: region) { (result) in // queryに"駅"と入れると検索地周辺の駅を検索
                switch result {
                case .success(let mapItems):
                    for map in mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = map.placemark.coordinate
                        annotation.title = map.name ?? "名前がありません"
                        mapView?.addAnnotation(annotation)
                    }
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc
            annotation.title = "検索地"
            mapView?.addAnnotation(annotation)
            
            mapView?.setRegion(region,animated:true)
        }
        
        self.textField.text = ""
        
        return true
    }

}

