//
//  WithdrawAmountViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/11/22.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class WithdrawAmountViewController: UIViewController {

    @IBOutlet weak var enteramountTF: UITextField!
    var goal: Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        let amount = enteramountTF.text ?? ""
        let amountInDouble = Double(amount) ?? 0.0
        
        
        if let _goal = self.goal {
            if amountInDouble < _goal.totalAmountCollected {
                
                let updatedAmount = (goal?.totalAmountCollected ?? 0.0) - amountInDouble
                
                let userID = Auth.auth().currentUser?.uid ?? ""
                let ref = Database.database().reference()
                
                ref.child("Users").child(userID).child("goals").child("\(goal?.goalKey ?? "")").child("amountCollected").setValue("\(updatedAmount)") { err, reef in
                    
                    
                    
                    let newRef = ref.child("Users").child(userID).child("goals").child("\(self.goal?.goalKey ?? "")").child("Histories").childByAutoId()
                    newRef.setValue([
                     "saveAmount" : amount,
                     "key" : newRef.key,
                     "date": getCurrentDate(),
                     "totalBalance": "\(updatedAmount)",
                     "isWithdrawl": true
                    ])
                        { err, reef in
                        
                        if let error = err
                        {
                            showAlert(withTitle: "", Message: error.localizedDescription, controller: self)
                        }
                        else
                        {
                            self.goal?.amountCollectString = updatedAmount.description
                            self.goal?.totalAmountCollected = updatedAmount
                            NotificationCenter.default.post(name: Notification.Name("updateGoals"), object: nil, userInfo: [:])
                            self.dismiss(animated: true)
                        }
                        
                    }
                }
                

            }
            else
            {
                showAlert(withTitle: "", Message: "You entered amount greater than your saving amount", controller: self)
            }
        }
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
        
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
