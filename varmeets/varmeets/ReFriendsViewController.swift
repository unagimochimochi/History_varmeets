//
//  ReFriendsViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/06/06.
//
// Label受け渡し参考 https://qiita.com/azuma317/items/6b800bfca423e8fe2cf6

import UIKit

class ReFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    var selectedImage: UIImage?
    // 遷移先のViewControllerに渡す変数
    var giveName: String = ""
    
    // section毎の画像配列
    let imgArray: NSArray = ["Toshihiro","Yuka"]
    
    let label1Array: NSArray = ["利洋","優香"]
    let label2Array: NSArray = ["@toshihiro_sanada","@yuyuyuyuyukakka"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "友だち"        
    }
    
    // Table Viewのセルの数を指定
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    // 各セルの要素を設定する
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = table.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        let img = UIImage(named: imgArray[indexPath.row] as! String)
        
        // Tag番号 1 で UIImageView インスタンスの生成
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = img
        
        // Tag番号 ２ で UILabel インスタンスの生成
        let label1 = cell.viewWithTag(2) as! UILabel
        label1.text = String(describing: label1Array[indexPath.row])
        
        // Tag番号 ３ で UILabel インスタンスの生成
        let label2 = cell.viewWithTag(3) as! UILabel
        label2.text = String(describing: label2Array[indexPath.row])
        
        return cell
    }
    
    // Cell の高さを60にする
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // Cell が選択された場合
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true) // セルの選択を解除
        // [indexPath.row] から画像名を探し、UImage を設定
        selectedImage = UIImage(named: imgArray[indexPath.row] as! String)
        if selectedImage != nil {
            performSegue(withIdentifier: "toFriendProfileViewController", sender: nil)
        }
        giveName = label1Array[indexPath.item] as! String
        
    }
    
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toFriendProfileViewController") {
            let fpVC: FriendProfileViewController = (segue.destination as? FriendProfileViewController)!
            // SubViewController のselectedImgに選択された画像を設定する
            fpVC.selectedImg = selectedImage
            fpVC.receiveData = giveName
        }
    }
}
