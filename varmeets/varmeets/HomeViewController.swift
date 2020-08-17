//
//  HomeViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/02/26.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var planTable: UITableView!
    var dateAndTimes = [String]()
    var planTitles = [String]()
    // var participantImgs = [UIImage]()
    var participantNames = [String]()
    var places = [String]()
    var lons = [String]()
    var lats = [String]()
    
    @IBAction func unwindtoHomeVC(sender: UIStoryboardSegue) {
        // 日時
        guard let sourceVC1 = sender.source as? AddPlanViewController, let dateAndTime = sourceVC1.DateAndTime else {
            return
        }
        if let selectedIndexPath = self.planTable.indexPathForSelectedRow {
            self.dateAndTimes[selectedIndexPath.row] = dateAndTime
        } else {
            self.dateAndTimes.append(dateAndTime)
        }
        self.userDefaults.set(self.dateAndTimes, forKey: "DateAndTimes")
        
        // 予定タイトル
        guard let sourceVC2 = sender.source as? AddPlanViewController, let planTitle = sourceVC2.PlanTitle else {
            return
        }
        if let selectedIndexPath = self.planTable.indexPathForSelectedRow {
            self.planTitles[selectedIndexPath.row] = planTitle
        } else {
            self.planTitles.append(planTitle)
        }
        self.userDefaults.set(self.planTitles, forKey: "PlanTitles")
        
        // 場所
        guard let sourceVC4 = sender.source as? AddPlanViewController, let place = sourceVC4.address else {
            return
        }
        let lon = sourceVC4.lon
        let lat = sourceVC4.lat
        if let selectedIndexPath = self.planTable.indexPathForSelectedRow {
            self.places[selectedIndexPath.row] = place
            self.lons[selectedIndexPath.row] = lon
            self.lats[selectedIndexPath.row] = lat
        } else {
            self.places.append(place)
            self.lons.append(lon)
            self.lats.append(lat)
        }
        self.userDefaults.set(self.places, forKey: "Places")
        self.userDefaults.set(self.lons, forKey: "lons")
        self.userDefaults.set(self.lats, forKey: "lats")
        
        self.planTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.userDefaults.object(forKey: "DateAndTimes") != nil {
            self.dateAndTimes = self.userDefaults.stringArray(forKey: "DateAndTimes")!
        } else {
            self.dateAndTimes = ["日時"]
        }
        
        if self.userDefaults.object(forKey: "PlanTitles") != nil {
            self.planTitles = self.userDefaults.stringArray(forKey: "PlanTitles")!
        } else {
            self.planTitles = ["予定サンプル"]
        }
        
        if self.userDefaults.object(forKey: "Places") != nil {
            self.places = self.userDefaults.stringArray(forKey: "Places")!
        } else {
            self.places = ["場所"]
        }
        
        if self.userDefaults.object(forKey: "lons") != nil {
            self.lons = self.userDefaults.stringArray(forKey: "lons")!
            self.lats = self.userDefaults.stringArray(forKey: "lats")!
        } else {
            self.lons = ["経度"]
            self.lats = ["緯度"]
        }
        
        // self.participantImgs = ["FriendsNoimg"]
        self.participantNames = ["参加者"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // print(#function)

        if let indexPath = planTable.indexPathForSelectedRow {
            planTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath)
        // let img = UIImage(named: participantImgs[indexPath.row] as! String)
        
        let DateAndTimeLabel = cell.viewWithTag(1) as! UILabel
        DateAndTimeLabel.text = self.dateAndTimes[indexPath.row]
        
        let PlanTitleLabel = cell.viewWithTag(2) as! UILabel
        PlanTitleLabel.text = self.planTitles[indexPath.row]
        /*
         // let participantImageView = cell.viewWithTag(3) as! UIImageView
         // participantImageView.image = img
         
         let participantLabel = cell.viewWithTag(4) as! UILabel
         participantLabel.text = self.participantNames[indexPath.row]
         */
        let placeLabel = cell.viewWithTag(5) as! UILabel
        placeLabel.text = self.places[indexPath.row]
        print("経度: \(self.lons[indexPath.row]), 緯度: \(self.lats[indexPath.row])")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateAndTimes.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.dateAndTimes.remove(at: indexPath.row)
            self.userDefaults.set(self.dateAndTimes, forKey: "DateAndTimes")
            
            self.planTitles.remove(at: indexPath.row)
            self.userDefaults.set(self.planTitles, forKey: "PlanTitles")
            
            self.places.remove(at: indexPath.row)
            self.userDefaults.set(self.places, forKey: "Places")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "toPlanDetails" {
            let PlanDetailsVC = segue.destination as! PlanDetailsViewController
            PlanDetailsVC.DateAndTime = self.dateAndTimes[(self.planTable.indexPathForSelectedRow?.row)!]
            PlanDetailsVC.PlanTitle = self.planTitles[(self.planTable.indexPathForSelectedRow?.row)!]
        }
    }
    
}

