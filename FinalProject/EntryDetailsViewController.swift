//
//  EntryDetailsViewController.swift
//  FinalProject
//
//  Created by Chloe Prezelski on 12/5/19.
//  Copyright © 2019 Chloe Prezelski. All rights reserved.
//

import UIKit

class EntryDetailsViewController : UIViewController {
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var repsLabel : UILabel!
    @IBOutlet weak var exerciseLabel : UILabel!
    @IBOutlet weak var weightLabel : UILabel!
    var dateString : String?
    var repsString : Int?
    var exerciseString : String?
    var weightString : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dateString != nil {
            
            dateLabel.text = dateString!
        }
        if repsString != nil {
            repsLabel.text = "\(repsString!)"
        }
        if weightString != nil {
            var s = "\(weightString!)"
            s += "lbs"
            var myStr = String(format:"%f", weightString!)
            myStr += " lbs"
            weightLabel.text = s
        }
        if exerciseString != nil {
            exerciseLabel.text = exerciseString!
        }
    }
    
}
