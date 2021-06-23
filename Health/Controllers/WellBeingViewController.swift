//
//  WellBeingViewController.swift
//  Health
//
//  Created by Даниил Марусенко on 04.02.2021.
//

import UIKit
import RealmSwift

class WellBeingViewController: UIViewController {
    
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var measureLabel: UILabel!
    @IBOutlet var measureImage: UIImageView!
    @IBOutlet var valueTextField: UITextField!
    
    let realm = try! Realm()
    var value: Double?
    var measure: String?
    var measureString: String?
    var currentMeasure = "body temperature"
    var dataArray = [String]()
    var fromNotes = false
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
        
        if let maesure = measure, let measureString = measureString {
            measureImage.image = UIImage(named: maesure)
            measureLabel.text = measureString
        }
        
        valueTextField.layer.borderWidth = 1
        valueTextField.layer.cornerRadius = 12
        if let value = value {
            valueTextField.text = String(value)
        }
        
        backButtonView.alpha = 0.7
        backButtonView.layer.cornerRadius = 12
        saveButtonView.alpha = 0.7
        saveButtonView.layer.cornerRadius = 12
        noteTextField.layer.borderWidth = 1
        noteTextField.layer.cornerRadius = 12
        
        if fromNotes {
            let stringDate = dataArray[0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM, HH:mm"
            if let date = dateFormatter.date(from: stringDate) {
                datePicker.date = date
            }
            valueTextField.text = dataArray[1]
            noteTextField.text = dataArray[2]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fromNotes = false
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        valueTextField.inputAccessoryView = doneToolbar
        noteTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        valueTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let newNote = Note()
        
        if let value = Double(valueTextField.text!) {
            switch measure {
            case "temperature":
                currentMeasure = "body temperature"
                if 34.0 <= value && value <= 44.0 {
                    if fromNotes {
                        editObject(note: self.note, value: value)
                    } else {
                        newNote.value = String(value)
                        addObjects(note: newNote)
                    }
                } else {
                    performAlert()
                }
            case "oxygen":
                currentMeasure = "oxygen blood level"
                if 40 <= value && value <= 100 {
                    if fromNotes {
                        editObject(note: self.note, value: value)
                    } else {
                        newNote.value = String(value)
                        addObjects(note: newNote)
                    }
                } else {
                    performAlert()
                }
            case "pulse":
                currentMeasure = "pulse"
                if 40 <= value && value <= 200 {
                    if fromNotes {
                        editObject(note: self.note, value: value)
                    } else {
                        newNote.value = String(value)
                        addObjects(note: newNote)
                    }
                } else {
                    performAlert()
                }
            case "breath":
                currentMeasure = "breathe rate"
                if 1 <= value && value <= 100 {
                    if fromNotes {
                        editObject(note: self.note, value: value)
                    } else {
                        newNote.value = String(value)
                        addObjects(note: newNote)
                    }
                } else {
                    performAlert()
                }
            default:
                return
            }
        } else {
            currentMeasure = "value"
            performAlert()
        }
                
        realm.beginWrite()
        realm.add(newNote)
        try! realm.commitWrite()
        
        let alert = UIAlertController(title: nil, message: "You've successfully added a new measure!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func editObject(note: Note?, value: Double) {
        if fromNotes {
            if let note = note {
                realm.beginWrite()
                note.value = String(value)
                addObjects(note: note)
                try! realm.commitWrite()
                
            }
        }
    }
    
    func performAlert() {
        let alert = UIAlertController(title: nil, message: "Please, enter correct \(currentMeasure)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addObjects(note: Note) {
        let date = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        note.date = formatter.string(from: date)
        note.note = noteTextField.text!
        
        if let measure = measure {
            note.measure = measure
        }
    }
    
}
