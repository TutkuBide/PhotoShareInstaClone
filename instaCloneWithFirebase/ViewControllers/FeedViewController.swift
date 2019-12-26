//
//  FeedViewController.swift
//  instaCloneWithFirebase
//
//  Created by Tutku Bide on 12.09.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var usernameArray = [String]()
    var commentArrau = [String]()
    var imageArray = [String]()
    var likeArray = [Int]()
    var documentIDArrau = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
    }
    
    func getData() {
        
        let firestoreeDatabase = Firestore.firestore()
        firestoreeDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapsot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "hata")
                
            }else{
                if snapsot?.isEmpty != true && snapsot != nil{
                    
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.commentArrau.removeAll(keepingCapacity: false)
                    self.documentIDArrau.removeAll(keepingCapacity: false)
                    
                    for document in snapsot!.documents {
                        let documentID = document.documentID
                        self.documentIDArrau.append(documentID)
                        if let postedBy = document.get("postedBy") as? String{
                            self.usernameArray.append(postedBy)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.commentArrau.append(postComment)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.imageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = commentArrau[indexPath.row]
        cell.usernameLabel.text = usernameArray[indexPath.row]
        cell.userImage.sd_setImage(with: URL(string: self.imageArray[indexPath.row]))
        cell.documentIDLabel.text = documentIDArrau[indexPath.row]
        
        return cell
    }
    
    
    
    
}
