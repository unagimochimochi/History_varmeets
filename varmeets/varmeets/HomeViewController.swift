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
    var estimatedTimes = [Date]()
    var estimatedTimesSort = [Date]()
    var planTitles = [String]()
    // var participantImgs = [UIImage]()
    var participantNames = [String]()
    var places = [String]()
    var lons = [String]()
    var lats = [String]()
    
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var countdownViewHeight: NSLayoutConstraint!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var countdownDateAndTimeLabel: UILabel!
    @IBOutlet weak var countdownPlanTitleLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBAction func unwindtoHomeVC(sender: UIStoryboardSegue) {
        // 日時
        guard let sourceVC1 = sender.source as? AddPlanViewController, let dateAndTime = sourceVC1.DateAndTime else {
            return
        }
        
        if let selectedIndexPath = self.planTable.indexPathForSelectedRow {
            self.dateAndTimes[selectedIndexPath.row] = dateAndTime
            self.estimatedTimes[selectedIndexPath.row] = sourceVC1.estimatedTime
            
        } else {
            self.dateAndTimes.append(dateAndTime)
            self.estimatedTimes.append(sourceVC1.estimatedTime)
            
            // 表示する時刻の設定
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.timeZone = .autoupdatingCurrent
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .short
            // print("0番目→\(dateFormatter.string(from: estimatedTimes[0])) , 1番目→\(dateFormatter.string(from: estimatedTimes[1]))")
        }
        
        self.userDefaults.set(self.dateAndTimes, forKey: "DateAndTimes")
        self.userDefaults.set(self.estimatedTimes, forKey: "EstimatedTimes")
        
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
        guard let sourceVC4 = sender.source as? AddPlanViewController, let place = sourceVC4.place else {
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
        
        // カウントダウンを非表示
        hiddenCountdown()

        // 1秒ごとに処理
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        if self.userDefaults.object(forKey: "DateAndTimes") != nil {
            self.dateAndTimes = self.userDefaults.stringArray(forKey: "DateAndTimes")!
        } else {
            self.dateAndTimes = ["日時"]
        }
        
        if self.userDefaults.object(forKey: "EstimatedTimes") != nil {
            self.estimatedTimes = self.userDefaults.array(forKey: "EstimatedTimes") as! [Date]
        } else {
            // estimatedTimesの初期値に 00:00:00 UTC on 1 January 2001 を設定
            let referenceDate = Date(timeIntervalSinceReferenceDate: 0.0)
            self.estimatedTimes = [referenceDate]
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
        
        let dateAndTimeLabel = cell.viewWithTag(1) as! UILabel
        dateAndTimeLabel.text = self.dateAndTimes[indexPath.row]
        
        let planTitleLabel = cell.viewWithTag(2) as! UILabel
        planTitleLabel.text = self.planTitles[indexPath.row]
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
            
            self.estimatedTimes.remove(at: indexPath.row)
            self.userDefaults.set(self.estimatedTimes, forKey: "EstimatedTimes")
            
            self.planTitles.remove(at: indexPath.row)
            self.userDefaults.set(self.planTitles, forKey: "PlanTitles")
            
            self.places.remove(at: indexPath.row)
            self.userDefaults.set(self.places, forKey: "Places")
            
            self.lons.remove(at: indexPath.row)
            self.userDefaults.set(self.lons, forKey: "lons")
            
            self.lats.remove(at: indexPath.row)
            self.userDefaults.set(self.lats, forKey: "lats")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func update() {
        let now = Date()
        let calendar = Calendar(identifier: .japanese)
        
        // 予定サンプルが消されていないとき
        if planTitles.contains("予定サンプル") == true {
            // サンプル以外の予定が登録されているとき
            if estimatedTimes.count >= 2 {
                print("サンプルあり、サンプル以外の予定あり")
                // 並べ替え用の配列に予定時刻をセット
                estimatedTimesSort = estimatedTimes
                // 並べ替え用の配列で並べ替え
                estimatedTimesSort.sort { $0 < $1 }
                
                let components = calendar.dateComponents([.year, .day, .hour, .minute, .second], from: now, to: estimatedTimesSort[1])
                
                // 1時間未満のとき
                if components.year! == 0 && components.day! == 0 && components.hour! == 0 &&
                    components.minute! >= 0 && components.minute! <= 59 &&
                    components.second! >= 0 && components.second! <= 59 {
                    print("サンプルあり、1時間未満の予定あり")
                    // カウントダウンを表示
                    displayCountdown()
                    
                    countdownLabel.text = String(format: "%02d:%02d", components.minute!, components.second!)
                }
            }
                
            // 予定がサンプルのみのとき
            else {
                print("サンプルのみ")
                // カウントダウンを非表示
                hiddenCountdown()
            }
        }
        
        // 予定サンプルが消されているとき
        else {
            // 予定が複数個登録されているとき
            if estimatedTimes.count >= 2 {
                // 並べ替え用の配列に予定時刻をセット
                estimatedTimesSort = estimatedTimes
                // 並べ替え用の配列で並べ替え
                estimatedTimesSort.sort { $0 < $1 }
                
                let components = calendar.dateComponents([.year, .day, .hour, .minute, .second], from: now, to: estimatedTimesSort[0])
                
                // 1時間未満のとき
                if components.year! == 0 && components.day! == 0 && components.hour! == 0 &&
                    components.minute! >= 0 && components.minute! <= 59 &&
                    components.second! >= 0 && components.second! <= 59 {
                    // カウントダウンを表示
                    displayCountdown()
                    
                    countdownLabel.text = String(format: "%02d:%02d", components.minute!, components.second!)
                }
            }
            
            // 予定がひとつだけ登録されているとき
            else if estimatedTimes.count == 1 {
                let components = calendar.dateComponents([.year, .day, .hour, .minute, .second], from: now, to: estimatedTimes[0])
                
                // 1時間未満のとき
                if components.year! == 0 && components.day! == 0 && components.hour! == 0 &&
                    components.minute! >= 0 && components.minute! <= 59 &&
                    components.second! >= 0 && components.second! <= 59 {
                    // カウントダウンを表示
                    displayCountdown()
                    
                    countdownLabel.text = String(format: "%02d:%02d", components.minute!, components.second!)
                    countdownDateAndTimeLabel.text = dateAndTimes[0]
                    countdownPlanTitleLabel.text = planTitles[0]
                }
            }
            
            // 予定がひとつも登録されていないとき
            else {
                // カウントダウンを非表示
                hiddenCountdown()
            }
        }
    }
    
    func displayCountdown() {
        countdownViewHeight.constant = 200
        countdownLabel.isHidden = false
        countdownDateAndTimeLabel.isHidden = false
        countdownPlanTitleLabel.isHidden = false
        completeButton.isHidden = false
    }
    
    func hiddenCountdown() {
        countdownViewHeight.constant = 0
        countdownLabel.isHidden = true
        countdownDateAndTimeLabel.isHidden = true
        countdownPlanTitleLabel.isHidden = true
        completeButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "toPlanDetails" {
            let planDetailsVC = segue.destination as! PlanDetailsViewController
            planDetailsVC.DateAndTime = self.dateAndTimes[(self.planTable.indexPathForSelectedRow?.row)!]
            planDetailsVC.PlanTitle = self.planTitles[(self.planTable.indexPathForSelectedRow?.row)!]
            planDetailsVC.place = self.places[(self.planTable.indexPathForSelectedRow?.row)!]
            planDetailsVC.lonStr = self.lons[(self.planTable.indexPathForSelectedRow?.row)!]
            planDetailsVC.latStr = self.lats[(self.planTable.indexPathForSelectedRow?.row)!]
        }
    }
    
}

