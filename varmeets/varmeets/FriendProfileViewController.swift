//
//  FriendProfileViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/06/05.
//

import Foundation
import UIKit

class FriendProfileViewController: UIViewController{
    
    @IBOutlet weak var name: UILabel!
    var receiveData: String = ""
    @IBOutlet var imageView: UIImageView!
    var selectedImg: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = selectedImg
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        name.text = receiveData
        
        self.navigationItem.title = "友だち"
    }
}
