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
                }
                
            }}
           
        
        
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
