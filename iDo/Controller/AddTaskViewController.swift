//
//  AddTaskViewController.swift
//  iDo
//
//  Created by Abdihakin Elmi on 11/27/20.
//

import UIKit
import GoogleMobileAds

class AddTaskViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    
    
    public var completionTask: ((String, Date, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDate()
        updateTime()
        datePicker.isHidden = true
        timePicker.isHidden = true
        textField.delegate = self
        textField.becomeFirstResponder()
        
    }
    
    
    @IBAction func didTabDone(){
        if let text = textField.text, !text.isEmpty {
            
            completionTask?(text, datePicker.date, timePicker.date)
        }
    }
    @IBAction func didTabCancel(){
        textField.resignFirstResponder()
        if let text = textField?.text, !text.isEmpty{
            let alert = UIAlertController()
            let action = UIAlertAction(title: "Discard Changes", style: .destructive) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            }
            alert.addAction(action)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale.current
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    private func updateTime(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        timeLabel.text = dateFormatter.string(from: timePicker.date)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 1 {
            let height:CGFloat = datePicker.isHidden ? 0.0 : 330.0
            return height
        }
        if indexPath.section == 2 && indexPath.row == 3 {
            let height:CGFloat = timePicker.isHidden ? 0.0 : 60.0
            return height
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath as IndexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dobIndexPath = NSIndexPath(row: 0, section: 2)
        let timeIndexPath = NSIndexPath(row: 2, section: 2)
        if dobIndexPath as IndexPath == indexPath {
            
            datePicker.isHidden = !datePicker.isHidden
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                // apple bug fix - some TV lines hide after animation
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
            
        }
        if timeIndexPath as IndexPath == indexPath {
            
            timePicker.isHidden = !timePicker.isHidden
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                // apple bug fix - some TV lines hide after animation
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        }
        
    }
    
    @IBAction func didSwichNotification(_ sender: UISwitch) {
        if sender.isOn {
            // fire test Notification
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                if success {
                    DispatchQueue.main.async {
                        // schedule notification
                        let content = UNMutableNotificationContent()
                        content.title = self.textField.text!
                        //                        content.body = "Dreams don't work unless you do, wake Up and complete your \(self.textField.text!) task"
                        content.sound = .default
                        let dateTrigger = self.timePicker.date
                        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateTrigger), repeats: true)
                        let request = UNNotificationRequest(identifier: self.description, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                            if error != nil {
                                print("something went wrong")
                            }
                        })
                    }
                }
                else if let error = error {
                    print(error)
                }
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
