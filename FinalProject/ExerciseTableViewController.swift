//
//  ExerciseTableViewController.swift
//  FinalProject
//
//  Created by Chloe Prezelski on 11/24/19.
//  Copyright © 2019 Chloe Prezelski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct ExerciseEntry {
    var reps : Int
    var weight : Double
    var date : String
}

struct Exercise {
    var title : String
    var maxWeight : Double
    var entries : [ExerciseEntry]?
    init(title: String, maxWeight: Double, entries: [ExerciseEntry]) {
        self.title = title
        self.maxWeight = maxWeight
        self.entries = entries        
    }
    var id : String?
}

class ExerciseTableViewController: UITableViewController, AddExerciseDelegate {
    
    func didCreate(_ exercise: Exercise) {
        dismiss(animated: true, completion: nil)
        exercises.append(exercise)
        let sortedExercises = exercises.sorted( by: {$0.title < $1.title })
        exercises = sortedExercises
        self.tableView.reloadData()
    }
    
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
                    let dictKey = eachDict.key
                    var exTitle = ""
                    var exMaxWeight = 0.0
                    
                    if let title = dictValue["title"] as? String,
                       let maxWeight = dictValue["maxWeight"] as? Double {
                        exTitle = title
                        exMaxWeight = maxWeight
                    }
                    
                    if let entryDicts = dictValue["entries"] as? [String : [String : Any]] {
                        var newEntries = [ExerciseEntry]()
                        for eachEntry in entryDicts {
                            let entryValue = eachEntry.value
                            if let date = entryValue["date"] as? String, let reps = entryValue["reps"] as? Int, let weight = entryValue["weight"] as? Double {
                                let myEntry : ExerciseEntry = ExerciseEntry(reps: reps, weight: weight, date: date)
                                newEntries.append(myEntry)
                            }
                        }
                        var myExercise : Exercise = Exercise(title: exTitle, maxWeight: exMaxWeight, entries: newEntries)
                        myExercise.id = dictKey
                        newExercises.append(myExercise)
                    } else {
                        var myExercise : Exercise = Exercise(title: exTitle, maxWeight: exMaxWeight, entries: [ExerciseEntry]())
                        myExercise.id = dictKey
                        newExercises.append(myExercise)
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
    
    func addNewExerciseToDatabase(exercise: Exercise) {
        // Create a reference to the new exercise, identified by a random id. We will use this reference to set the value.
        let newExerciseRef = ref.child("exercises").childByAutoId()

        // Create a dictionary representing the post. Notice we have both strings and ints, so we say "String : Any"
        let newExerciseDictionary: [String : Any] = [
            "title" : exercise.title,
            "maxWeight" : exercise.maxWeight,
            "entries" : 0
            //"entries" : exercise.entries ?? [ExerciseEntry]()
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
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
        //addNewExercise(title: "My New Exercise")
        performSegue(withIdentifier: "Add Exercise", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Details" {
            print("Show Details")
            if let edtvc = segue.destination as? ExerciseDetailsTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    edtvc.currentExercise = exercises[indexPath.row]
                }
            }
            
        }
        
        if segue.identifier == "Add Exercise" {
            print("Add Exercise")
            if let nc = segue.destination as? UINavigationController {
                if let aevc = nc.viewControllers[0] as? AddExerciseViewController {
                    aevc.delegate = self
                }
                
            }
            
        }
    }
}
