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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func createAccountButton(_ sender: Any)
    {
        if isValidData()
        {
            //Do the firebase Authentication
            
            let email = emailTF.text ?? ""
            let password = passwordTF.text ?? ""
            let name = userNameTF.text ?? ""
            
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
            
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                //create user is a method of fire base which is responsable for creating a user and it also retrns a completion handler/ function
                //that function is result and error
                //if the creation is succesful then the result parameter will have a user object and that user object is a reference to the user which we created
                //if it failed then  the error object will have a value
                
                //if there is a value in the user
                if let user = result?.user {
                    //Account Created
                    //create reference to the firebase database
                    let ref = Database.database().reference()
                    //create hiarchy
                    //
                    let dataobj = [
                        "username": name,
                        "email": email,
                        "goals": "Car"
                        
                    ]
                    ref.child("Users").child(user.uid).setValue(dataobj) { err, ref in
                        
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                        
                        if let error = err {
                            showAlert(withTitle: "", Message: error.localizedDescription, controller: self)
                        }
                        else
                        {
                            //alert the user that acount was created then nav to the next screen
                            let userCreatedAlert = UIAlertController(title: "", message: "Account created successfully", preferredStyle: .alert)  //<-- KEEP TRYING!!!!!!
                            
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
                                let SB = UIStoryboard(name: "Main", bundle: nil)
                                let vc = SB.instantiateViewController(withIdentifier: "TabBarController")
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true)
                                
                            })
                            
                            userCreatedAlert.addAction(ok)
                            
                            self.present(userCreatedAlert, animated: true)
                            
                        }
                        
                    }}
                else
                {
                    showAlert(withTitle: "", Message: error?.localizedDescription ?? "Server Error", controller: self)
                }
                
            }
            
        }
    }
    
   
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
//    {
//        if successfulSignIn == true
//        {
//            return true
//        }
//        return false
//    }
    
}
