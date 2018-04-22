//
//  ViewController.swift
//  scrollView
//
//  Created by Joffrey Fortin on 22/04/2018.
//  Copyright © 2018 Joffrey Fortin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize.height = 2000
        sv.backgroundColor = .cyan
        sv.translatesAutoresizingMaskIntoConstraints = false        
        return sv
    }()
    
    lazy var emailTextfield: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.tag = 1
        tf.placeholder = "Enter your email adress"
        tf.backgroundColor = .red
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var passwordTextfield: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.tag = 2
        tf.placeholder = "Password"
        tf.backgroundColor = .green
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var selectedTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        setupScrollView()
        
    }
    
    private func setupScrollView() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        scrollView.addSubview(emailTextfield)
        emailTextfield.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        emailTextfield.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: scrollView.contentSize.height / 2).isActive = true
        
        scrollView.addSubview(passwordTextfield)
        passwordTextfield.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 40).isActive = true        
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification) {
        
        guard let textfield = selectedTextField else { return }
        
        guard let info = notification.userInfo else { return }
        
        guard let rect = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else { return }
        
        let targetY = view.frame.height - rect.height - 20 - textfield.frame.height
        
        let originY = textfield.frame.origin.y - scrollView.contentOffset.y
        
        let difference = targetY - originY
        
        print(targetY, originY, difference)
        
        if difference < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y - difference), animated: true)
        }
    }
    
    @objc private func handleDismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
}

