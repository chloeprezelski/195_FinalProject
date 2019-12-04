//
//  EntryViewController.swift
//  FinalProject
//
//  Created by Chloe Prezelski on 11/27/19.
//  Copyright © 2019 Chloe Prezelski. All rights reserved.
//

import UIKit
import Firebase

protocol EntryDelegate: class {
    func didAddEntry(_ entry: ExerciseEntry)
}

class EntryViewController : UIViewController {
    
    @IBOutlet weak var times: UITextField!
    @IBOutlet weak var reps: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var month: UITextField!
    @IBOutlet weak var day: UITextField!
    @IBOutlet weak var year: UITextField!
    weak var delegate: EntryDelegate?
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateNow = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: dateNow)
        formatter.dateFormat = "MM"
        let monthString = formatter.string(from: dateNow)
        formatter.dateFormat = "dd"
        let dayString = formatter.string(from: dateNow)
        month.text = monthString
        day.text = dayString
        year.text = yearString
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
        if self.reps.hasText {
            let tempString : String = reps.text!
            newReps = Int(tempString) ?? 0
        } else {
            return nil
        }
        if self.weight.hasText {
            let tempString : String = weight.text!
            newWeight = Double(tempString) ?? 0.0
        } else {
            return nil
        }
        if self.month.hasText && self.day.hasText && self.year.hasText {
            newDate += year.text!
            newDate += "-"
            newDate += month.text!
            newDate += "-"
            newDate += day.text!
        } else {
            return nil
        }
        return ExerciseEntry(reps: newReps, weight: newWeight, date: newDate)
    }
}
