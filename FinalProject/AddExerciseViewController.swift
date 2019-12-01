//
//  AddExerciseViewController.swift
//  FinalProject
//
//  Created by Chloe Prezelski on 12/1/19.
//  Copyright © 2019 Chloe Prezelski. All rights reserved.
//

import UIKit

protocol AddExerciseDelegate: class {
    func didCreate(_ exercise: Exercise)
}

class AddExerciseViewController : UIViewController {
    weak var delegate: AddExerciseDelegate?
    @IBOutlet weak var titleText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //let newContact = createNewContact()
        let newExercise = createNewExercise()
        if newExercise != nil {
            self.delegate?.didCreate(newExercise!)
        }
    }
    
    func createNewExercise() -> Exercise? {
        var title : String = ""
        let maxWeight : Double = 0.0
        let entries : [ExerciseEntry] = [ExerciseEntry]()
        if titleText != nil {
            title = titleText.text!
        }
        return Exercise(title: title, maxWeight: maxWeight, entries: entries)
    }
}
