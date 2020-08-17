//
//  ViewController.swift
//  instaCloneWithFirebase
//
//  Created by Tutku Bide on 12.09.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore

class SignViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.rememberuser()
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(granted: _, declined: _, token: _):
                self.singIntoFirebase()
            case .failed(let err):
                print(err)
            case .cancelled:
                print("cancel")
            }
            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
        }
    }
    
    fileprivate func singIntoFirebase() {
        guard let accessToken = AccessToken.current?.tokenString else { return }
        let credetial = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credetial) { (user, err) in
            if let error = err {
                print(error)
                return
            }
            print("succesful logged")
        }
    }
    
    @IBAction func signInClick(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Error" )
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "HATA", messageInput: "Kullanıcı Adı veya Parola Hatalı")
        }
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: nil)
    }
    
    func makeAlert(titleInput:String,messageInput:String) {
        let alert = UIAlertController(title:titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
