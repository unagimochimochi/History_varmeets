//
//  HomeViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/02/26.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var PlanTable: UITableView!
    var DateAndTimes = [String]()
    var PlanTitles = [String]()
    // var ParticipantImgs = [UIImage]()
    var ParticipantNames = [String]()
    var Places = [String]()
    
    @IBAction func unwindtoHomeVC(sender: UIStoryboardSegue) {
        
        guard let sourceVC1 = sender.source as? AddPlanViewController, let DateAndTime = sourceVC1.DateAndTime else {
            return
        }
        if let selectedIndexPath = self.PlanTable.indexPathForSelectedRow {
            self.DateAndTimes[selectedIndexPath.row] = DateAndTime
        } else {
            self.DateAndTimes.append(DateAndTime)
        }
        self.userDefaults.set(self.DateAndTimes, forKey: "DateAndTimes")
        
        guard let sourceVC2 = sender.source as? AddPlanViewController, let PlanTitle = sourceVC2.PlanTitle else {
            return
        }
        if let selectedIndexPath = self.PlanTable.indexPathForSelectedRow {
            self.PlanTitles[selectedIndexPath.row] = PlanTitle
        } else {
            self.PlanTitles.append(PlanTitle)
        }
        self.userDefaults.set(self.PlanTitles, forKey: "PlanTitles")
        
        guard let sourceVC4 = sender.source as? AddPlanViewController, let Place = sourceVC4.address else {
            return
        }
        if let selectedIndexPath = self.PlanTable.indexPathForSelectedRow {
            self.Places[selectedIndexPath.row] = Place
        } else {
            self.Places.append(Place)
        }
        self.userDefaults.set(self.Places, forKey: "Places")
        
        self.PlanTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.userDefaults.object(forKey: "DateAndTimes") != nil {
            self.DateAndTimes = self.userDefaults.stringArray(forKey: "DateAndTimes")!
        } else {
            self.DateAndTimes = ["日時"]
        }
        
        if self.userDefaults.object(forKey: "PlanTitles") != nil {
            self.PlanTitles = self.userDefaults.stringArray(forKey: "PlanTitles")!
        } else {
            self.PlanTitles = ["予定サンプル"]
        }
        
        if self.userDefaults.object(forKey: "Places") != nil {
            self.Places = self.userDefaults.stringArray(forKey: "Places")!
        } else {
            self.Places = ["場所"]
        }
        
        // self.ParticipantImgs = ["FriendsNoimg"]
        self.ParticipantNames = ["参加者"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // print(#function)

        if let indexPath = PlanTable.indexPathForSelectedRow {
            PlanTable.deselectRow(at: indexPath, animated: true)
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
        // let img = UIImage(named: ParticipantImgs[indexPath.row] as! String)
        
        let DateAndTimeLabel = cell.viewWithTag(1) as! UILabel
        DateAndTimeLabel.text = self.DateAndTimes[indexPath.row]
        
        let PlanTitleLabel = cell.viewWithTag(2) as! UILabel
        PlanTitleLabel.text = self.PlanTitles[indexPath.row]
        /*
         // let ParticipantImageView = cell.viewWithTag(3) as! UIImageView
         // ParticipantImageView.image = img
         
         let ParticipantLabel = cell.viewWithTag(4) as! UILabel
         ParticipantLabel.text = self.ParticipantNames[indexPath.row]
         */
        let placeLabel = cell.viewWithTag(5) as! UILabel
        placeLabel.text = self.Places[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DateAndTimes.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.DateAndTimes.remove(at: indexPath.row)
            self.userDefaults.set(self.DateAndTimes, forKey: "DateAndTimes")
            
            self.PlanTitles.remove(at: indexPath.row)
            self.userDefaults.set(self.PlanTitles, forKey: "PlanTitles")
            
            self.Places.remove(at: indexPath.row)
            self.userDefaults.set(self.Places, forKey: "Places")
            
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
            PlanDetailsVC.DateAndTime = self.DateAndTimes[(self.PlanTable.indexPathForSelectedRow?.row)!]
            PlanDetailsVC.PlanTitle = self.PlanTitles[(self.PlanTable.indexPathForSelectedRow?.row)!]
        }
    }
    
}

