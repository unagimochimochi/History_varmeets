//
//  SearchPlaceViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/08/23.
//

import UIKit
import MapKit

class SearchPlaceViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var placeSearchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    
    var place: String?
    var lat: String?
    var lon: String?
    
    var placeArray = [String]()
    var latArray = [String]()
    var lonArray = [String]()
    
    // AddPlanVCで日時が出力されている場合、一時的に保存
    var dateAndTime: String?
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeSearchBar.delegate = self
        print(dateAndTime ?? "変数〈dateAndTime〉はnilです")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("検索")
        
        // 前回の検索結果の配列を空にする
        placeArray.removeAll()
        lonArray.removeAll()
        latArray.removeAll()
        
        resultsTableView.reloadData()
        
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
                    let place = searchLocation.placemark.name
                    let latStr = searchLocation.placemark.coordinate.latitude.description
                    let lonStr = searchLocation.placemark.coordinate.longitude.description
                    
                    if let place = place {
                        // 配列に検索結果を追加
                        placeArray.append(place)
                        latArray.append(latStr)
                        lonArray.append(lonStr)
                    }
                    
                } else {
                    print("error")
                }
            }
            resultsTableView.reloadData()
        }
        
        // 検索がヒットしなかったとき
        else {
            print("検索結果なし")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("検索キャンセル")
        
        // 前回の検索結果の配列を空にする
        placeArray.removeAll()
        lonArray.removeAll()
        latArray.removeAll()
        
        resultsTableView.reloadData()
        
        // テキストを空にする
        placeSearchBar.text = ""
        // キーボードをとじる
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for:indexPath)
        cell.textLabel?.text = placeArray[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        place = placeArray[(resultsTableView.indexPathForSelectedRow?.row)!]
        lat = latArray[(resultsTableView.indexPathForSelectedRow?.row)!]
        lon = lonArray[(resultsTableView.indexPathForSelectedRow?.row)!]
    }
    
}
