//
//  BreakPiggyViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/11/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class BreakPiggyViewController: UIViewController {

    
    var goal: Goal?
    
    @IBOutlet weak var breakimageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func breakPiggy(_ sender: UIButton) {
        let ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        let newRef = ref.child("Users").child(userID).child("goals").child("\(goal?.goalKey ?? "")").child("isBroken").setValue(true) { err, ref in
            
            if let error = err {
                showAlert(withTitle: "", Message: error.localizedDescription, controller: self)
            }
            else
            {
                self.goal?.isBroken = true
                
                NotificationCenter.default.post(name: Notification.Name("updateGoals"), object: nil, userInfo: [:])
                
                self.dismiss(animated: true)
            }
            
        }
    }
    
    
    @IBAction func continueSavingButton(_ sender: UIButton) {
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
