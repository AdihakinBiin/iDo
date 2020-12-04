//
//  ViewController.swift
//  iDo
//
//  Created by Abdihakin Elmi on 11/26/20.
//

import UIKit
import CoreData
import ChameleonFramework

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    @IBOutlet weak var tableView: UITableView!
    
    var list = [List]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchList()
    }

    @IBAction func didTabAdd(_sender: UIButton){
        guard let vc = storyboard?.instantiateViewController(identifier: "addList") as? AddListViewController else { return }
        vc.completion = { text, color in
            self.dismiss(animated: true, completion: nil)
            let new =  List(context: self.context)
            new.name = text
//            new.color = color.hexValue()
            self.list.append(new)
            self.saveList()
        }
        present(vc, animated: true, completion: nil)
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].name
//        cell.imageView?.image = list[indexPath.row].color.hexValue()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = list[indexPath.row].name
        
        guard let vc = storyboard?.instantiateViewController(identifier: "task") as? TaskViewController else { return }
        vc.title = task
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
    
    func fetchList()  {
        let request : NSFetchRequest<List> = List.fetchRequest()
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

