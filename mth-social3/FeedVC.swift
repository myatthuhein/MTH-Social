//
//  FeedVC.swift
//  mth-social3
//
//  Created by Myat Thu Hein on 7/1/17.
//  Copyright © 2017 Myat Thu Hein. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()

    @IBAction func signOutTapped(_ sender: Any) {
        
        
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: remove - \(removeSuccessful)")
        try! FIRAuth.auth()?.signOut()
        if(self.presentingViewController != nil){
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            tableView.delegate = self
            tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot{
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("JESS: \(post.caption)")
        return tableView.dequeueReusableCell(withIdentifier: "PostCell")!
    }

 
}
