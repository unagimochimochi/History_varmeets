//
//  receiveTestViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/06/23.
//

import UIKit

class ReceiveTestViewController: UIViewController {
    
    @IBOutlet weak var displayDateAndTimeLabel: UILabel!
    var receiveData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDateAndTimeLabel.text = receiveData
    }
}
