//
//  ViewController.swift
//  Health
//
//  Created by Даниил Марусенко on 02.02.2021.
//

import UIKit

class MeasureViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var measureTF: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signImage: UIImageView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var inputContainerView: UIView!
    
    var currentMeasure = "body temperature"
    var value: Double?
    var measure: String?
    var measureString: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addDoneButtonOnKeyboard()
        titleLabel.adjustsFontSizeToFitWidth = true
        signLabel.alpha = 0.5
        addView.layer.cornerRadius = 50
        inputContainerView.layer.cornerRadius = 30
        makeShadow(addView)
        makeShadow(inputContainerView)
        
        let selectedFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor:UIColor.black]
        segmentedControl.setTitleTextAttributes(selectedFont, for: .selected)
        let normalFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:UIColor.white]
        segmentedControl.setTitleTextAttributes(normalFont, for: .normal)
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        measureTF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        measureTF.resignFirstResponder()
    }

    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentMeasure = "body temperature"
            titleLabel.text = "My temperature"
            signLabel.text = "°C"
            signImage.image = UIImage(named: "temperature")
        case 1:
            currentMeasure = "oxygen blood level"
            titleLabel.text = "My oxygen blood level"
            signLabel.text = "%"
            signImage.image = UIImage(named: "oxygen")
        case 2:
            currentMeasure = "pulse"
            titleLabel.text = "My pulse"
            signLabel.text = "Beats per minute "
            signImage.image = UIImage(named: "pulse")
        case 3:
            currentMeasure = "breathe rate"
            titleLabel.text = "My breathe rate"
            signLabel.text = "Breaths per minute "
            signImage.image = UIImage(named: "breath")
        default:
            return
        }
    }
    
    @IBAction func inputPressed(_ sender: UIButton) {
        measureTF.becomeFirstResponder()
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        if measureTF.text == "" {
            measureTF.becomeFirstResponder()
        } else {
            if let value = Double(measureTF.text!) {
                
                switch segmentedControl.selectedSegmentIndex {
                case 0:
                    if 34.0 <= value && value <= 44.0 {
                        self.value = value
                        measureTF.text = ""
                        measure = "temperature"
                        measureString = "Temperature °C"
                        performSegue(withIdentifier: "measureToWB", sender: self)
                    } else {
                        performAlert()
                    }
                case 1:
                    if 40 <= value && value <= 100 {
                        self.value = value
                        measureTF.text = ""
                        measure = "oxygen"
                        measureString = "Oxygen %"
                        performSegue(withIdentifier: "measureToWB", sender: self)
                    } else {
                        performAlert()
                    }
                case 2:
                    if 40 <= value && value <= 200 {
                        self.value = value
                        measureTF.text = ""
                        measure = "pulse"
                        measureString = "Pulse per minute"
                        performSegue(withIdentifier: "measureToWB", sender: self)
                    } else {
                        performAlert()
                    }
                case 3:
                    if 1 <= value && value <= 100 {
                        self.value = value
                        measureTF.text = ""
                        measure = "breath"
                        measureString = "Breaths per minute"
                        performSegue(withIdentifier: "measureToWB", sender: self)
                    } else {
                        performAlert()
                    }
                default:
                    return
                }

            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "measureToWB" {
            let destinationVC = segue.destination as! WellBeingViewController
            if let value = self.value {
                destinationVC.value = value
                destinationVC.measure = measure
                destinationVC.measureString = measureString
            }
        }
    }
    
    func performAlert() {
        let alert = UIAlertController(title: nil, message: "Please, enter correct \(currentMeasure)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 3
    }
    
}
