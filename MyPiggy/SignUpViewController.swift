//
//  SignUpViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 11/29/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import WatchConnectivity

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var successfulSignIn = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadingIndicator.isHidden = true
    }
    
    private func isValidData() -> Bool {
        let name = userNameTF.text ?? ""
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        let confirmPassword = confirmPasswordTF.text ?? ""
        //Validation for sign up proccess
        if name.isEmpty {
            showAlert(withTitle: "Error", Message: "Please enter username", controller: self)
            return false
        } else if email.isEmpty {
            showAlert(withTitle: "Error", Message: "Please enter email", controller: self)
            return false
            
        } else if password.isEmpty {
            showAlert(withTitle: "Error", Message: "Please enter password", controller: self)
            return false
        } else if confirmPassword.isEmpty {
            showAlert(withTitle: "Error", Message: "Please enter confirm password", controller: self)
            return false
            
        } else if password.count < 6 {
            showAlert(withTitle: "Error", Message: "password should be greater than 6 characters", controller: self)
            return false
            
        } else if confirmPassword != password {
            showAlert(withTitle: "Error", Message: "Passwords do not match", controller: self)
            return false
        }
        
        return true
    }
  
    
    
    @IBAction func createAccountButton(_ sender: Any) {
        if isValidData() {
            // Do the Firebase Authentication
            let email = emailTF.text ?? ""
            let password = passwordTF.text ?? ""
            let name = userNameTF.text ?? ""
            
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                // Stop the loading indicator whether the request was successful or not
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                
                // Check if user creation was successful
                if let user = result?.user {
                    
                    // Send the UserID to the watch if the watch is reachable
                    if WCSession.default.isReachable {
                        let message = ["UserID": user.uid]
                        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
                    }
                    // Account created, create reference to the Firebase database
                    let ref = Database.database().reference()
                    // Create hierarchy
                    let dataobj = [
                        "username": name,
                        "email": email,
                        "goals": "Car"
                    ]
                    ref.child("Users").child(user.uid).setValue(dataobj) { err, _ in
                        // Check if there was an error
                        if let error = err {
                            showAlert(withTitle: "", Message: error.localizedDescription, controller: self)
                        } else {
                            // Alert the user that the account was created then navigate to the next screen
                            let userCreatedAlert = UIAlertController(title: "", message: "Account created successfully", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
                                let SB = UIStoryboard(name: "Main", bundle: nil)
                                let vc = SB.instantiateViewController(withIdentifier: "TabBarController")
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true)
                            })
                            userCreatedAlert.addAction(ok)
                            
                            // Send the UserID to the watch if the watch is reachable
                            if WCSession.default.isReachable {
                                let message = ["UserID": user.uid]
                                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
                            }
                            
                            self.present(userCreatedAlert, animated: true)
                        }
                    }
                } else {
                    // User creation failed, show an error message
                    showAlert(withTitle: "", Message: error?.localizedDescription ?? "Server Error", controller: self)
                }
            }
        }
    }

    
   

    
}
