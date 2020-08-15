//
//  MapViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/02/26.
//  https://developer.apple.com/documentation/corelocation/
//  https://qiita.com/yuta-sasaki/items/3151b3faf2303fe78312
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var pointAno: MKPointAnnotation = MKPointAnnotation()
    
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    // UILongPressGestureRecognizerのdelegate：ロングタップを検出する
    @IBAction func mapViewDidLongPress(_ sender: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if sender.state == .began {
            // ロングタップ開始時に古いピンを削除する
            mapView.removeAnnotation(pointAno)
        }
        // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            // タップした位置(CGPoint)を指定してMKMapView上の緯度経度を取得する
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            let lonStr = center.longitude.description
            let latStr = center.latitude.description
            print("lon: " + lonStr)
            print("lat: " + latStr)
            
            let distance = calcDistance(mapView.userLocation.coordinate, center)
            print("distance: " + distance.description)
            
            // ピンに表示する文字列を生成する
            var str: String = Int(distance).description
            str = str + " m"
            
            if pointAno.title != str {
                // ピンまでの距離に変化があればtitleを更新する
                pointAno.title = str
                mapView.addAnnotation(pointAno)
            }
            
            // ロングタップを検出した位置にピンを立てる
            pointAno.coordinate = center
            mapView.addAnnotation(pointAno)
        }
    }
    
    // 地図の初期化関数
    func initMap() {
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)
        
        mapView.showsUserLocation = true // 現在位置表示の有効化
        mapView.userTrackingMode = .follow // 現在位置のみ更新する
    }
    
    // 地図の中心位置の更新関数
    func updateCurrentPos(_ coordinate: CLLocationCoordinate2D) {
        var region: MKCoordinateRegion = mapView.region
        region.center = coordinate
        mapView.setRegion(region,animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // delegateを登録する
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else {
            return
        }
        locationManager.delegate = self
        
        // 位置情報取得の許可を得る
        locationManager.requestWhenInUseAuthorization()
        
        initMap()
        
        textField.delegate = self
        
        // キーボード以外をtapした際のアクションをviewに仕込む
        let hideTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKyeoboard))
        self.view.addGestureRecognizer(hideTap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func hideKyeoboard(recognizer : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // 2点間の距離(m)を算出する
    func calcDistance(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> CLLocationDistance {
        let aLoc: CLLocation = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let bLoc: CLLocation = CLLocation(latitude: b.latitude, longitude: b.longitude)
        let dist = bLoc.distance(from: aLoc)
        return dist
    }
    
    // 位置情報更新時に地図の中心位置の変更関数を呼び出す
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        let distance = calcDistance(mapView.userLocation.coordinate, pointAno.coordinate)
        if (0 != distance) {
            // ピンに設定する文字列を生成する
            var str: String = Int(distance).description
            str = str + " m"
            
            if pointAno.title != str {
                // ピンまでの距離に変化があればtitleを更新する
                pointAno.title = str
                mapView.addAnnotation(pointAno)
            }
        }
        
        switch mapView.userTrackingMode {
        case .followWithHeading:
            mapView.userTrackingMode = .followWithHeading
            break
        case .follow:
            mapView.userTrackingMode = .follow
            break
        default:
            break
        }
        // locations.last!.speed で秒速を取得
        // 秒速を少数第2位の時速に変換
        let speed: Double = floor((locations.last!.speed * 3.6)*100)/100
        print(speed)
        /*
         self.avgSumSpeed += locations.last!.speed
         self.avgSumCount += 1
         let tmpAvgSpeed = floor(((self.avgSumSpeed / Double(self.avgSumCount)) * 3.6)*100)/100
         */
    }
    
    // キーボードの検索ボタン押下時
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
            mapView?.setCenter(loc, animated: true)
            // 縮尺を設定
            let region = MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            
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

