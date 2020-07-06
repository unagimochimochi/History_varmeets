//
//  AddPlanViewController.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/05/15.
//
// TableView 基礎 https://qiita.com/pe-ta/items/cafa8e20029047993025
// セルごとアクションを変える https://tech.pjin.jp/blog/2016/09/24/tableview-14/

import UIKit

var saveDateAndTime = [String]() // datePickerで取得した日時を保存するための変数

class AddPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var PlanTitle: String?
    var DateAndTime: String?

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
        
        // タイトル文字列の設定
        self.navigationItem.title = "予定を追加"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DateAndTimeCell", for:indexPath) as UITableViewCell

        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for:indexPath) as UITableViewCell
        }
        cell.textLabel?.text = planItem[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return planItem.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番セルをタップ")
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
        /*
        if (segue.identifier == "toReceiveTestVC") {
            let VC: ReceiveTestViewController = (segue.destination as? ReceiveTestViewController)!
            let indexPath = IndexPath(row: 0, section: 0)
            VC.receiveData = (addPlanTable.cellForRow(at: indexPath) as? DateAndTimeCell)?.displayDateAndTimeTextField.text ?? ""
        }
        */
        guard let button = sender as? UIBarButtonItem, button === self.saveButton else {
            return
        }
        let indexPath = IndexPath(row: 0, section: 0)
        self.PlanTitle = self.PlanTitleTextField.text ?? ""
        self.DateAndTime = (addPlanTable.cellForRow(at: indexPath) as? DateAndTimeCell)?.displayDateAndTimeTextField.text ?? ""
    }
}
