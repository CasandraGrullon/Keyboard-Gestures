//
//  ViewController.swift
//  Keyboard-Gestures
//
//  Created by casandra grullon on 2/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var pursuitLogo: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var pLogoCenterY: NSLayoutConstraint!
    
    private var originalConstraint: NSLayoutConstraint!
    
    private var keyboardIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        moveKeyboardUp(keyboardFrame.size.height)
    }
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        resetUI()
    }
    private func moveKeyboardUp(_ height: CGFloat) {
        //if keyboard is already visible, then return --> do nothing
        if keyboardIsVisible { return }
        originalConstraint = pLogoCenterY //saves original value
        
        //once keyboard is made visible, the object will move up
        pLogoCenterY.constant -= height / 2
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        keyboardIsVisible = true
    }
    private func resetUI() {
        keyboardIsVisible = false
        pLogoCenterY.constant -= originalConstraint.constant
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
