//
//  NotesViewController.swift
//  Health
//
//  Created by Даниил Марусенко on 02.02.2021.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let realm = try! Realm()
    var currentMeasure = "temperature"
    var temperatureArray = [[String]]()
    var oxygenArray = [[String]]()
    var pulseArray = [[String]]()
    var breathArray = [[String]]()
    var index: Int?
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        let selectedFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor:UIColor.black]
        segmentedControl.setTitleTextAttributes(selectedFont, for: .selected)
        let normalFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:UIColor.black]
        segmentedControl.setTitleTextAttributes(normalFont, for: .normal)
        
        getRealmObjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        temperatureArray = []
        oxygenArray = []
        pulseArray = []
        breathArray = []
        getRealmObjects()
        tableView.reloadData()
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentMeasure = "temperature"
        case 1:
            currentMeasure = "oxygen"
        case 2:
            currentMeasure = "pulse"
        default:
            currentMeasure = "breath"
        }
        tableView.reloadData()
    }
    
    func getRealmObjects() {
        
        let notes = realm.objects(Note.self)
        
        for note in notes {
            
            switch note.measure {
            case "temperature":
                temperatureArray.append([note.date, note.value, note.note])
            case "oxygen":
                oxygenArray.append([note.date, note.value, note.note])
            case "pulse":
                pulseArray.append([note.date, note.value, note.note])
            default:
                breathArray.append([note.date, note.value, note.note])
            }
            
        }
        
        temperatureArray.reverse()
        oxygenArray.reverse()
        pulseArray.reverse()
        breathArray.reverse()
        
    }
    
    
}


//MARK: - UITableViewDataSource

extension NotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentMeasure {
        case "temperature":
            return temperatureArray.count
        case "oxygen":
            return oxygenArray.count
        case "pulse":
            return pulseArray.count
        default:
            return breathArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.measureImage.image = UIImage(named: currentMeasure)
        
        switch currentMeasure {
        case "temperature":
            cell.dateLabel.text = temperatureArray[indexPath.row][0]
            cell.valueLabel.text = temperatureArray[indexPath.row][1] + "°C"
        case "oxygen":
            cell.dateLabel.text = oxygenArray[indexPath.row][0]
            cell.valueLabel.text = oxygenArray[indexPath.row][1] + "%"
        case "pulse":
            cell.dateLabel.text = pulseArray[indexPath.row][0]
            cell.valueLabel.text = pulseArray[indexPath.row][1] + " beats per minute"
        default:
            cell.dateLabel.text = breathArray[indexPath.row][0]
            cell.valueLabel.text = breathArray[indexPath.row][1] + " breaths per minute"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notes = realm.objects(Note.self)
            for note in notes {
                
                switch currentMeasure {
                case "temperature":
                    if note.date == temperatureArray[indexPath.row][0] {
                        try! realm.write {
                            realm.delete(note)
                        }
                        temperatureArray.remove(at: indexPath.row)
                    }
                case "oxygen":
                    if note.date == oxygenArray[indexPath.row][0] {
                        try! realm.write {
                            realm.delete(note)
                        }
                        oxygenArray.remove(at: indexPath.row)
                    }
                case "pulse":
                    if note.date == pulseArray[indexPath.row][0] {
                        try! realm.write {
                            realm.delete(note)
                        }
                        pulseArray.remove(at: indexPath.row)
                    }
                default:
                    if note.date == breathArray[indexPath.row][0] {
                        try! realm.write {
                            realm.delete(note)
                        }
                        breathArray.remove(at: indexPath.row)
                    }
                }
                
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}


//MARK: - UITableViewDelegate

extension NotesViewController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "notesToWB" {
            let destination = segue.destination as! WellBeingViewController
            
            destination.fromNotes = true
            if let index = index {
                switch currentMeasure {
                case "temperature":
                    destination.measureString = "Temperature °C"
                    destination.dataArray = temperatureArray[index]
                case "oxygen":
                    destination.measureString = "Oxygen %"
                    destination.dataArray = oxygenArray[index]
                case "pulse":
                    destination.measureString = "Pulse per minute"
                    destination.dataArray = pulseArray[index]
                default:
                    destination.measureString = "Breaths per minute"
                    destination.dataArray = breathArray[index]
                }
                destination.measure = currentMeasure
                
                getCurrentNote(index)
                destination.note = self.note
            }
            
        }
    }
    
    func getCurrentNote(_ index: Int) {
        let notes = realm.objects(Note.self)
        for note in notes {
            
            switch currentMeasure {
            case "temperature":
                if note.date == temperatureArray[index][0]  {
                    self.note = note
                }
            case "oxygen":
                if note.date == oxygenArray[index][0]  {
                    self.note = note
                }
            case "pulse":
                if note.date == pulseArray[index][0]  {
                    self.note = note
                }
            default:
                if note.date == breathArray[index][0]  {
                    self.note = note
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.index = indexPath.row
        performSegue(withIdentifier: "notesToWB", sender: self)
    }
    
    
}
