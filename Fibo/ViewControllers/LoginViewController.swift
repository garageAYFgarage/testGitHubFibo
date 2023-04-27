//
//  LoginViewController.swift
//  Fibo
//
//  Created by iFARA💻 on 19.04.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
    }
    
    func setUpElements() {
        
        //hide the error label
        errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
    }
    
    //check the fields and validate that the data is correct. If everything is correct, this methods returns nil. Otherwise, it returns the error message.
    func validateFields() -> String? {
        
        //check that all fields correct filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
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
    
    @IBAction func loginTapped(_ sender: Any) {
        
        //validate text fields
        let error = validateFields()
        
        if error != nil {
            //there's something wrong with the fields , show error message
            showError(error!)
        } else {
            
            //create cleaned versions of the text field
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil {
                    
                    //couldn't sign in
                    
                    /**self.errorLabel.text = err?.localizedDescription - встроенная возможность показать ошибку* */
                    
                    //there was an error on creating user account
                    showError("Incorrect user email.")
                    } else {
                    transitionToHome()
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
}
