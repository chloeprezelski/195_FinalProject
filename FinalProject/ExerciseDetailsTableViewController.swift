//
//  ExerciseDetailsTableViewController.swift
//  FinalProject
//
//  Created by Chloe Prezelski on 11/24/19.
//  Copyright © 2019 Chloe Prezelski. All rights reserved.
//

import UIKit

class ExerciseDetailsTableViewController: UITableViewController, EntryDelegate {
    var currentExercise : Exercise!
    var currentEntries : [ExerciseEntry]!
    
    func didAddEntry(_ entry: ExerciseEntry) {
        dismiss(animated: true, completion: nil)
        currentEntries.insert(entry, at: 0)
        self.tableView.reloadData()
        print("Did dismiss popover")
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        currentEntries = currentExercise.entries

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentEntries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    @IBAction func addExerciseEntry(_ sender: UIBarButtonItem) {
        print("add button pressed")
        performSegue(withIdentifier: "Add Exercise Entry", sender: sender)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry", for: indexPath)

        cell.textLabel?.text = self.currentEntries[indexPath.row].date
        
        if let weightLabel = cell.viewWithTag(2) as? UILabel {
            weightLabel.text = String(currentEntries[indexPath.row].weight)
        }
        //cell.textLabel?.text = self.currentExercise.title
        //cell.detailTextLabel?.text = self.currentEntries[indexPath.row].date
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

 */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Add Exercise Entry" {
            print("Add Exercise Entry segue")
            if let evc = segue.destination as? EntryViewController {
                    evc.delegate = self
                }
            
        }
    }

}
