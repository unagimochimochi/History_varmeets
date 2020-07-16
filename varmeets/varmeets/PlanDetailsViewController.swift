//
//  PlanDetailsViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/07/06.
//

import UIKit

class PlanDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let planItem = ["参加者","場所","共有開始","通知"]
    
    var PlanTitle: String?
    var DateAndTime: String?
    
    // @IBOutlet weak var PlanDetailsTableView: UITableView!
    @IBOutlet weak var DateAndTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let DateAndTime = self.DateAndTime {
            DateAndTimeLabel.text = DateAndTime
        }
        
        if let PlanTitle = self.PlanTitle {
            self.navigationItem.title = PlanTitle
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanDetailsCell", for: indexPath)
        cell.textLabel?.text = planItem[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planItem.count
    }
    
    // Cell の高さを68にする
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == "editPlan" {
            let AddPlanVC = segue.destination as! AddPlanViewController
            AddPlanVC.PlanTitle = self.PlanTitle
            AddPlanVC.DateAndTime = self.DateAndTime
        }
    }
    
}
