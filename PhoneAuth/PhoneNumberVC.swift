//
//  PhoneNumberVC.swift
//  PhoneAuth
//
//  Created by Aleksandr Kurdiukov on 17.05.20.
//  Copyright © 2020 Zizlak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FlagPhoneNumber

class PhoneNumberVC: UIViewController {
    
    var phoneNumber: String?
    var listController: FPNCountryListViewController!
    
    @IBOutlet weak var sendCodeOutlet: UIButton!
    @IBOutlet weak var phoneTextField: FPNTextField!
    
    @IBAction func sendCodeAction(_ sender: UIButton) {
        
        guard let phoneNumber = phoneNumber else { return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
            } else {
                self.showCodeValidVC(verificationID: verificationID!)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
    }
    
    private func setupConfig(){
        sendCodeOutlet.alpha = 0.7
        sendCodeOutlet.isEnabled = false
        
        phoneTextField.displayMode = .list
        phoneTextField.delegate = self
        
        listController = FPNCountryListViewController(style: .grouped)
        listController?.setup(repository: phoneTextField.countryRepository)
        listController.didSelect = { country in
            self.phoneTextField.setFlag(countryCode: country.code)
            
        }
    }
    
    private func showCodeValidVC(verificationID: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "CodeValidVC") as! CodeValidVC
        dvc.verificationID = verificationID
        self.present(dvc, animated: true)
    }
    
    
    

}


extension PhoneNumberVC: FPNTextFieldDelegate{
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid{
            phoneNumber = phoneTextField.getFormattedPhoneNumber(format: .International)
            
            sendCodeOutlet.alpha = 1
            sendCodeOutlet.isEnabled = true
        } else {
            sendCodeOutlet.alpha = 0.7
            sendCodeOutlet.isEnabled = false
        }
    }
    
    func fpnDisplayCountryList() {
        let navigationController = UINavigationController(rootViewController: listController)
        listController.title = "Countries"
        phoneTextField.text = ""
        self.present(navigationController, animated: true)
    }
    
    
}
