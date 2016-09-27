////
////  ReportABugViewController.swift
////  Shingo Events
////
////  Created by Craig Blackburn on 2/23/16.
////  Copyright © 2016 Shingo Institute. All rights reserved.
////

import UIKit
import DropDown

class BugReportViewController: UIViewController {
    var didMakeEdit = false
    var messageSent = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var bugTypeButton: UIButton!
    @IBOutlet weak var dropDownImageView: UIImageView!
    
    var dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .shingoRed
        
        descriptionTextField.delegate = self
        emailTextField.delegate = self
        
        descriptionTextField.text = "Enter message here."
        descriptionTextField.textColor = UIColor.lightGray
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.cornerRadius = 5
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.lightGray.cgColor
        
        view.bringSubview(toFront: dropDownImageView)
        setupDropDown()
    }
    
    fileprivate func setupDropDown() {
        
        bugTypeButton.layer.cornerRadius = 4
        bugTypeButton.layer.borderColor = UIColor.lightGray.cgColor
        bugTypeButton.layer.borderWidth = 1
        
        dropDown.dataSource = ["App Crash", "General Feedback", "Spelling/Grammar", "Unexpected Behavior", "User Interface", "Other"]
        
        dropDown.dismissMode = .onTap
        dropDown.direction = .bottom
        
        dropDown.anchorView = bugTypeButton
        
        dropDown.bottomOffset = CGPoint(x: 0, y: bugTypeButton.bounds.height)
        
        dropDown.selectionAction = { (index, item) in
            self.bugTypeButton.setTitle(item, for: UIControlState())
            self.dropDownImageView.isHidden = true
        }
        
        dropDown.cancelAction = { _ in
            self.bugTypeButton.setTitle("No Selection", for: UIControlState())
            self.dropDownImageView.isHidden = false
        }
        
    }
    
    @IBAction func didTapSubmit(_ sender: AnyObject) {
        
        if !messageSent {
            if !didMakeEdit || descriptionTextField.text.isEmpty {
                
                displayAlert(title: "Oops...", message: "Your message is still empty!")
                
            } else  {
                
                if let email = emailTextField.text {
                    if !email.isEmpty {
                        if !isValidEmail(email) {
                            displayAlert(title: "Invalid Email Address", message: "Please enter a valid email address")
                            return
                        }
                    }
                }
                
            
                let parameters: [String:String] = [
                    "device": "\(UIDevice.current.deviceType), iOS Version: \(UIDevice.current.systemVersion)",
                    "description": descriptionTextField.text,
                    "details": "Bug Type: \(bugTypeButton.titleLabel!.text!)",
                    "email": emailTextField.text!
                ]
                
                let activity = ActivityViewController(message: "Sending Bug Report...")
                present(activity, animated: true, completion: { 
                    SIRequest().postBugReport(parameters: parameters, callback: { (success) in
                        self.dismiss(animated: false, completion: {
                            switch success {
                            case true:
                                
                                self.messageSent = true
                                
                                let message = UIAlertController(title: "Message Sent", message: "Thank you for contacting us. Your feedback is greatly appreciated!", preferredStyle: .alert)
                                let action = UIAlertAction(title: "Okay", style: .default, handler: { _ in
                                    self.performSegue(withIdentifier: "UnwindToSettings", sender: self)
                                })
                                message.addAction(action)
                                
                                self.present(message, animated: true, completion: nil)
                                
                            case false:
                                
                                let message = UIAlertController(title: "Error", message: "Your message could not be sent, please try again later. If you have a secure internet connection and this problem persists, you may email us at shingo.events@usu.edu", preferredStyle: .alert)
                                let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                                message.addAction(action)
                                
                                self.present(message, animated: true, completion: nil)
                                
                            }
                        })
                    })
                })
            }
        }
    }
    
    fileprivate func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension DropDown {
    func setWidth(_ width: CGFloat) {
        
    }
}

extension BugReportViewController {
    
    @IBAction func didTapDropDown(_ sender: AnyObject) {
        dropDown.show()
    }
    
}

extension BugReportViewController: UITextViewDelegate, UITextFieldDelegate {
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    
    //MARK: - UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !didMakeEdit {
            textView.text = ""
            textView.textColor = .black
            didMakeEdit = true
        }
    }
    
}

