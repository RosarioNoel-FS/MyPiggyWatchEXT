//
//  GoalSelectionViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 11/28/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class GoalSelectionViewController: UIViewController {
    //Both Goal Buttons
    @IBOutlet weak var basicGoalButton: UIButton!
    @IBOutlet weak var customGoalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //When this button is pressed Nav to basic goal form page
    @IBAction func BasicGoalButtonTapped(_ sender: Any)
    {
        performSegue(withIdentifier: "basicButtonNav", sender: self)
    }
    
    
    //When this button is pressed Nav to custom goal form page
    @IBAction func customGoalButtonTapped(_ sender: Any)
    {
        performSegue(withIdentifier: "customButtonNav", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backToHomeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
   
    
    
}
