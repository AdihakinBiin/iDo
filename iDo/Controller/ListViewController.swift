//
//  ViewController.swift
//  iDo
//
//  Created by Abdihakin Elmi on 11/26/20.
//

import UIKit
import CoreData
import ChameleonFramework
import GoogleMobileAds

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet  var listLabel: UILabel!
    @IBOutlet var bannerView: GADBannerView!

    var list = [List]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.floatingActionButton()
        fetchList()
        listLabel.isHidden = true
        // Replace this ad unit ID with your own ad unit ID.
          bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
          bannerView.rootViewController = self
          bannerView.load(GADRequest())
        
    }

    @IBAction func didTabAdd(_sender: UIButton){
        guard let vc = storyboard?.instantiateViewController(identifier: "addList") as? AddListViewController else { return }
        vc.completion = { text, color in
            self.dismiss(animated: true, completion: nil)
            let new =  List(context: self.context)
            new.name = text
            new.color = color.hexValue() ?? nil
            self.list.append(new)
            self.listLabel.isHidden = true
            self.tableView.isHidden = false
            self.saveList()
        }
        present(vc, animated: true, completion: nil)
       
    }
    @IBAction func didtabSettings(){
        guard let vc = storyboard?.instantiateViewController(identifier: "setting") as? SettingViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list.count == 0 {
            tableView.isHidden = true
            listLabel.isHidden = false
        }
        return list.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        cell.textLabel?.text = list[indexPath.row].name
        cell.imageView?.tintColor = UIColor(hexString: list[indexPath.row].color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = storyboard?.instantiateViewController(identifier: "task") as? TaskViewController else { return }
        vc.SelectedList = list[indexPath.row]
        vc.title = list[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }

    // this method handles row deletion
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, sourceView, completionHandler) in
            /// remove the item from the data model
            self.context.delete(self.list[indexPath.row])
            self.list.remove(at: indexPath.row)
            
            /// delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveList()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    //MARK: - Data Manipulation Methods
    func saveList(){
        do {
            try context.save()
        } catch  {
        fatalError("nothing was saved to the database")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchList(with request : NSFetchRequest<List> = List.fetchRequest())  {
        do {
          list =  try context.fetch(request)
        } catch  {
            fatalError("no data fatched from the database")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
   
    
}

