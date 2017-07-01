//
//  ViewController.swift
//  mth-social3
//
//  Created by Myat Thu Hein on 6/21/17.
//  Copyright © 2017 Myat Thu Hein. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = LoginManager()
        
        facebookLogin.logIn([.publicProfile], viewController: self){ loginResult in
            switch loginResult{
            case .failed(let error):
                print(error)
            case .cancelled:
                print("JESS:user cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("JESS:Logged in!")
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential:FIRAuthCredential){
        FIRAuth.auth()?.signIn(with:credential,completion:{ (user,error) in
            if error != nil{
                print("JESS::unable to uthenticate with Firebase - \(error)")
            }
            else{
                print("JESS:SUccessfully authenticated with Firebaaes")}
            })
    }
}

