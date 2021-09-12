//
//  TasksTableViewController.swift
//  Bored
//
//  Created by Pavel Paddubotski on 12.09.21.
//

import UIKit
import RealmSwift

class TasksTableViewController: UITableViewController {
    
    let realm = (UIApplication.shared.delegate as! AppDelegate).realm
    var tasks: Results<Tasks>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = realm!.objects(Tasks.self)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.text = tasks[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        try! realm!.write {
            realm?.delete(tasks[indexPath.row])
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
