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

class GoalEditAndHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var goal: Goal?
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
        setdata()
        getHistories()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateGoals),
                                               name: Notification.Name("updateGoals"),
                                               object: nil)
    }
    
    
    @objc func updateGoals(notification: Notification) {
        getHistories()
        getupdatedGoalOBJ()
        setdata()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setdata()
    }
    
    
    private func setdata() {
        DispatchQueue.main.async
        {
            if let _goal = self.goal {
                self.goalName.text = _goal.goalName
                self.goalAmountSaved.text = "$" + _goal.amountCollectString
                
                
                if _goal.goalType == .basic {
                    self.customgoalView.isHidden = true
                    self.goalTypeImage.image = basicpiggyImage
                }
                else
                {
                    
                    
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
                    self.goalTypeImage.image = UIImage(named: "broken")
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
        
        let newRef = ref.child("Users").child(userID).child("goals").child("\(self.goal?.goalKey ?? "")").getData { error, snapshot in
            for child in snapshot!.children.allObjects as? [DataSnapshot] ?? [] {
                if let json = child.value as? [String: Any] {
                    
                    let goal = Goal(json: json)
                    
                    //self.goal = goal
                    DispatchQueue.main.async {
                        self.setdata()
                    }
                    dump(goal)
                    
                   
                    
                }
            }
        }

    }
    
    private func getHistories() {
        // Do any additional setup after loading the view.
        self.histories.removeAll()
        
        let ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        let newRef = ref.child("Users").child(userID).child("goals").child("\(self.goal?.goalKey ?? "")").child("Histories").getData { error, snapshot in
            for child in snapshot!.children.allObjects as? [DataSnapshot] ?? [] {
                if let json = child.value as? [String: Any] {
                    let goal = History(json: json)
                    //self.histories.append(goal)
                    self.histories.insert(goal, at: 0)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }

    }
    
    @IBAction func homeButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func takeFromPiggyButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WithdrawAmountViewController") as! WithdrawAmountViewController
        vc.goal = goal
        self.present(vc, animated: true)
    }
    
    @IBAction func breakPiggyButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BreakPiggyViewController") as! BreakPiggyViewController
        //get the goal from the breakPiggy VC
        vc.goal = goal
        self.present(vc, animated: true)
    }
    
    
    @IBAction func savebutton(_ sender: UIButton) {
        let amount = enteramountF.text ?? ""
        let amountInDouble = Double(amount) ?? 0.0
        let updatedAmount = amountInDouble + (goal?.totalAmountCollected ?? 0.0)
        let ref = Database.database().reference()
        
        self.goal?.totalAmountCollected = updatedAmount
        self.goal?.amountCollectString = "\(updatedAmount)"
        
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        ref.child("Users").child(userID).child("goals").child("\(goal?.goalKey ?? "")").child("amountCollected").setValue("\(updatedAmount)") { err, reef in
            
            self.goalAmountSaved.text = "$\(updatedAmount)"
            
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
                    NotificationCenter.default.post(name: Notification.Name("updateGoals"), object: nil, userInfo: [:])
                    //self.navigationController?.popViewController(animated: true)
                    self.goal?.totalAmountCollected = updatedAmount
                    self.goal?.amountCollectString = updatedAmount.description
                    self.setdata()
                    self.enteramountF.text?.removeAll()
                }
                
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
