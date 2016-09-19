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
            star.contentMode = .scaleAspectFit
        }
        
        emailTextField.delegate = self
        descriptionTextField.delegate = self
        
        descriptionTextField.text = "Enter message here."
        descriptionTextField.textColor = UIColor.lightGray
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.cornerRadius = 5
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {

        if !messageSent {
            
            if !didMakeEdit || descriptionTextField.text.isEmpty {
                
                displayAlert(title: "Oops...", message: "Your message is still empty!")
                
            } else if !isValidEmail(emailTextField.text!) {
                
                displayAlert(title: "Invalid Email Address", message: "Please enter a valid email address")
                
            } else {
                
                let parameters: [String:String] = [
                    "description": descriptionTextField.text!,
                    "device": "\(UIDevice.current.deviceType)",
                    "details": "iOS Version: \(UIDevice.current.systemVersion)",
                    "rating": "\(rating)",
                    "email": emailTextField.text!
                ]
                
                let activity = ActivityViewController(message: "Sending Feedback...")
                present(activity, animated: true, completion: { 
                    SIRequest().postFeedback(parameters: parameters, callback: { (success) in
                        self.dismiss(animated: false, completion: { 
                            switch success {
                            case true:
                                
                                self.messageSent = true
                                
                                let message = UIAlertController(title: "Message Sent", message: "Thank you for contacting us, your feedback is greatly appreciated!", preferredStyle: .alert)
                                let action = UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                                    self.performSegue(withIdentifier: "UnwindToSupport", sender: self)
                                })
                                message.addAction(action)
                                
                                self.present(message, animated: true, completion: nil)
                                
                            case false:
                                
                                let message = UIAlertController(title: "Error", message: "Your message could not be sent, please try again later. If you have a secure internet connection and this problem persists, you may email us at shingo.events@usu.edu", preferredStyle: .alert)
                                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
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
        let alert = UIAlertController(title: "Empty Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}



extension ContactUsViewController {
    
    // MARK: - Rating buttons
    
    @IBAction func didTapStar(_ sender: AnyObject) {
        if let button = sender as? SIButton {
            changeStars(button)
        }
    }

    fileprivate func changeStars(_ sender: SIButton) {
        for i in 1 ..< 6 {
            if let button = view.viewWithTag(i) as? SIButton {
                if i <= sender.tag {
                    button.setImage(UIImage(named: "gold_star"), for: UIControlState())
                    rating = i
                } else {
                    button.setImage(UIImage(named: "white_star"), for: UIControlState())
                }
            }
        }
    }
    
}

extension ContactUsViewController {

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITextViewDeleagte
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !didMakeEdit {
            textView.text = ""
            textView.textColor = .black
            didMakeEdit = true
        }
    }
    
    @objc(textView:shouldChangeTextInRange:replacementText:) func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}




