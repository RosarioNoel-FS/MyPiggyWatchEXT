//
//  CustomGoalViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/4/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

//Noel !!!!!!!!!
enum SavingType: String {
    case daily = "Daily"
    case weekly = "Weekly"
    case biWeeekly = "Bi-Weekly"
    case monthly = "Monthly"
}

class CustomGoalViewController: UIViewController {
    
    private var selectedDate = Date()
    
    private var savingType: SavingType = .daily

    @IBOutlet weak var goalNameTF: UITextField!
    
    @IBOutlet weak var goalTotalTF: UITextField!
    
    @IBOutlet weak var savingSegment: UISegmentedControl!
    
    @IBOutlet weak var goalDatePicker: UIDatePicker!
    
    @IBOutlet weak var amountNeededToReachGoal: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
        
        
        
        goalDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        goalDatePicker.addTarget(self, action: #selector(handleDatePicker), for: UIControl.Event.valueChanged)
    }
    
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
    
    
    @objc
    func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.selectedDate = sender.date
        
        updateAmountNeededToReachGoal()
    }
    
    
    @IBAction func createButtonTapped(_ sender: Any)
    {
        if isValidData() {
            let goalName = goalNameTF.text ?? ""
            let goalTotal = goalTotalTF.text ?? ""
            
            let savingType = self.savingType.rawValue
            let goalType = "Custom"
            let goalCompletionDate = selectedDate.getFormattedDate(format: "MMM d, yyyy")
            
            
            let ref = Database.database().reference()
            // get current user id from firebase auth object
            let userID = Auth.auth().currentUser?.uid ?? ""
            //seting up the goals child object
            let newRef = ref.child("Users").child(userID).child("goals").childByAutoId()
            
            //give values to the child
            newRef.setValue([
             "goalName" : goalName,
             "key" : newRef.key,
             "type": "Custom",
             "isBroken": false,
             "amountCollected": "0.0",
             "goalTotal": "\(goalTotal)",
             "savingType": savingType,
             "completionDate": goalCompletionDate
             
            ]){ err, ref in
                
                if let error = err {
                    showAlert(withTitle: "", Message: error.localizedDescription, controller: self)
                }
                else
                {

                    NotificationCenter.default.post(name: Notification.Name("updateGoals"), object: nil, userInfo: [:])
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl)
    {
        // this var contains the days between the current date and the selected date
        let days = Calendar.current.dateComponents([.day], from: Date(), to: selectedDate).day ?? 0
        // selection from segmented control
        let selectedIndex = sender.selectedSegmentIndex
        
        if days < 7 && (selectedIndex == 1 || selectedIndex == 2 || selectedIndex == 3) {
            savingType = .daily
            showAlert(withTitle: "", Message: "Days are less than 7. We cannot select", controller: self)
            savingSegment.selectedSegmentIndex = 0
        } else if days < 14 && (selectedIndex == 2 || selectedIndex == 3) {
            savingType = .daily
            savingSegment.selectedSegmentIndex = 0 //<==daily is the default
            showAlert(withTitle: "", Message: "Days are less than 14. We cannot select", controller: self)
        } else if days < 30 &&  selectedIndex == 3 {
            savingType = .daily
            savingSegment.selectedSegmentIndex = 2
            showAlert(withTitle: "", Message: "Days are less than 30. We cannot select", controller: self)
        } else {
            switch selectedIndex {
            case 0 :
                savingType = .daily
            case 1 :
                savingType = .weekly
            case 2 :
                savingType = .biWeeekly
            case 3 :
                savingType = .monthly
            default:
                savingType = .daily
            }
        }
        
        // handles calculation
        updateAmountNeededToReachGoal()
    }
    
    
    private func updateAmountNeededToReachGoal() {
        // this var contains the days between the current date and the selected date
        let days = Calendar.current.dateComponents([.day], from: Date(), to: selectedDate).day ?? 0
        var value: CGFloat = 0
        // casted the entered value as a CGFloat
        let enteredValue = CGFloat(Int(goalTotalTF.text ?? "") ?? 0)
        
        if enteredValue > 0 {
            if savingType == .daily {
                let totalDays = days / 1
                value = enteredValue / CGFloat(totalDays)
                
                
            } else if savingType == .weekly {
                let totalWeeks = days / 7
                value = enteredValue / CGFloat(totalWeeks)
                
                
            } else if savingType == .biWeeekly {
                let totalBiWeeks = days / 14
                value = enteredValue / CGFloat(totalBiWeeks)
                
            } else {
                let totalMonths = days / 30
                value = enteredValue / CGFloat(totalMonths)
            }
            
            self.amountNeededToReachGoal.text = String.init(format: "$%.2f", value)
        }
    }
    
    
    private func isValidData() -> Bool {
        let name = goalNameTF.text ?? ""
        let totalTF = goalTotalTF.text ?? ""
        
        if name.isEmpty {
            showAlert(withTitle: "", Message: "Please enter goal name", controller: self)
            return false
            
        } else if totalTF.isEmpty {
            showAlert(withTitle: "", Message: "Please enter goal total", controller: self)
            return false
            
        }
        
        return true
    }
    

}

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


