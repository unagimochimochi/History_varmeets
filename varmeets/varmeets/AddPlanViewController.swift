//
//  AddPlanViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/05/15.
//
// TableView 基礎 https://qiita.com/pe-ta/items/cafa8e20029047993025
// セルごとアクションを変える https://tech.pjin.jp/blog/2016/09/24/tableview-14/

import UIKit

class AddPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var PlanTitle: String?
    var DateAndTime: String!
    var address: String! // ?にすると値が渡らない
    var lon: String = ""
    var lat: String = ""
    
    @IBOutlet weak var addPlanTable: UITableView!
    
    @IBOutlet weak var PlanTitleTextField: UITextField!
    
    // キャンセルボタン
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存ボタン
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var planItem = ["日時","参加者","場所","共有開始","通知"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPlanTable.dataSource = self
        
        if let PlanTitle = self.PlanTitle {
            self.PlanTitleTextField.text = PlanTitle
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        // var lineupcell: UITableViewCell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateAndTimeCell", for:indexPath) as! DateAndTimeCell
            cell.textLabel?.text = planItem[indexPath.row]
            cell.displayDateAndTimeTextField.text = DateAndTime
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for:indexPath) // as UITableViewCell
            cell.textLabel?.text = planItem[indexPath.row]
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for:indexPath) as! PlaceCell
            cell.textLabel?.text = planItem[indexPath.row]
            cell.displayPlaceTextField.text = address
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for:indexPath) // as UITableViewCell
            cell.textLabel?.text = planItem[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return planItem.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("\(indexPath.row)番セルをタップ")
        tableView.deselectRow(at: indexPath, animated: true) // セルの選択を解除
        
        if indexPath.row == 0 {
            if let cell = tableView.cellForRow(at: indexPath) as? DateAndTimeCell {
                cell.displayDateAndTimeTextField.becomeFirstResponder()
            }
        } else {
            // 0番セル以外をクリックしたらキーボードを閉じる
            view.endEditing(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        guard let button = sender as? UIBarButtonItem, button === self.saveButton else {
            return
        }
        self.PlanTitle = self.PlanTitleTextField.text ?? ""
        self.DateAndTime = (addPlanTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? DateAndTimeCell)?.displayDateAndTimeTextField.text ?? ""
        self.address = (addPlanTable.cellForRow(at: IndexPath(row: 2, section: 0)) as? PlaceCell)?.displayPlaceTextField.text ?? ""
    }
    
}
