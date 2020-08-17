//
//  SettingsViewController.swift
//  instaCloneWithFirebase
//
//  Created by Tutku Bide on 12.09.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBAction func logoutClick(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewVC", sender: nil)
        }catch{
        }
    }
}
