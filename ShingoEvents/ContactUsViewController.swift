//
//  ContactUsViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Alamofire

class ContactUsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTF: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var messageSent = false

    var backgroundImage:UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.image = SIImages().shingoIconForDevice()
        return view
    }()

    var didTouchInsideTextField = false
    override func viewDidLoad() {
        super.viewDidLoad()

        sendMessageButton.imageView?.image = UIImage(named: "send button")
        
        view.addSubview(backgroundImage)
        backgroundImage.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        backgroundImage.autoPinEdgeToSuperviewEdge(.Right)
        backgroundImage.autoPinEdgeToSuperviewEdge(.Left)
        backgroundImage.autoPinEdgeToSuperviewEdge(.Bottom)
        
        messageTF.layer.borderColor = UIColor.lightGrayColor().CGColor
        messageTF.layer.borderWidth = 1.0
        messageTF.layer.cornerRadius = 3.0
        messageTF.textColor = UIColor.lightGrayColor()
        messageTF.text = "Enter message here."
        
        view.bringSubviewToFront(emailAddressTF)
        view.bringSubviewToFront(messageTF)
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(sendMessageButton)
        
        emailAddressTF.delegate = self
        messageTF.delegate = self
        
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailAddressTF.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if !didTouchInsideTextField {
            textView.text = ""
            textView.textColor = .blackColor()
            textView.text.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12.0)])
        }
    }
    
    
    
    @IBAction func sendMessage(sender: AnyObject) {
        if !messageSent
        {
            if messageTF.text == "" || !didTouchInsideTextField
            {
                let alert = UIAlertController(title: "Empty Message", message: "The message field is still empty!", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                alert.addAction(action)
                
                presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
                let system_information:String = " " + UIDevice.currentDevice().modelName + " version "  + UIDevice.currentDevice().systemVersion
                let report:String = messageTF.text + "\n\nEmail address provided: " + emailAddressTF.text! + "\n"
                let type:String = "Contact-Us"
                let parameters = [
                    "system_information": system_information,
                    "report": report,
                    "type":type
                ]
                
                let CLIENT_ID_SECRET = "client_id=6cd61ca33e7f2f94d460b1e9f2cb73&client_secret=bb313eea59bd309a4443c38b29"
                let url = "http://api.shingo.org:5000/api/reportabug?" + CLIENT_ID_SECRET
                
                Alamofire.request(.POST, url, parameters: parameters).responseJSON { _ in }
                
                self.showConfirmationMessage()
                self.messageSent = true
            }
        }

    }

    
    func showConfirmationMessage() {
        let message = UIAlertController(title: "Message Sent!", message: "Thank you for contacting us, your message has been sent.", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        message.addAction(action)
        
        presentViewController(message, animated: true, completion: nil)
    }



}
