//
//  RegisterViewController.swift
//  EventsApp
//
//  Created by tbredemeier on 4/2/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onRegisterButtonTapped(sender: UIButton) {
        if userNameTextField.text == "" || passwordTextField.text == "" {
            showAlert("Please enter a user name and password", nil, self)
        }
        else {
            User.registerNewUser(userNameTextField.text, password: passwordTextField.text, completed: { (result, error) -> Void in
                if error != nil {
                    showAlertWithError(error, self)
                }
                else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
}
