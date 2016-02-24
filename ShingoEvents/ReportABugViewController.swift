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
        backgroundImage.image = UIImage(named: "shingo_icon_skinny")
        backgroundImage.autoSetDimensionsToSize(CGSize(width: self.view.frame.width, height: self.view.frame.height))
        backgroundImage.autoPinEdgesToSuperviewEdges()
        
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
                let url = "https://shingo-events.herokuapp.com/api/reportabug?" + CLIENT_ID_SECRET
                
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

//
//class ReportABugViewController: UIViewController {
//
//    var titleLabelString:String!
//    
//    let titleLabel:UILabel = {
//        let view = UILabel.newAutoLayoutView()
//        return view
//    }()
//    
//    let greetingLabel:UILabel = {
//        let view = UILabel.newAutoLayoutView()
//        return view
//    }()
//    
//    let messageTextField:UITextView = {
//        let view = UITextView.newAutoLayoutView()
//        return view
//    }()
//    
//    let backgroundImage:UIImageView = {
//        let view = UIImageView.newAutoLayoutView()
//        view.image = UIImage(named: "shingo_icon_skinny")
//        return view
//    }()
//    
//    let sendButton:UIButton = {
//        let view = UIButton.newAutoLayoutView()
//        view.titleLabel?.text = "Send Message"
//        view.titleLabel?.font = UIFont.systemFontOfSize(30.0)
//        return view
//    }()
//    
//    var didSetupConstraints = false
//    
//    override func loadView() {
//
//        view = UIView()
//        view.backgroundColor = .whiteColor()
//        
//        view.addSubview(messageTextField)
//        view.addSubview(titleLabel)
//        view.addSubview(greetingLabel)
//        view.addSubview(backgroundImage)
//        view.addSubview(sendButton)
//        
//        view.bringSubviewToFront(titleLabel)
//        view.bringSubviewToFront(greetingLabel)
//        view.bringSubviewToFront(sendButton)
//        view.bringSubviewToFront(messageTextField)
//        
//        view.setNeedsUpdateConstraints()
//    }
//
//    override func updateViewConstraints() {
//        if !didSetupConstraints
//        {
//            backgroundImage.autoMatchDimension(.Width, toDimension: .Width, ofView: view)
//            backgroundImage.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
////            backgroundImage.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
////            backgroundImage.autoPinToBottomLayoutGuideOfViewController(self, withInset: 0.0)
////            backgroundImage.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 0.0)
////            backgroundImage.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: 0.0)
//            backgroundImage.autoPinEdgesToSuperviewEdges()
//            
//            titleLabel.autoSetDimensionsToSize(CGSize(width: view.frame.width, height: 21.0))
//            titleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: view, withOffset: 5.0)
//            titleLabel.autoAlignAxis(.Vertical, toSameAxisOfView: view)
//            
//            greetingLabel.autoSetDimensionsToSize(CGSize(width: view.frame.width - 10, height: 21.0))
//            greetingLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 10.0)
//            greetingLabel.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 10.0)
//            
//            messageTextField.autoSetDimensionsToSize(CGSize(width: view.frame.width - 30 , height: 300))
//            messageTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: greetingLabel, withOffset: 10.0)
//            messageTextField.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 10.0)
////            messageTextField.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 10.0)
//            
//            sendButton.autoSetDimensionsToSize(CGSize(width: view.frame.width - 10, height: 48.0))
//            sendButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: messageTextField, withOffset: 10.0)
//            sendButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)         
//            
//            didSetupConstraints = true
//        }
//        super.updateViewConstraints()
//    }
//
//
//}
