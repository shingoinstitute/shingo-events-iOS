//
//  ContactUsViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SIButton: UIButton {
    var starSelected = false
}

class ContactUsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var star1: SIButton!
    @IBOutlet weak var star2: SIButton!
    @IBOutlet weak var star3: SIButton!
    @IBOutlet weak var star4: SIButton!
    @IBOutlet weak var star5: SIButton!
    
    var rating = 0

    var didMakeEdit = false
    var messageSent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SIColor.shingoGoldColor()
        
        let starButtons: [SIButton] = [star1, star2, star3, star4, star5]
        
        for star in starButtons {
            star.contentMode = .ScaleAspectFit
        }
        
        emailTextField.delegate = self
        descriptionTextField.delegate = self
        
        descriptionTextField.text = "Enter message here."
        descriptionTextField.textColor = UIColor.lightGrayColor()
        descriptionTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.cornerRadius = 5
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    @IBAction func sendMessage(sender: AnyObject) {

        if !messageSent {
            
            if !didMakeEdit || descriptionTextField.text.isEmpty {
                
                displayAlert(title: "Oops...", message: "Your message is still empty!")
                
            } else if !isValidEmail(emailTextField.text!) {
                
                displayAlert(title: "Invalid Email Address", message: "Please enter a valid email address")
                
            } else {
                
                let parameters: [String:String] = [
                    "description": descriptionTextField.text!,
                    "device": "\(UIDevice.currentDevice().deviceType)",
                    "details": "iOS Version: \(UIDevice.currentDevice().systemVersion)",
                    "rating": "\(rating)",
                    "email": emailTextField.text!
                ]
                
                let activity = ActivityViewController(message: "Sending Feedback...")
                presentViewController(activity, animated: true, completion: { 
                    SIRequest().postFeedback(parameters, callback: { (success) in
                        self.dismissViewControllerAnimated(false, completion: { 
                            switch success {
                            case true:
                                
                                self.messageSent = true
                                
                                let message = UIAlertController(title: "Message Sent", message: "Thank you for contacting us, your feedback is greatly appreciated!", preferredStyle: .Alert)
                                let action = UIAlertAction(title: "Okay", style: .Default, handler: { (_) in
                                    self.performSegueWithIdentifier("UnwindToSupport", sender: self)
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



extension ContactUsViewController {
    
    // MARK: - Rating buttons
    
    @IBAction func didTapStar(sender: AnyObject) {
        if let button = sender as? SIButton {
            changeStars(button)
        }
    }

    private func changeStars(sender: SIButton) {
        for i in 1 ..< 6 {
            if let button = view.viewWithTag(i) as? SIButton {
                if i <= sender.tag {
                    button.setImage(UIImage(named: "gold_star"), forState: .Normal)
                    rating = i
                } else {
                    button.setImage(UIImage(named: "white_star"), forState: .Normal)
                }
            }
        }
    }
    
}

extension ContactUsViewController {

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITextViewDeleagte
    
    func textViewDidBeginEditing(textView: UITextView) {
        if !didMakeEdit {
            textView.text = ""
            textView.textColor = .blackColor()
            didMakeEdit = true
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}




