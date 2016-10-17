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

class ContactUsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView! {
        didSet {
            descriptionTextField.text = "Enter message here."
            descriptionTextField.textColor = UIColor.lightGray
            descriptionTextField.layer.cornerRadius = 3
        }
    }
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel! {
        didSet {
            characterCountLabel.text = "\(textViewCharacterLimit) characters left"
        }
    }
    
    @IBOutlet weak var star1: SIButton!
    @IBOutlet weak var star2: SIButton!
    @IBOutlet weak var star3: SIButton!
    @IBOutlet weak var star4: SIButton!
    @IBOutlet weak var star5: SIButton!
    
    var rating = 0

    let textViewCharacterLimit = 250
    
    var didMakeEdit = false
    var messageSent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightShingoRed
        
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        emailTextField.delegate = self
        descriptionTextField.delegate = self
        
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {

        if !messageSent {
            
            if !didMakeEdit || descriptionTextField.text.isEmpty {
                
                displayAlert(title: "Oops...", message: "Your message is still empty!")
                
            } else {
                
                if !emailTextField.text!.isEmpty {
                    if !isValidEmail(emailTextField.text!) {
                        displayAlert(title: "Invalid Email Address", message: "Please enter a valid email address")
                        return
                    }
                }
                
                var email = "not provided"
                
                if !emailTextField.text!.isEmpty {
                    email = emailTextField.text!
                }
                
                let parameters: [String:String] = [
                    "description": descriptionTextField.text!,
                    "device": "\(UIDevice.current.deviceType)",
                    "details": "iOS Version: \(UIDevice.current.systemVersion)",
                    "rating": "\(rating)",
                    "email": email
                ]
                
                let activity = ActivityViewController(message: "Sending Feedback...")
                present(activity, animated: true, completion: { 
                    SIRequest.postFeedback(parameters: parameters, callback: { (success) in
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
                                
                                let message = UIAlertController(title: "Error", message: "There was an error and your message could not be sent. If this problem persists, you may email us at shingo.events@usu.edu", preferredStyle: .alert)
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

extension ContactUsViewController: UITextViewDelegate {

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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return NSString(string: textView.text).replacingCharacters(in: range, with: text).characters.count < textViewCharacterLimit + 1
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text!.characters.count
        characterCountLabel.text = "\(textViewCharacterLimit - count) characters left"
        
    }

}




