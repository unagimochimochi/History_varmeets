//
//  HomeViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/02/26.
//

import UIKit

class HomeViewController: UIViewController, /*UISearchBarDelegate,*/ UITableViewDelegate, UITableViewDataSource {
    
    // @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var PlanTable: UITableView!
    var DateAndTimes = [String]()
    
    @IBAction func unwindtoHomeVC(sender: UIStoryboardSegue) {
        guard let sourceVC = sender.source as? AddPlanViewController, let DateAndTime = sourceVC.DateAndTime else {
            return
        }
        if let selectedIndexPath = self.PlanTable.indexPathForSelectedRow {
            self.DateAndTimes[selectedIndexPath.row] = DateAndTime
        } else {
            self.DateAndTimes.append(DateAndTime)
        }
        self.PlanTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DateAndTimes = ["0000年00月00日　00時00分"]
        
        /*
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        //プレースホルダの指定
        searchBar.placeholder = "友だち・場所を入力"
        
        //検索スコープを指定するボタン
        //searchBar.scopeButtonTitles  = ["果物", "野菜"]
        //searchBar.showsScopeBar = true
        */
        // タイトル文字列の設定
        self.navigationItem.title = "ホーム"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath)
        
        let DateAndTimeLabel = cell.viewWithTag(1) as! UILabel
        DateAndTimeLabel.text = self.DateAndTimes[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DateAndTimes.count
    }
    /*
    func searchBarSearchButtonClicked(_ searchBar:UISearchBar) {
        print("検索ボタンがタップ")
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("キャンセルボタンがタップ")
    }
    */
}

