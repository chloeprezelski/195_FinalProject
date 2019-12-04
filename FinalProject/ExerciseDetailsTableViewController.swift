//
//  ExerciseDetailsTableViewController.swift
//  FinalProject
//
//  Created by Chloe Prezelski on 11/24/19.
//  Copyright © 2019 Chloe Prezelski. All rights reserved.
//

import UIKit
import Firebase
import Charts

class ExerciseDetailsTableViewController: UITableViewController, EntryDelegate {
    var currentExercise : Exercise!
    var currentEntries : [ExerciseEntry]!
    let ref = Database.database().reference()
    @IBOutlet weak var chtChart: LineChartView!
    
    func didAddEntry(_ entry: ExerciseEntry) {
        dismiss(animated: true, completion: nil)
        addEntryToDatabase(entry: entry)
        currentEntries.append(entry)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sortedEntries = currentEntries.sorted { dateFormatter.date(from:$0.date)! < dateFormatter.date(from:$1.date)! }
        currentEntries = sortedEntries
        self.tableView.reloadData()
        updateGraph()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        currentEntries = currentExercise.entries
        if currentEntries.count != 0 {
            updateGraph()
        }
        chtChart.rightAxis.enabled = false
        chtChart.chartDescription?.enabled = false
    }
    
    func addEntryToDatabase(entry : ExerciseEntry) {
        if currentEntries.count == 0 {
            let newEntryDictionary: [String : Any] = [
                "date" : entry.date,
                "reps" : entry.reps,
                "weight" : entry.weight
            ]
            ref.child("exercises").child(currentExercise.id ?? "").child("entries").childByAutoId().updateChildValues(newEntryDictionary)
        } else {
            let newEntryRef = ref.child("exercises").child(currentExercise.id ?? "").child("entries").childByAutoId()
            let newEntryDictionary: [String : Any] = [
                "date" : entry.date,
                "reps" : entry.reps,
                "weight" : entry.weight
            ]
            newEntryRef.setValue(newEntryDictionary)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // need to also delete from database
            currentEntries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add Exercise Entry" {
            print("Add Exercise Entry segue")
            if let nc = segue.destination as? UINavigationController {
                if let evc = nc.viewControllers[0] as? EntryViewController {
                    evc.delegate = self
                }
            }
        }
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.


        //here is the for loop
        for entry in currentEntries {
            let yValue = entry.weight

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let xValue = dateFormatter.date(from:entry.date)!.timeIntervalSince1970

            let value = ChartDataEntry(x: xValue, y: yValue) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Dates") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue

        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet


        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }
    
//    func updateGraph(){
//        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
//        
//        
//        //here is the for loop
//        for i in 0..<numbers.count {
//
//            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
//            lineChartEntry.append(value) // here we add it to the data set
//        }
//
//        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
//        line1.colors = [NSUIColor.blue] //Sets the colour to blue
//
//        let data = LineChartData() //This is the object that will be added to the chart
//        data.addDataSet(line1) //Adds the line to the dataSet
//        
//
//        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
//        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
//    }

}
