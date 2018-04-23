//
//  ViewController.swift
//  scrollView
//
//  Created by Joffrey Fortin on 22/04/2018.
//  Copyright © 2018 Joffrey Fortin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor(red: 218/255, green: 235/255, blue: 243/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var nameTextfield: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.tag = 0
        tf.placeholder = "Entrez un nom pour votre séance"
        tf.font = UIFont.systemFont(ofSize: 16)
//        tf.backgroundColor = .blue
        return tf
    }()
    
    let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Entrez l'heure de début"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let startDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.locale = Locale(identifier: "FR_fr")
        return dp
    }()
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Fin de l'entraînement"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let endDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.locale = Locale(identifier: "FR_fr")
        return dp
    }()
    
    
    lazy var noteTextfield: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.tag = 1
        tf.placeholder = "Remarques séances"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.backgroundColor = .green
        return tf
    }()
    
    let notationLabel: UILabel = {
        let label = UILabel()
        label.text = "Notez la séance"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var notationPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
//        let rotationAngle: CGFloat = -.pi / 2
//        picker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        picker.selectRow(4, inComponent: 0, animated: false)
        return picker
    }()
 
    lazy var notesTextview: UITextView = {
        let tf = UITextView()
        tf.delegate = self
        tf.text = "Notes"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.backgroundColor = .blue
        return tf
    }()
    
    var selectedTextField: UITextField?
    var selectedTextArea: Any?
    var textfieldMode: Bool?
    
    let pickerData = [Int16](1...10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Créer entraînement"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        setupScrollView()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupScrollView() {
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 218/255, green: 235/255, blue: 243/255, alpha: 1)
        
        scrollView.addSubview(containerView)
        
        containerView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 1300)
        
        
        [nameTextfield, startDateLabel, startDatePicker, endDateLabel, endDatePicker, notationLabel, notationPickerView].forEach { containerView.addSubview($0)}
        
        nameTextfield.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
        
        startDateLabel.anchor(top: nameTextfield.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        startDatePicker.anchor(top: startDateLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 65)
        
        endDateLabel.anchor(top: startDatePicker.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        endDatePicker.anchor(top: endDateLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 65)
        
        notationLabel.anchor(top: endDatePicker.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: nil , paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 200, height: 65)
        
        notationPickerView.anchor(top: notationLabel.topAnchor, left: notationLabel.rightAnchor , bottom: notationLabel.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification) {
        
        offSetBottomAnchor(notification: notification)
    }
    
    private func offSetBottomAnchor(notification: NSNotification) {
        
//        guard let textfield = selectedTextField else { return }
        guard let info = notification.userInfo else { return }
        guard let rect = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else { return }
        guard let textfieldMode = textfieldMode else { return }
        
        var targetY: CGFloat = 0
        var originY: CGFloat = 0
        
        if textfieldMode {
            guard let textfield = selectedTextArea as? UITextField else { return }
            targetY = view.frame.height - rect.height - 20 - textfield.frame.height
            originY = textfield.frame.origin.y - scrollView.contentOffset.y
        } else {
            guard let textview = selectedTextArea as? UITextView else { return }
            targetY = view.frame.height - rect.height - 20 - textview.frame.height
            originY = textview.frame.origin.y - scrollView.contentOffset.y
        }
        
        let difference = targetY - originY
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: rect.height, right: 0)
        
        print(targetY, originY, difference)
        
        if difference < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y - difference), animated: false)
        }
        
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc private func handleDismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

extension ViewController {
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextArea = textField
        textfieldMode = true
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        selectedTextArea = textView
        textfieldMode = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row])"
    }
//
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        let width: CGFloat = 100
//        let height: CGFloat = 65
//
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        label.text = "\(pickerData[row])"
//        view.addSubview(label)
//
//        let rotationAngle: CGFloat = .pi / 2
//
//        view.transform = CGAffineTransform(rotationAngle: rotationAngle)
//
//        return view
//
//    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    
    
    
}

