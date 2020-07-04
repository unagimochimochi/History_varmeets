//
//  PlanCell.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/06/22.
//

import UIKit

class PlanCell: HomeViewController/*, UITableViewCell*/ {
    
    @IBOutlet weak var DateAndTimeLabel: UILabel!
    var receiveDateAndTime: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // receiveDateAndTime = ["0000年00月00日　00時00分"]
        //DateAndTimeLabel.text = DateAndTimes
        /*
        if UserDefaults.standard.object(forKey: "putDateAndTime") != nil {
            saveDateAndTime = UserDefaults.standard.object(forKey: "putDateAndTime") as! [String]
        }
        */
    }
}
