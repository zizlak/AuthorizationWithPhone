//
//  ContentVC.swift
//  PhoneAuth
//
//  Created by Aleksandr Kurdiukov on 17.05.20.
//  Copyright © 2020 Zizlak. All rights reserved.
//

import UIKit
import FirebaseAuth

class ContentVC: UIViewController {
    
    @IBAction func logOut(){
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "closeSeque", sender: self)
            
        } catch {
            
        }
    }
}
