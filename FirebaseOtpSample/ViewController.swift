//
//  ViewController.swift
//  FirebaseOtpSample
//
//  Created by CSS on 21/02/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet private var textField : UITextField!
    @IBOutlet private var textFieldCode : UITextField!
    
    var verificationId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction private func buttonAction(){
        
        if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
          
            self.verificationId = verificationID
            print("Default id ", verificationID)
            
        } else {
            
            PhoneAuthProvider.provider().verifyPhoneNumber(textField.text ?? "", uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.verificationId = verificationID ?? ""
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                print("Id --- ",verificationID)
                
                // Sign in using the verificationID and the code sent to the user
                // ...
            }
            
        }
        
        
       
    }
    
    
    @IBAction private func buttonValidate(){
        
        guard let verificationCode = textFieldCode.text else {
            print("Failed")
           return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: verificationCode)
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        firebaseAuth.signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
           
            print("User  ", user )
            
        }
    }
    
}

