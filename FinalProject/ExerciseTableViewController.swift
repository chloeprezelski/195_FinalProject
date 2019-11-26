//
//  ExerciseTableViewController.swift
//  FinalProject
//
//  Created by Chloe Prezelski on 11/24/19.
//  Copyright © 2019 Chloe Prezelski. All rights reserved.
//

import UIKit
import Firebase

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
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start observing all changes in the database
        ref.child("exercises").observe(.value) { snapshot in
            
            if let exerciseDicts = snapshot.value as? [String : [String : Any]] {
                var newExercises = [Exercise]()
                for eachDict in exerciseDicts {
                    let dictValue = eachDict.value
                    //let dictKey = eachDict.key
                    
                    if let title = dictValue["title"] as? String,
                        let maxWeight = dictValue["maxWeight"] as? Double,
                    let entries = dictValue["entries"] as? [ExerciseEntry] {
                        newExercises.append(Exercise(title: title, maxWeight: maxWeight, entries: entries))
                    }
                }
                self.exercises = newExercises
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func addNewExercise(title: String) {
        // Create a reference to the new exercise, identified by a random id. We will use this reference to set the value.
        let newExerciseRef = ref.child("exercises").childByAutoId()
        
        // Create a dictionary representing the post. Notice we have both strings and ints, so we say "String : Any"
        let newExerciseDictionary: [String : Any] = [
            "title" : title,
            "maxWeight" : 0,
            "entries" : [ExerciseEntry]()
        ]
        // Use the database reference to create a new post
        newExerciseRef.setValue(newExerciseDictionary)
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
        addNewExercise(title: "My New Exercise")
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
