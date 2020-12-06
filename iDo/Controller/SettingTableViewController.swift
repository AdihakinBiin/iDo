//
//  SettingViewController.swift
//  iDo
//
//  Created by Abdihakin Elmi on 12/1/20.
//

import UIKit
import SafariServices
import GoogleMobileAds
import MessageUI
import StoreKit
import ChameleonFramework

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
//MARK: -tableViewDelegate, Datasource extention
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Remove Ads"
            cell.imageView?.image = UIImage(systemName: "hand.raised.slash.fill")
            cell.imageView?.tintColor = .systemRed
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Rate Us"
            cell.imageView?.image = UIImage(systemName: "star.circle.fill")
            cell.imageView?.tintColor = .systemRed
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Feedback"
            cell.imageView?.image = UIImage(systemName: "pencil.circle.fill")
            cell.imageView?.tintColor = .systemRed
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let safariVC = SFSafariViewController(url: URL(string: "https://www.apple.com")!)
            present(safariVC, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            guard let scene = view.window?.windowScene else {
                return
            }
            SKStoreReviewController.requestReview(in: scene)
        } else if indexPath.row == 3 {
            let activityController = UIActivityViewController(activityItems: ["Hey, iDo is a fast, simple and secure app that I use to save my task and it makes me productive"], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        }  else if indexPath.row == 2 {
            if MFMailComposeViewController.canSendMail() {
                let mailVC = MFMailComposeViewController()
                mailVC.mailComposeDelegate = self
                mailVC.setToRecipients(["abdihakiin5452@gmail.com"])
                mailVC.setSubject("IOS-iDo Feedback")
                mailVC.setMessageBody("", isHTML: false)
                mailVC.setPreferredSendingEmailAddress("")
                present(mailVC, animated: true, completion: nil)
            } else {
                guard let url = URL(string: "https://www.icloud.com/mail") else {
                    return
                }
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
                
            }
        }
        
    }
}
//MARK: - MFMailCompose extention
extension SettingViewController: UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("canceled")
        case .failed:
            print("failed")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

