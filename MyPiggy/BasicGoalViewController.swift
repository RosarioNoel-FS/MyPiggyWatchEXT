//
//  BasicGoalViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/4/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import WatchConnectivity




class BasicGoalViewController: UIViewController {

    @IBOutlet weak var goalNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func createPiggyBankTapped(_ sender: Any)
    {
        if isValidData()
         {
            let ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid ?? ""
            let newRef = ref.child("Users").child(userID).child("goals").childByAutoId()
            
            newRef.setValue([
             "goalName" : goalNameTF.text!,
             "key" : newRef.key,
             "isBroken": false,
             "type": "Basic",
             "amountCollected": "0.0"
            ]){ err, ref in
                
                if let error = err {
                    showAlert(withTitle: "", Message: error.localizedDescription, controller: self)
                }
                else
                {

                    NotificationCenter.default.post(name: Notification.Name("updateGoals"), object: nil, userInfo: [:])
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    // Create a dictionary representing the new goal
                                    let newGoalDict: [String: Any] = [
                                        "key": newRef.key!,
                                        "goalName": self.goalNameTF.text!,
                                        "isBroken": false,
                                        "amountCollected": "0.0",
                                        "type": "Basic",
                                        "goalTotal": "0.0",
                                        "savingType": "",
                                        "completionDate": ""
                                    ]
                                    // Initialize a new Goal object
                                    let newGoal = Goal(json: newGoalDict)
                                    // Send the new goal to the watch
                                    self.sendGoalToWatch(goal: newGoal)
                }
                
            }}
    }
    
    func sendGoalToWatch(goal: Goal) {
        if WCSession.default.isWatchAppInstalled {
            do {
                let goalData = try JSONEncoder().encode(goal)
                WCSession.default.sendMessageData(goalData, replyHandler: nil, errorHandler: { (error) in
                    print("Failed to send data to watch. Error: \(error.localizedDescription)")
                })
            } catch {
                print("Failed to encode goal. Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func isValidData() -> Bool {
        let goalTF = goalNameTF.text ?? ""
        //Validation for sign up proccess
        if goalTF.isEmpty {
            showAlert(withTitle: "Error", Message: "Please enter goal name!", controller: self)
            return false
        }
        
        return true
    }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
