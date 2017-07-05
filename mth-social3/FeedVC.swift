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
            print("GG")
            print(snapshot.value)
        })
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell")!
    }

 
}
