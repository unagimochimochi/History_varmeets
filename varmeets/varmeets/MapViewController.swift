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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var pointAno: MKPointAnnotation = MKPointAnnotation()
    let geocoder = CLGeocoder()
    
    var lon: String = ""
    var lat: String = ""
    
    @IBOutlet var tapGesRec: UITapGestureRecognizer!
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // delegateを登録する
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else {
            return
        }
        locationManager.delegate = self
        
        mapView.delegate = self
        
        // 位置情報取得の許可を得る
        locationManager.requestWhenInUseAuthorization()
        
        initMap()
        
        textField.delegate = self
        
        // キーボード以外をtapした際のアクションをviewに仕込む
        let hideTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKyeoboard))
        self.view.addGestureRecognizer(hideTap)
    }
    
    // タップ検出
    @IBAction func mapViewDiDTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("タップ")
            mapView.removeAnnotation(pointAno)
        }
    }
    
    // ロングタップ検出
    @IBAction func mapViewDidLongPress(_ sender: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if sender.state == .began {
            print("ロングタップ開始")
            // ロングタップ開始時に古いピンを削除する
            mapView.removeAnnotation(pointAno)
        }
        // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            print("ロングタップ終了")
            // タップした位置(CGPoint)を指定してMKMapView上の緯度経度を取得する
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            let lonStr = center.longitude.description
            let latStr = center.latitude.description
            print("lon: " + lonStr)
            print("lat: " + latStr)
            
            // 変数にタップした位置の緯度と経度をセット
            lon = lonStr
            lat = latStr
            
            // 緯度と経度をString型からDouble型に変換
            let lonNum = Double(lonStr)!
            let latNum = Double(latStr)!
            
            let location = CLLocation(latitude: latNum, longitude: lonNum)
            
            // 緯度と経度から住所を取得（逆ジオコーディング）
            geocoder.reverseGeocodeLocation(location, preferredLocale: nil, completionHandler: GeocodeCompHandler(placemarks:error:))
            
            let distance = calcDistance(mapView.userLocation.coordinate, center)
            print("distance: " + distance.description)
            
            // ロングタップを検出した位置にピンを立てる
            pointAno.coordinate = center
            mapView.addAnnotation(pointAno)
            // ピンを最初から選択状態にする
            mapView.selectAnnotation(pointAno, animated: true)
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
    
    // reverseGeocodeLocation(_:preferredLocale:completionHandler:)の第3引数
    func GeocodeCompHandler(placemarks: [CLPlacemark]?, error: Error?) {
        guard let placemark = placemarks?.first, error == nil,
            let administrativeArea = placemark.administrativeArea, //県
            let locality = placemark.locality, // 市区町村
            let throughfare = placemark.thoroughfare, // 丁目を含む地名
            let subThoroughfare = placemark.subThoroughfare // 番地
            else {
                return
        }
        print(administrativeArea + locality + throughfare + subThoroughfare)
        self.pointAno.title = administrativeArea + locality + throughfare + subThoroughfare
    }
    
    // ピンの詳細設定
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 現在地にはピンを立てない
        if annotation is MKUserLocation {
            return nil
        }
        
        let anoView = MKPinAnnotationView(annotation: pointAno, reuseIdentifier: nil)
        
        // 吹き出しを表示
        anoView.canShowCallout = true
        
        // 吹き出し内の予定を追加ボタン
        let addPlanButton = UIButton()
        addPlanButton.frame = CGRect(x: 0, y: 0, width: 85, height: 36)
        addPlanButton.setTitle("予定を追加", for: .normal)
        addPlanButton.setTitleColor(.white, for: .normal)
        addPlanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        addPlanButton.layer.backgroundColor = UIColor.orange.cgColor
        addPlanButton.layer.masksToBounds = true
        addPlanButton.layer.cornerRadius = 8
        
        // 吹き出しの右側にボタンをセット
        anoView.rightCalloutAccessoryView = addPlanButton
        
        return anoView
    }
    
    // 吹き出しアクセサリー押下時
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // 右側のボタンでAddPlanVCに遷移
        if control == view.rightCalloutAccessoryView {
            self.performSegue(withIdentifier: "toAddPlanVC", sender: nil)
        }
    }
    
    // 遷移時に住所と緯度と経度を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "toAddPlanVC" {
            let addPlanVC = segue.destination as! AddPlanViewController
            addPlanVC.address = self.pointAno.title ?? ""
            addPlanVC.lon = self.lon
            addPlanVC.lat = self.lat
        }
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

