//
//  GoalEditAndHistoryViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/10/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import WatchConnectivity

  
class GoalEditAndHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var goal: Goal?
    @IBOutlet weak var goalTypeImageBottomConstraint: NSLayoutConstraint?

    
    private var histories = [History]()
    
    
    @IBOutlet weak var goalPercentageLabel: UILabel!
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalAmountSaved: UILabel!
    @IBOutlet weak var goalTypeImage: UIImageView!
    @IBOutlet weak var takefrompiggyView: UIView!
    @IBOutlet weak var breakfrompiggyview: UIView!
    @IBOutlet weak var enteramountF: UITextField!
    @IBOutlet weak var customgoalView: UIView!
    @IBOutlet weak var goalTotalTargetLabel: UILabel!
    @IBOutlet weak var goalpercentagelabel: UILabel!
    @IBOutlet weak var enterAmonutView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up the view and load data
        setdata()
        getHistories()
       
        // Add an observer to update goals when a notification is received
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateGoals),
                                               name: Notification.Name("updateGoals"),
                                               object: nil)
    }
    
    @objc func updateGoals(notification: Notification) {
        
        // Update goals when a notification is received
        
        getHistories()
        getupdatedGoalOBJ()
        setdata()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Update the view when it appears
        setdata()
    }
    
    
    private func setdata() {
        DispatchQueue.main.async
        {
            if let _goal = self.goal {
                
                // Set up the data for goal display
                self.goalName.text = _goal.goalName
                self.goalAmountSaved.text = "$" + _goal.amountCollectString
                
                
                if _goal.goalType == .basic {
                    
                    // Hide custom goal elements for basic goals
                    self.customgoalView.isHidden = true
                    self.goalTypeImage.image = basicpiggyImage
                }
                else
                {
                    // Show custom goal elements for custom goals
                    self.goalTotalTargetLabel.text = "$" + _goal.goalTotal
                    let percentage = _goal.totalAmountCollected / _goal.goalTotalAmount
                    let precentageInDouble = percentage * 100.0
                    var percent = ""
                    
                    
                    
                    self.goalpercentagelabel.text = String.init(format: "%.2f", CGFloat(precentageInDouble)) + "%"
                    //self.goalpercentagelabel.text

                    
                    self.customgoalView.isHidden = false
                    self.goalTypeImage.image = custompiggyImage
                }
                
                if _goal.isBroken {
                    
                    // Hide elements for broken goals
                    self.goalTypeImage.image = UIImage(named: "broken")
                    
                    
                    
                    
                    // Add new constraint with 30 points of space to the tableView
                    self.goalTypeImageBottomConstraint = self.goalTypeImage.bottomAnchor.constraint(equalTo: self.tableView.topAnchor, constant: -30)
                    self.goalTypeImageBottomConstraint?.isActive = true

                    
                    self.takefrompiggyView.isHidden = true
                    self.breakfrompiggyview.isHidden = true
                    self.enterAmonutView.isHidden = true
                    self.goalTotalTargetLabel.isHidden = true
                    self.goalpercentagelabel.isHidden = true
                    self.goalPercentageLabel.isHidden = true
                    self.goalTitleLabel.isHidden = true
                    
                }
        }
           
    }
        
}
    
    private func getupdatedGoalOBJ()
    {
        let ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        // Retrieve the updated goal object from the database
        let newRef = ref.child("Users").child(userID).child("goals").child("\(self.goal?.goalKey ?? "")").getData { error, snapshot in
            for child in snapshot!.children.allObjects as? [DataSnapshot] ?? [] {
                if let json = child.value as? [String: Any] {
                    
                    let goal = Goal(json: json)
                    
                    DispatchQueue.main.async {
                        // Update the goal object and refresh the view
                        self.setdata()
                    }
                    dump(goal)
                    
                   
                    
                }
            }
        }

    }
    
    private func getHistories() {
        // Clear the histories array
        self.histories.removeAll()
        
        let ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        // Retrieve the histories for the goal from the database
        let newRef = ref.child("Users").child(userID).child("goals").child("\(self.goal?.goalKey ?? "")").child("Histories").getData { error, snapshot in
            for child in snapshot!.children.allObjects as? [DataSnapshot] ?? [] {
                if let json = child.value as? [String: Any] {
                    let goal = History(json: json)
                    self.histories.insert(goal, at: 0)
                    
                    DispatchQueue.main.async {
                        
                        // Reload the table view to display the histories
                        self.tableView.reloadData()
                    }
                }
            }
        }

    }
    
    @IBAction func homeButtonAction(_ sender: UIButton) {
       
        // Pop the current view controller from the navigation stack to go back to the previous view controller
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func takeFromPiggyButton(_ sender: UIButton) {
        // Instantiate the WithdrawAmountViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WithdrawAmountViewController") as! WithdrawAmountViewController
        
        // Pass the goal object to the WithdrawAmountViewController
        vc.goal = goal
        
        // Present the WithdrawAmountViewController modally
        self.present(vc, animated: true)
    }
    
    @IBAction func breakPiggyButton(_ sender: UIButton) {
        // Instantiate the BreakPiggyViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BreakPiggyViewController") as! BreakPiggyViewController
       
        // Pass the goal object to the BreakPiggyViewController
        vc.goal = goal
        
        // Present the BreakPiggyViewController modally
        self.present(vc, animated: true)
    }
    
    
    @IBAction func savebutton(_ sender: UIButton) {
        // Get the amount entered in the text field
        let amount = enteramountF.text ?? ""
        let amountInDouble = Double(amount) ?? 0.0
        
        // Calculate the updated amount by adding the entered amount to the total amount collected
        let updatedAmount = amountInDouble + (goal?.totalAmountCollected ?? 0.0)
        let ref = Database.database().reference()
        
        // Update the goal's total amount collected and amount collected string
        self.goal?.totalAmountCollected = updatedAmount
        self.goal?.amountCollectString = "\(updatedAmount)"
        
        // Retrieve the currently logged-in user's UID
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        // Set the updated amount in the database
        ref.child("Users").child(userID).child("goals").child("\(goal?.goalKey ?? "")").child("amountCollected").setValue("\(updatedAmount)") { err, reef in
            
            // Update the UI with the updated amount
            self.goalAmountSaved.text = "$\(updatedAmount)"
            
            
            // Add a new history entry for the save operation
            let newRef = ref.child("Users").child(userID).child("goals").child("\(self.goal?.goalKey ?? "")").child("Histories").childByAutoId()
            newRef.setValue([
             "saveAmount" : amount,
             "key" : newRef.key,
             "date": getCurrentDate(),
             "totalBalance": "\(updatedAmount)",
             "isWithdrawl": false
            ]) { err, reef in
                
                if let error = err {
                    showAlert(withTitle: "", Message: error.localizedDescription, controller: self)
                }
                else
                {
                    // Post a notification to update the goals
                    NotificationCenter.default.post(name: Notification.Name("updateGoals"), object: nil, userInfo: [:])

                    // Update the goal's total amount collected and amount collected string
                    self.goal?.totalAmountCollected = updatedAmount
                    self.goal?.amountCollectString = updatedAmount.description
                    
                    // Update the UI and clear the text field
                    self.setdata()
                    self.enteramountF.text?.removeAll()
                }
                
            }
        }
        
        // After the goal has been updated in the database, send it to the watch
                if let updatedGoal = self.goal {
                    print("WCSession is reachable. Transferring data.")
                    self.sendGoalToWatch(goal: updatedGoal)
                }
        
    }
    
    func sendGoalToWatch(goal: Goal) {
        if WCSession.default.isReachable {
            do {
                //Check Reachability:[DEBUG]
                print("WCSession is reachable. Transferring data.")
                
                let goalData = try JSONEncoder().encode(goal)
                let goalDictionary = ["GoalData": goalData]
                
                WCSession.default.sendMessage(goalDictionary, replyHandler: nil, errorHandler: nil)
                
                //Check Data Transfer[DEBUG]
               // let transfer = WCSession.default.transferUserInfo(goalDictionary)
               // print("Data transfer started: \(transfer.isTransferring)")

            } catch {
                print("Failed to encode goal with error: \(error)")
            }
        }
        else
        {
            //Check Reachability:[DEBUG]
            print("WCSession is not reachable.")

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set the height for each row in the table view
        return 86
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the table view based on the number of histories
        return self.histories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure and return the cell for each row in the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath) as! WithdrawHistoryCell
        if indexPath.row < histories.count
        {
            cell.setData(history: histories[indexPath.row])
        }
        return cell
    }
}





func getCurrentDate() -> String {
    let date = Date()
    let format = date.getFormattedDate(format: "MMM d") // Set output format
    return format
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
