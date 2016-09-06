////
////  ReportABugViewController.swift
////  Shingo Events
////
////  Created by Craig Blackburn on 2/23/16.
////  Copyright © 2016 Shingo Institute. All rights reserved.
////
//
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
        
        view.backgroundColor = SIColor.shingoGoldColor()
        
        descriptionTextField.delegate = self
        emailTextField.delegate = self
        
        descriptionTextField.text = "Enter message here."
        descriptionTextField.textColor = UIColor.lightGrayColor()
        descriptionTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.cornerRadius = 5
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        view.bringSubviewToFront(dropDownImageView)
        setupDropDown()
    }
    
    private func setupDropDown() {
        
        bugTypeButton.layer.cornerRadius = 4
        bugTypeButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        bugTypeButton.layer.borderWidth = 1
        
        dropDown.dataSource = ["App Crash", "Feature Request", "General Feedback", "Spelling/Grammar", "Unexpected Behavior", "User Interface", "Other"]
        
        dropDown.dismissMode = .OnTap
        dropDown.direction = .Bottom
        
        dropDown.anchorView = bugTypeButton
        
        dropDown.bottomOffset = CGPoint(x: 0, y: bugTypeButton.bounds.height)
        
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.bugTypeButton.setTitle(item, forState: .Normal)
            self.dropDownImageView.hidden = true
        }
        
        dropDown.cancelAction = { [unowned self] in
            self.bugTypeButton.setTitle("No Selection", forState: .Normal)
            self.dropDownImageView.hidden = false
        }
        
    }
    
    @IBAction func didTapSubmit(sender: AnyObject) {
        
        if !messageSent {
            if !didMakeEdit || descriptionTextField.text.isEmpty {
                
                displayAlert(title: "Oops...", message: "Your message is still empty!")
                
            } else if let email = emailTextField.text {
                if !email.isEmpty {
                    if isValidEmail(email) {
                        displayAlert(title: "Invalid Email Address", message: "Please enter a valid email address")
                    }
                }
                
                
            } else {
            
                let parameters: [String:String] = [
                    "device": "\(UIDevice.currentDevice().deviceType), iOS Version: \(UIDevice.currentDevice().systemVersion)",
                    "description": descriptionTextField.text,
                    "details": "Bug Type: \(bugTypeButton.titleLabel!.text!)",
                    "email": emailTextField.text!
                ]
                
                let activity = ActivityViewController(message: "Sending Bug Report...")
                presentViewController(activity, animated: true, completion: { 
                    SIRequest().postBugReport(parameters, callback: { (success) in
                        self.dismissViewControllerAnimated(false, completion: {
                            switch success {
                            case true:
                                
                                self.messageSent = true
                                
                                let message = UIAlertController(title: "Message Sent", message: "Thank you for contacting us, your feedback is greatly appreciated!", preferredStyle: .Alert)
                                let action = UIAlertAction(title: "Okay", style: .Default, handler: { _ in
                                    self.performSegueWithIdentifier("UnwindToSettings", sender: self)
                                })
                                message.addAction(action)
                                
                                self.presentViewController(message, animated: true, completion: nil)
                                
                            case false:
                                
                                let message = UIAlertController(title: "Error", message: "Your message could not be sent, please try again later. If you have a secure internet connection and this problem persists, you may email us at shingo.events@usu.edu", preferredStyle: .Alert)
                                let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                                message.addAction(action)
                                
                                self.presentViewController(message, animated: true, completion: nil)
                                
                            }
                        })
                    })
                })
            }
        }
    }
    
    private func displayAlert(title title: String, message: String) {
        let alert = UIAlertController(title: "Empty Message", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension BugReportViewController {
    
    
    @IBAction func didTapDropDown(sender: AnyObject) {
        dropDown.show()
    }
    
    
    
}

extension BugReportViewController: UITextViewDelegate, UITextFieldDelegate {
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    
    //MARK: - UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if !didMakeEdit {
            textView.text = ""
            textView.textColor = .blackColor()
            didMakeEdit = true
        }
    }
    
}

