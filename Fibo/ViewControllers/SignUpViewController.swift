//
//  SignUpViewController.swift
//  Fibo
//
//  Created by iFARA💻 on 19.04.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
    }
    
    func setUpElements() {
        
        //hide the error label
        errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    //check the fields and validate that the data is correct. If everything is correct, this methods returns nil. Otherwise, it returns the error message.
    func validateFields() -> String? {
        
        //check that all fields correct filled
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        //check is the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //password is not secure enough
            return "Please make sure you password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //valideate the fields
        let error = validateFields()
        
        if error != nil {
            
            //there's something wrong with the fields , show error message
            showError(error!)
            
        } else {
            
            //create cleaned version of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil {
                    
                    //                    err.localizedDescription - встроенная возможность показать ошибку
                    
                    //there was an error on creating user account
                    self.showError("Error creating user")
                } else {
                    //creating user account was succesfully and we store the first and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstName": firstName, "lastName": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            //show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    //transition to the home screen
                    self.transitionToHome()
                    
                }
                
            }
            
        }
        
        
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}


