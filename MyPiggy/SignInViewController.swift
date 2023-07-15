//
//  SignInViewController.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

var hasAGoal = false

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func isValidData() -> Bool {
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        
        if email.isEmpty {
            showAlert(withTitle: "Error", Message: "Please enter email", controller: self)
            return false
            
        } else if password.isEmpty {
            showAlert(withTitle: "Error", Message: "Please enter password", controller: self)
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
    @IBAction func SignInButtonTapped(_ sender: Any)
    {
        if isValidData() {
            
            let email = emailTF.text ?? ""
            let password = passwordTF.text ?? ""
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    showAlert(withTitle: "Error", Message: "\(error.localizedDescription)", controller: self)
                } else
                {
                    if hasAGoal
                    {
                        ////showAlert(withTitle: "Success", Message: "Logged In Successfully", controller: self)
                        let userCreatedAlert = UIAlertController(title: "", message: "Logged In successfully", preferredStyle: .alert)  //<-- KEEP TRYING!!!!!!

                        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
                            let SB = UIStoryboard(name: "Main", bundle: nil)
                            let vc = SB.instantiateViewController(withIdentifier: "TabBarController")
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true)

                       })
                        
                        userCreatedAlert.addAction(ok)

                        self.present(userCreatedAlert, animated: true)
                        
                    }
                    else
                    {
                        //showAlert(withTitle: "Success", Message: "Logged In Successfully", controller: self)
                        let userCreatedAlert = UIAlertController(title: "", message: "Logged In successfully", preferredStyle: .alert)  //<-- KEEP TRYING!!!!!!

                        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
                            let SB = UIStoryboard(name: "Main", bundle: nil)
                            let vc = SB.instantiateViewController(withIdentifier: "TabBarController")
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true)

                       })
                        
                        userCreatedAlert.addAction(ok)

                        self.present(userCreatedAlert, animated: true)
                    }
                    
                }
            }
        }
        
    }
    
}
