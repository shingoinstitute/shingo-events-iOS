////
////  KeyboardListener.swift
////  DropDown
////
////  Created by Kevin Hirsch on 30/07/15.
////  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
////
//
//import UIKit
//
//let CGRectZero = CGRect(x: 0, y: 0, width: 0, height: 0)
//
//internal final class KeyboardListener {
//	
//	static let sharedInstance = KeyboardListener()
//	
//	private(set) var isVisible = false
//	private(set) var keyboardFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
//	private var isListening = false
//	
//	deinit {
//		stopListeningToKeyboard()
//	}
//	
//}
//
////MARK: - Notifications
//
//extension KeyboardListener {
//	
//	func startListeningToKeyboard() {
//		if isListening {
//			return
//		}
//		
//		isListening = true
//		
//		NotificationCenter.defaultCenter().addObserver(
//			self,
//			selector: #selector(keyboardWillShow(_:)),
//			name: UIKeyboardWillShowNotification,
//			object: nil)
//		NotificationCenter.defaultCenter().addObserver(
//			self,
//			selector: #selector(keyboardWillHide(_:)),
//			name: UIKeyboardWillHideNotification,
//			object: nil)
//	}
//	
//	func stopListeningToKeyboard() {
//		NotificationCenter.defaultCenter.removeObserver(self)
//	}
//	
//	@objc
//	private func keyboardWillShow(notification: NSNotification) {
//		isVisible = true
//		keyboardFrame = keyboardFrameFromNotification(notification)
//	}
//	
//	@objc
//	private func keyboardWillHide(notification: NSNotification) {
//		isVisible = false
//		keyboardFrame = keyboardFrameFromNotification(notification)
//	}
//	
//	private func keyboardFrameFromNotification(notification: NSNotification) -> CGRect {
//		return (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRectZero
//	}
//	
//}
