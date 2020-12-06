//
//  TaskViewController.swift
//  iDo
//
//  Created by Abdihakin Elmi on 11/26/20.
//

import UIKit
import CoreData
import ChameleonFramework
import GoogleMobileAds

class TaskViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    
    var task = [Task]()
    @IBOutlet var bannerView: GADBannerView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
 
    
    var SelectedList: List? {
        didSet{
            fetchTask()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.floatingActionButton()
        taskLabel.isHidden = true
        // Replace this ad unit ID with your own ad unit ID.
          bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
          bannerView.rootViewController = self
          bannerView.load(GADRequest())
    }
   
    
    @IBAction func didTabAdd(){
        guard let vc = storyboard?.instantiateViewController(identifier: "addTask") as? AddTaskViewController else { return }
        vc.title = "Add New Task"
        vc.completionTask = { text, date in
            self.dismiss(animated: true, completion: nil)
            let newTask = Task(context: self.context)
            newTask.title = text
            newTask.date = date
            newTask.parentList = self.SelectedList
            newTask.color = self.SelectedList?.color
            self.task.append(newTask)
            self.taskLabel.isHidden = true
            self.tableView.isHidden = false
            self.saveTask()
        }
        present(vc, animated: true, completion: nil)
    }
    //MARK: -Data Manipulation Methods
    func saveTask() {
        do {
            try context.save()
        } catch {
            fatalError("no data saved")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchTask(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil){
       let listPredicate =  NSPredicate(format: "parentList.name MATCHES %@", SelectedList!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [listPredicate, additionalPredicate])
        } else  {
            request.predicate = listPredicate
        }
        
        do{
          task = try context.fetch(request)
        } catch {
            fatalError("there is no data to fetch from the database")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
//MARK: - tableView Method Extention
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if task.count == 0 {
            tableView.isHidden = true
            taskLabel.isHidden = false
        }
        return task.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = task[indexPath.row].title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d 'at' hh:mm"
        dateFormatter.locale = Locale.current

        cell.backgroundColor = UIColor(hexString: SelectedList?.color)?.darken(byPercentage:  CGFloat(indexPath.row) / CGFloat(task.count))
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
        cell.detailTextLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)


        cell.detailTextLabel?.text = dateFormatter.string(from: task[indexPath.row].date!)
        return cell
    }
    
    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            /// remove the item from the data model
            self.context.delete(self.task[indexPath.row])
            self.task.remove(at: indexPath.row)

            /// delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveTask()
        }
    }
}

//MARK:  - searchBar extention
extension TaskViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
            self.tableView.reloadData()
        }
        
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true)]
        
        
        do{
          task = try context.fetch(request)
        } catch {
            fatalError("there is no data to fetch from the database")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
