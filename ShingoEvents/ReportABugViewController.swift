////
////  ReportABugViewController.swift
////  Shingo Events
////
////  Created by Craig Blackburn on 2/23/16.
////  Copyright © 2016 Shingo Institute. All rights reserved.
////
//
import UIKit
import Alamofire

class ReportABugViewController: UIViewController, UITextViewDelegate {

    var titleLabelString:String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var reportButton: UIButton!
    
    var beganEditing = false
    var messageSent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleLabelString
        
        messageTextField.delegate = self
        
        messageTextField.text = "Enter message here."
        messageTextField.textColor = UIColor.lightGrayColor()
        
        let backgroundImage = UIImageView.newAutoLayoutView()
        view.addSubview(backgroundImage)
        backgroundImage.image = ShingoIconImages().shingoIconForDevice()
        backgroundImage.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        backgroundImage.autoPinEdgeToSuperviewEdge(.Left)
        backgroundImage.autoPinEdgeToSuperviewEdge(.Right)
        backgroundImage.autoPinEdgeToSuperviewEdge(.Bottom)
        
        messageTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        messageTextField.layer.borderWidth = 1.0
        messageTextField.layer.cornerRadius = 2.0
        messageTextField.backgroundColor = UIColor.whiteColor()
        messageTextField.alpha = 0.9
        
        view.bringSubviewToFront(titleLabel)
        view.bringSubviewToFront(messageTextField)
        view.bringSubviewToFront(reportButton)
        
        if titleLabelString != "Report a bug"
        {
            reportButton.setTitle("Send Feedback", forState: UIControlState.Normal)
        }
    }
    

    @IBAction func didTapReportBug(sender: AnyObject) {
        
        if !messageSent
        {
            if messageTextField.text == "" || messageTextField.text == "Enter message here."
            {
                let alert = UIAlertController(title: "Oops!", message: "The message field is still empty!", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                alert.addAction(action)
                
                presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
                let system_information:String = " " + UIDevice.currentDevice().modelName + " version "  + UIDevice.currentDevice().systemVersion
                let report:String = messageTextField.text + "\n\n"
                var type:String = ""
                
                if titleLabelString == "Report a bug"
                {
                    type = " Bug report"
                }
                else
                {
                    type = " Feedback"
                }
                
                let parameters = [
                    "system_information": system_information,
                    "report": report,
                    "type":type
                ]
                
                let CLIENT_ID_SECRET = "client_id=6cd61ca33e7f2f94d460b1e9f2cb73&client_secret=bb313eea59bd309a4443c38b29"
                let url = "https://http://104.131.77.136:5000/api/reportabug?" + CLIENT_ID_SECRET
                
                Alamofire.request(.POST, url, parameters: parameters).responseJSON { _ in }
                
                self.showConfirmationMessage()
                self.messageSent = true
            }
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if !beganEditing
        {
            textView.text = ""
            textView.textColor = .blackColor()
            beganEditing = true
        }
    }
    
    func showConfirmationMessage() {
        let message = UIAlertController(title: "Message Sent!", message: "Thank you for contacting us, your message has been sent.", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        message.addAction(action)
        
        presentViewController(message, animated: true, completion: nil)
    }
    
}

