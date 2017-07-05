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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            print("JESS: ID found in keychain ")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }

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
                print("JESS::unable to authenticate with Firebase - \(error)")
            }
            else{
                print("JESS:SUccessfully authenticated with Firebaaes")}
            let userData = ["provider":credential.provider]

                self.completeSignIn(id: (user?.uid)!,userData:userData as! Dictionary<String, String>)
        })
    }
    @IBAction func signInBtn(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion:{(user,error) in
                
                
                if error == nil{
                    print("JESS: Email User authenticated with Firebase")
                    let userData = ["provider":user?.providerID]
                    self.completeSignIn(id: (user?.uid)!,userData: userData as! Dictionary<String, String>)
                }else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {(user,error)in
                        if error != nil{
                            print("JESS: Unable to authenticate with firebase using email")
                        }else{
                            
                            print("JESS: Successfully authenticated with Firebase using create email")
                            let userData = ["provider":user?.providerID]
                            self.completeSignIn(id: (user?.uid)!,userData: userData as! Dictionary<String, String>)
                        }
                    })
                }
            })
        
        }
        
    }
    
    func completeSignIn(id: String,userData: Dictionary<String,String>){
        
        DataService.ds.createFirebaseDBUser(uid:id,userData:userData)
        let saveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JESS: Data saved to keychain - \(saveSuccessful)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

