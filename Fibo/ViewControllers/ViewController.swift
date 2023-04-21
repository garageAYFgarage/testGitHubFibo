//
//  ViewController.swift
//  Fibo
//
//  Created by iFARA💻 on 19.04.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
    }

    func setUpElements() {
        
        //style the elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
        
    }

}

