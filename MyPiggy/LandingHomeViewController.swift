//
//  LandingHomeViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 11/27/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
//Noel !!!!!!!!!

class LandingHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    
    @IBOutlet weak var myGoalsView: UIView!
    
    
    
    @IBOutlet weak var loadingindicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var goalTableView: UITableView!
    
    @IBOutlet weak var homeImage: UIImageView!
    
    var hasAGoal = false
    
    var goals = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTableView.dataSource = self
        goalTableView.delegate = self
        
        //edit turns on "SELECT MODE"       || how to select multi[le cells
        //tableView.allowsMultipleSelectionDuringEditing = true  //<-------
        
        
        fetchgoals()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateGoals),
                                               name: Notification.Name("updateGoals"),
                                               object: nil)
        
        
        
        
        
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        self.goalTableView.reloadData()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.goalTableView.reloadData()
    }
        
    
    
    
    @objc func updateGoals(notification: Notification) {
        fetchgoals()
    }
    // get all the goals from the user
    private func fetchgoals() {
        // Do any additional setup after loading the view.
        //clear all goals
        self.goals.removeAll()
        loadingindicator.isHidden = false
        loadingindicator.startAnimating()
        // get reference to the database
        let ref = Database.database().reference()
        //get current user ID
        let userID = Auth.auth().currentUser?.uid ?? ""
        // reference to the goals
        
        let newRef = ref.child("Users").child(userID).child("goals").getData { error, snapshot in
            for child in snapshot!.children.allObjects as? [DataSnapshot] ?? [] {
                //if there is a value in the child cast as dictionary
                if let json = child.value as? [String: Any] {
                    //passin the dictionary of goal data into our goal obj
                    let goal = Goal(json: json)
                    
                    //add the new goal to our goals array
                    //self.goals.append(goal) <=---------CHANGED THIS
                    self.goals.insert(goal, at: 0) //<------New Line
                    DispatchQueue.main.async {
                        self.goalTableView.reloadData()
                    }
                }
            }
            
            self.loadingindicator.stopAnimating()
            if self.goals.count != 0
            {
                self.myGoalsView.isHidden = false
                self.homeImage.isHidden = true
            }
            else
            {
                self.myGoalsView.isHidden = true
                self.homeImage.isHidden = false
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goals.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set up cell with reusable ID
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalListCell", for: indexPath) as! GoalListCell
        
        if indexPath.row < goals.count
        {
            
            cell.setData(goal: goals[indexPath.row])

        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let goal = self.goals[indexPath.row]
        //line 114 - 116 nav to GoalEditAndHistoryViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GoalEditAndHistoryViewController") as! GoalEditAndHistoryViewController
        // assigning goal obj to our destination view controller
        vc.goal = goal
        //presenting a nav controller
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        nav.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(vc, animated: true)

        //self.present(nav, animated: true)
    }
    
    @IBAction func openPlusAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GoalSelectionViewController")
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(nav, animated: true)
    }
    
}

