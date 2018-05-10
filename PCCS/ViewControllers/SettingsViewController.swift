//
//  SettingsViewController.swift
//  PCCS
//
//  Created by Sivaramsingh on 05/05/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

private struct Strings{
    static let DATE_FORMAT         = "dd/MM/YYYY"
}

class SettingsViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtfldUsername: UITextField!
    @IBOutlet weak var txtfldPassword: UITextField!
    @IBOutlet weak var txtfldUrl: UITextField!
    @IBOutlet weak var txtfldDate: UITextField!
    fileprivate var birthdayDatePicker: UIDatePicker = UIDatePicker()
    
    private var isUsernameValid = false
    private var isPasswordValid = false
    private var isURLValid = false
    private var isBirthdayValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Defaults Values"
        self.navigationController?.navigationBar.isHidden = false
        btnSave.backgroundColor = UIColor.pinkishGreyColor()
        btnSave.isEnabled = false
        // Do any additional setup after loading the view.
        
        txtfldUsername.addTarget(self, action: #selector(SettingsViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        txtfldPassword.addTarget(self, action: #selector(SettingsViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        txtfldUrl.addTarget(self, action: #selector(SettingsViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        txtfldDate.addTarget(self, action: #selector(SettingsViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        setBirthdayPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelCliked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setBirthdayPicker()
    {
        //Set up Datepicker to hidden textfield
        self.birthdayDatePicker.datePickerMode = UIDatePickerMode.date
        self.birthdayDatePicker.backgroundColor = UIColor.white
        self.birthdayDatePicker.addTarget(self, action: #selector(SettingsViewController.handleDatePicker), for: UIControlEvents.valueChanged)
        self.txtfldDate.inputView = self.birthdayDatePicker
    }
    
    
    //MARK: UITextViewDelegate protocol
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField
        {
            nextTextField.becomeFirstResponder()
            textField.resignFirstResponder()
        }
        else
        {
            btnSaveClicked(btnSave)
        }
        return true
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        switch textField {
        case self.txtfldUsername:
            self.validUsername()
            break
        case self.txtfldPassword:
            self.validPassword()
            break
        case self.txtfldUrl:
            self.validURL()
            break
        case self.txtfldDate:
            self.validDate()
            break
        default:
            break
        }
        self.validateForm()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        textField.layoutIfNeeded()
        switch textField {
        case self.txtfldUsername:
            self.validUsername()
            break
        case self.txtfldPassword:
            self.validPassword()
            break
        case self.txtfldUrl:
            self.validURL()
            break
        case self.txtfldDate:
            self.validDate()
            break
        default:
            break
        }
        
        validateForm()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard var text = textField.text else { return true }
        textField.layoutIfNeeded()
        switch textField
        {
        case txtfldDate:
           return false
        default:
            return true
        }
    }
    
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.view.endEditing(true)
        if (self.validateForm()) {
            
            UserDefaults.standard.set(self.txtfldUsername.text, forKey: "Username")
            UserDefaults.standard.set(self.txtfldPassword.text, forKey: "Password")
            UserDefaults.standard.set(self.txtfldUrl.text, forKey: "Url")
            UserDefaults.standard.set(self.txtfldDate.text, forKey: "Date")
            
            
            let alertController = UIAlertController(title:"Data Saved Thank you!!!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
            })
            alertController.addAction(yesAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title:"Please enter all values.", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
            })
            alertController.addAction(yesAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.DATE_FORMAT
        self.txtfldDate.text = dateFormatter.string(from: sender.date)
        self.validDate()
        validateForm()
    }
    
    fileprivate func validateForm() -> Bool {
        
        if (isUsernameValid && isPasswordValid && isURLValid && isBirthdayValid)
        {
            btnSave.backgroundColor = UIColor.sandyBrownColor()
            btnSave.isEnabled = true
            
            return true
        }
        btnSave.backgroundColor = UIColor.pinkishGreyColor()
        btnSave.isEnabled = false
        return false
    }
    
    fileprivate func validURL() {
        
        if let url = txtfldUrl.text, !url.isEmpty
        {
            isURLValid = true
        }
        else
        {
            isURLValid = false
        }
    }
    
    fileprivate func validUsername() {
        
        if let firstname = txtfldUsername.text, !firstname.isEmpty && firstname.count > 0
        {
            isUsernameValid = true
        }
        else
        {
            isUsernameValid = false
        }
    }
    
    fileprivate func validDate() {
        
        if let date = txtfldDate.text, !date.isEmpty
        {
            isBirthdayValid = true
        }
        else
        {
            isBirthdayValid = false
        }
    }
    
    fileprivate func validPassword() {
        
        if let password = txtfldPassword.text, !password.isEmpty
        {
            isPasswordValid = true
        }
        else
        {
            isPasswordValid = false
        }
    }
    
   
    
  
    
 

}
