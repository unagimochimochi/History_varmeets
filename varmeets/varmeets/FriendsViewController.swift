//
//  FriendsViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/04/10.
//

import UIKit

class FriendsViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    // @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myFriendsTableView: UITableView!
    
    let myFriends = ["利洋", "優香", "玲奈", "あいうえお1", "あいうえお2"]
    
    // TableView関連 セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( searchController.searchBar.text != "" ) {
            return searchResults.count
        } else {
            return myFriends.count
        }
    }
    
    // TableView関連 セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as UITableViewCell
        if( searchController.searchBar.text != "" ) {
            cell.textLabel?.text = searchResults[indexPath.row]
        } else {
            cell.textLabel?.text = myFriends[indexPath.row]
        }
        // セルに表示する値を設定する
        // cell.textLabel!.text = myFriends[indexPath.row]
        return cell
    }
    
    // 検索関連
    var searchController = UISearchController(searchResultsController: nil)
    
    // 検索結果配列
    var searchResults = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 結果表示用のビューコントローラーに自分を設定する。
        searchController.searchResultsUpdater = self
        
        // 検索中にコンテンツをグレー表示にしない。
        searchController.dimsBackgroundDuringPresentation = false
        
        // テーブルビューのヘッダーにサーチバーを設定する。
        myFriendsTableView.tableHeaderView = searchController.searchBar
        
        /*
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        */
        
        // プレースホルダの指定
        // searchBar.placeholder = "友だちをさがす"
        
        // タイトル文字列の設定
        self.navigationItem.title = "友だち"
    }
    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarSearchButtonClicked(_ searchBar:UISearchBar) {
        print("検索ボタンがタップ")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("キャンセルボタンがタップ")
    }
    */
    
    // 検索文字列変更時の呼び出しメソッド
    func updateSearchResults(for searchController: UISearchController) {
        // 検索文字列を含むデータを検索結果配列に格納する。
        searchResults = myFriends.filter { data in
            return data.contains(searchController.searchBar.text!)
        }
        
        // テーブルビューを再読み込みする。
        myFriendsTableView.reloadData()
    }

}
