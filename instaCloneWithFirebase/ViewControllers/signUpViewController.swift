//
//  signUpViewController.swift
//  instaCloneWithFirebase
//
//  Created by Tutku Bide on 18.09.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import Firebase

class signUpViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var birthdayText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func joinButton(_ sender: Any) {
        if nameText.text != "" && passwordText.text != "" && birthdayText.text != "" && emailText.text != ""{
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "fromsignUptoFeedVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "HATA", messageInput: "Kullanıcı Adı veya Parola Hatalı")
        }
        
        
        
    }
    func makeAlert(titleInput:String,messageInput:String) {
        let alert = UIAlertController(title:titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
