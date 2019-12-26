//
//  UploadViewController.swift
//  instaCloneWithFirebase
//
//  Created by Tutku Bide on 12.09.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(recognizer)
    }
   @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func alert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction.init(title: titleInput, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonClick(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("media")  // storage ilk sayfa
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuıd = UUID().uuidString
            
            let imageReferance = mediaFolder.child(" \(uuıd).jpeg") // sonuna jpg koymassam fanklı kaydeder.
            imageReferance.putData(data, metadata: nil) { (metada, error) in
                if error != nil{
                  self.alert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hatalı")
                }else{
                   
                    imageReferance.downloadURL(completion: { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString //
                            
                            
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReferance: DocumentReference? = nil
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.alert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata")
                                }else{
                                    self.tabBarController?.selectedIndex = 0
                                    self.imageView.image = UIImage(named: "imageadd")
                                    self.commentText.text = ""
                                }
                            
                            })
                            
                        }
                    })
                }
            }
        }
        
    }
    
    

}
