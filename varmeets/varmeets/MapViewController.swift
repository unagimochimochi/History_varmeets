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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var annotation: MKPointAnnotation = MKPointAnnotation()
    let geocoder = CLGeocoder()
    
    var lat: String = ""
    var lon: String = ""
    
    var searchAnnotationArray = [MKPointAnnotation]()
    
    @IBOutlet var tapGesRec: UITapGestureRecognizer!
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    @IBOutlet weak var placeSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        
        // delegateを登録する
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else {
            return
        }
        locationManager.delegate = self
        
        // 位置情報取得の許可を得る
        locationManager.requestWhenInUseAuthorization()
        
        initMap()

        placeSearchBar.delegate = self
    }
    
    // タップ検出
    @IBAction func mapViewDiDTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("タップ")
            mapView.removeAnnotation(annotation)
        }
    }
    
    // ロングタップ検出
    @IBAction func mapViewDidLongPress(_ sender: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if sender.state == .began {
            print("ロングタップ開始")
            // ロングタップ開始時に古いピンを削除する
            mapView.removeAnnotation(annotation)
            mapView.removeAnnotations(searchAnnotationArray)
        }
        // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            print("ロングタップ終了")
            
            // prepare(for:sender:) で場合分けするため配列を空にする
            searchAnnotationArray.removeAll()
            
            // タップした位置(CGPoint)を指定してMKMapView上の緯度経度を取得する
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            let latStr = center.latitude.description
            let lonStr = center.longitude.description
            
            print("lat: " + latStr)
            print("lon: " + lonStr)
            
            // 変数にタップした位置の緯度と経度をセット
            lat = latStr
            lon = lonStr
            
            // 緯度と経度をString型からDouble型に変換
            let latNum = Double(latStr)!
            let lonNum = Double(lonStr)!
            
            let location = CLLocation(latitude: latNum, longitude: lonNum)
            
            // 緯度と経度から住所を取得（逆ジオコーディング）
            geocoder.reverseGeocodeLocation(location, preferredLocale: nil, completionHandler: GeocodeCompHandler(placemarks:error:))
            
            let distance = calcDistance(mapView.userLocation.coordinate, center)
            print("distance: " + distance.description)
            
            // ロングタップを検出した位置にピンを立てる
            annotation.coordinate = center
            mapView.addAnnotation(annotation)
            // ピンを最初から選択状態にする
            mapView.selectAnnotation(annotation, animated: true)
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
        
        self.annotation.title = administrativeArea + locality + throughfare + subThoroughfare
    }
    
    // ピンの詳細設定
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 現在地にはピンを立てない
        if annotation is MKUserLocation {
            return nil
        }
        
        // 吹き出し内の予定を追加ボタン
        let addPlanButton = UIButton()
        addPlanButton.frame = CGRect(x: 0, y: 0, width: 85, height: 36)
        addPlanButton.setTitle("予定を追加", for: .normal)
        addPlanButton.setTitleColor(.white, for: .normal)
        addPlanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        addPlanButton.layer.backgroundColor = UIColor.orange.cgColor
        addPlanButton.layer.masksToBounds = true
        addPlanButton.layer.cornerRadius = 8
        
        // 配列が空のとき（ロングタップでピンを立てたとき）
        if searchAnnotationArray.isEmpty == true {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            // 吹き出しを表示
            annotationView.canShowCallout = true
            // 吹き出しの右側にボタンをセット
            annotationView.rightCalloutAccessoryView = addPlanButton
            
            return annotationView
        }
        
        // 配列が空ではないとき（検索でピンを立てたとき）
        else {
            let searchAnnotationView = MKPinAnnotationView(annotation: searchAnnotationArray as? MKAnnotation, reuseIdentifier: nil)
            // 吹き出しを表示
            searchAnnotationView.canShowCallout = true
            // 吹き出しの右側にボタンをセット
            searchAnnotationView.rightCalloutAccessoryView = addPlanButton
            
            return searchAnnotationView
        }
    }
    
    // 吹き出しアクセサリー押下時
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // 右側のボタンでAddPlanVCに遷移
        if control == view.rightCalloutAccessoryView {
            self.performSegue(withIdentifier: "toAddPlanVC", sender: nil)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("検索")
        mapView.removeAnnotation(annotation)
        mapView.removeAnnotations(searchAnnotationArray)
        
        // 前回の検索結果の配列を空にする
        searchAnnotationArray.removeAll()
        
        // キーボードをとじる
        self.view.endEditing(true)
        
        // 検索条件を作成
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = placeSearchBar.text
        
        // 検索範囲はMKMapViewと同じ
        request.region = mapView.region
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: LocalSearchCompHandler(response:error:))
    }
    
    // start(completionHandler:)の引数
    func LocalSearchCompHandler(response: MKLocalSearch.Response?, error: Error?) -> Void {
        // 検索がヒットしたとき
        if let response = response {
            for searchLocation in (response.mapItems) {
                if error == nil {
                    let searchAnnotation = MKPointAnnotation()
                    // ピンの座標
                    let center = CLLocationCoordinate2DMake(searchLocation.placemark.coordinate.latitude, searchLocation.placemark.coordinate.longitude)
                    searchAnnotation.coordinate = center
                    
                    // タイトルに場所の名前を表示
                    searchAnnotation.title = searchLocation.placemark.name
                    // ピンを立てる
                    mapView.addAnnotation(searchAnnotation)
                    
                    // searchAnnotation配列にピンをセット
                    searchAnnotationArray.append(searchAnnotation)
                    
                } else {
                    print("error")
                }
            }
        }
        
        // 検索がヒットしなかったとき
        else {
            let dialog = UIAlertController(title: "検索結果なし", message: "ご迷惑をおかけします。\nどうしてもヒットしない場合は住所を入力してみてください！", preferredStyle: .alert)
            // OKボタン
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            // ダイアログを表示
            self.present(dialog, animated: true, completion: nil)
        }
        
        // 0番目のピンを中心に表示
        if searchAnnotationArray.isEmpty == false {
            let searchAnnotation = searchAnnotationArray[0]
            let center = CLLocationCoordinate2D(latitude: searchAnnotation.coordinate.latitude, longitude: searchAnnotation.coordinate.longitude)
            mapView.setCenter(center, animated: true)
            
        } else {
            print("配列が空")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("検索キャンセル")
        
        // テキストを空にする
        placeSearchBar.text = ""
        // キーボードをとじる
        self.view.endEditing(true)
    }
    
    // 遷移時に住所と緯度と経度を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == "toAddPlanVC" {
            let addPlanVC = segue.destination as! AddPlanViewController
            
            // 配列が空のとき（ロングタップでピンを立てたとき）
            if searchAnnotationArray.isEmpty == true {
                addPlanVC.address = self.annotation.title ?? ""
                addPlanVC.lat = self.lat
                addPlanVC.lon = self.lon
            }
            
            // 配列が空ではないとき（検索でピンを立てたとき）
            else {
                // 選択されているピンを新たな配列に格納
                let selectedSearchAnnotationArray = mapView.selectedAnnotations
                
                // 選択されているピンは1つのため、0番目を取り出す
                let selectedSearchAnnotation = selectedSearchAnnotationArray[0]
                
                // ピンの緯度と経度を取得
                let latStr = selectedSearchAnnotation.coordinate.latitude.description
                let lonStr = selectedSearchAnnotation.coordinate.longitude.description
                
                // 選択されているピンからタイトルを取得
                if let selectedSearchAnnotationTitle = selectedSearchAnnotation.title {
                    addPlanVC.address = selectedSearchAnnotationTitle ?? ""
                    addPlanVC.lat = latStr
                    addPlanVC.lon = lonStr
                }
            }
        }
    }
    
}

