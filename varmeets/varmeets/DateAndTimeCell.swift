//
//  DateAndTimeCell.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/06/16.
//
// datePicker https://qiita.com/ryomaDsakamoto/items/ab4ae031706a8133f193
// CGRectの書き方 https://qiita.com/MilanistaDev/items/fbf5fb890d9a3a7180cd

import UIKit

class DateAndTimeCell: UITableViewCell {
    
    @IBOutlet weak var displayDateAndTime: UITextField!
    var datePicker: UIDatePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        displayDateAndTime.inputView = datePicker
            
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        // インプットビュー設定(紐づいているUITextfieldへ代入)
        displayDateAndTime.inputView = datePicker
        displayDateAndTime.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        displayDateAndTime.endEditing(true)
        
        // 日付のフォーマット
        let formatter = DateFormatter()
        
        //日本仕様で日付の出力
        formatter.timeStyle = .short
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "ja_JP")

        //datePickerで指定した日付が表示される
        displayDateAndTime.text = "\(formatter.string(from: datePicker.date))"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
