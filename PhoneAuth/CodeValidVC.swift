//
//  CodeValidVC.swift
//  PhoneAuth
//
//  Created by Aleksandr Kurdiukov on 17.05.20.
//  Copyright © 2020 Zizlak. All rights reserved.
//

import UIKit
import FirebaseAuth

class CodeValidVC: UIViewController {
    
    var verificationID: String!
    
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var checkCodeButton: UIButton!
    
    @IBAction func checkCodeTapped(_ sender: UIButton) {
        guard let code = codeTextView.text else { return }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { (_, error) in
            if error != nil{
                let ac = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                ac.addAction(cancel)
                self.present(ac, animated: true)
            } else {
                self.showContentVC()
            }
        }
        
        showContentVC()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()

    }
    
    private func setupConfig(){
        checkCodeButton.alpha = 0.7
        checkCodeButton.isEnabled = false
        
        codeTextView.delegate = self
        
    }
    
    private func showContentVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "ContentVC") as! ContentVC
        self.present(dvc, animated: true)
        
    }
}


extension CodeValidVC: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentCharacterCount = textView.text?.count ?? 0
        
        if range.length + range.location > currentCharacterCount{
            return false
        }
        
        let newLenght = currentCharacterCount + text.count - range.length
        
        return newLenght <= 6
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text?.count == 6{
            checkCodeButton.alpha = 1
            checkCodeButton.isEnabled = true
        } else {
            checkCodeButton.alpha = 0.7
            checkCodeButton.isEnabled = false
        }
    }
}
