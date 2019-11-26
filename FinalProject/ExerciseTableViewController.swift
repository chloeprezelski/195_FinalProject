//
//  ExerciseTableViewController.swift
//  FinalProject
//
//  Created by Chloe Prezelski on 11/24/19.
//  Copyright © 2019 Chloe Prezelski. All rights reserved.
//

import UIKit

struct ExerciseEntry {
    var reps : Int
    var weight : Double
    var date : Date
}

struct Exercise {
    var title : String
    var maxWeight : Double
    var entries : [ExerciseEntry]
}

class ExerciseTableViewController: UITableViewController {
     var exercises = [Exercise]()
    
    override func viewDidLoad() {
        
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath)
        cell.textLabel?.text = self.exercises[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "Show Details", sender: cell)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add button pressed")
        performSegue(withIdentifier: "Add Exercise", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Details" {
            print("Show Details")
            
        }
        
        if segue.identifier == "Add Exercise" {
            print("Add Exercise")
            
        }
    }
}
