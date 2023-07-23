//
//  settingsViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/16/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import WatchConnectivity

class settingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func signOutTapped(_ sender: UIButton)
    {
        let auth = Auth.auth()
        
        do
        {
            // clear goals on watch
            self.clearGoalsOnWatch()
            
            // sign out
            try auth.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: true)
            nav.modalPresentationStyle = .overFullScreen
//            self.navigationController?.pushViewController(vc, animated: true)
            self.present(nav, animated: true)
        }
        catch let signOutError
        {
            showAlert(withTitle: "Error", Message: signOutError.localizedDescription, controller: self)
        }
    }
    
    func clearGoalsOnWatch() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["ClearGoals": true], replyHandler: nil, errorHandler: nil)
        }
    }
    
}
