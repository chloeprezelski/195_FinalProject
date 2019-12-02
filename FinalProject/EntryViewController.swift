//
//  EntryViewController.swift
//  FinalProject
//
//  Created by Chloe Prezelski on 11/27/19.
//  Copyright © 2019 Chloe Prezelski. All rights reserved.
//

import UIKit

protocol EntryDelegate: class {
    func didAddEntry(_ entry: ExerciseEntry)
}

class EntryViewController : UIViewController {
    
    @IBOutlet weak var times: UITextField!
    @IBOutlet weak var reps: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var date : UITextField!
    weak var delegate: EntryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("save button pressed")
        let newExerciseEntry = createNewExerciseEntry()
        if newExerciseEntry != nil {
            self.delegate?.didAddEntry(newExerciseEntry!)
        }
    }
    
    func createNewExerciseEntry() -> ExerciseEntry? {
        var newDate = ""
        var newWeight = 0.0
        var newReps = 0
        if self.reps.text != nil {
            let tempString : String = reps.text!
            newReps = Int(tempString) ?? 0
        }
        if self.weight.text != nil {
            let tempString : String = weight.text!
            newWeight = Double(tempString) ?? 0.0
        }
        if self.date != nil {
            newDate = date.text!
        }
        return ExerciseEntry(reps: newReps, weight: newWeight, date: newDate)
    }
}
