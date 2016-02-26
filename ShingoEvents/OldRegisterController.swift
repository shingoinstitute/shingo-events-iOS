//
//  RegisterController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 12/29/15.
//  Copyright © 2015 Shingo Institute. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    @IBOutlet weak var first_nameTF: UITextField!
    @IBOutlet weak var last_nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var companyTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var display_nameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirm_passwordTF: UITextField!
    @IBOutlet weak var visibility: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func verifyPassword(p1: String, p2: String) -> Bool {
        if (p1 == p2) {
            return true
        } else {
            return false
        }
    }


    @IBAction func didTapDone(sender: AnyObject) {
        
        let first_name: String = first_nameTF.text!
        let last_name: String = last_nameTF.text!
        let email: String = emailTF.text!
        let company: String = companyTF.text!
        var title: String? = titleTF.text
        var display_name: String? = display_nameTF.text
        let password: String = passwordTF.text!
        let confirm_password: String = confirm_passwordTF.text!
        
        if (title == "") {
            title = nil
        }
        
        if (display_name == "") {
            display_name = nil
        }
        
        if verifyPassword(password, p2: confirm_password) {
            let user = User(first_name: first_name, last_name: last_name, display_name: display_name, email: email, password: password, title: title, company: company, visibility: visibility.on, registration_ids: [], connections: [])
            user.registerUser(user, completionHandler: registerUser)
        } else {
            // If login fails, alert the user that their username or password may be incorrect

            
            // Create an alert to inform user we were unable to validate their credentials
            let alert = UIAlertController(title: "Passwords did not match", message: "Your passwords did not match, please try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func registerUser(user: User) -> Void {
        print("User \(user.first_name) \(user.last_name) created")
    }

}


















