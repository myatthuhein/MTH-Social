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

class FeedVC: UIViewController {

    @IBAction func signInTapped(_ sender: Any) {
        
        
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: remove - \(removeSuccessful)")
        try! FIRAuth.auth()?.signOut()
        if(self.presentingViewController != nil){
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

 
}
