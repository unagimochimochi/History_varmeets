//
//  SearchPlaceViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/08/23.
//

import UIKit
import MapKit

class SearchPlaceViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var placeSearchBar: UISearchBar!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeSearchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("検索")
        
        // キーボードをとじる
        self.view.endEditing(true)
        
        // 検索条件を作成
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = placeSearchBar.text
        
        // 検索範囲
        request.region = MKCoordinateRegion.init()
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: LocalSearchCompHandler(response:error:))
    }
    
    // start(completionHandler:)の引数
    func LocalSearchCompHandler(response: MKLocalSearch.Response?, error: Error?) -> Void {
        // 検索がヒットしたとき
        if let response = response {
            for searchLocation in (response.mapItems) {
                if error == nil {
                    // 検索場所の座標
                    // let center = CLLocationCoordinate2DMake(searchLocation.placemark.coordinate.latitude, searchLocation.placemark.coordinate.longitude)
                    
                    let latStr = searchLocation.placemark.coordinate.latitude.description
                    let lonStr = searchLocation.placemark.coordinate.longitude.description
                    let place = searchLocation.placemark.name
                    
                    if let place = place {
                        print("緯度: \(latStr), 経度: \(lonStr), 名前: \(place)")
                    }
                    
                } else {
                    print("error")
                }
            }
        }
        
        // 検索がヒットしなかったとき
        else {
            print("検索結果なし")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("検索キャンセル")
        
        // テキストを空にする
        placeSearchBar.text = ""
        // キーボードをとじる
        self.view.endEditing(true)
    }
    
}
