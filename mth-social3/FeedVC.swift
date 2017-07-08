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

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageAdd: CircleView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!
    
    static var imageCache: NSCache<NSString,UIImage> = NSCache()

    @IBAction func signOutTapped(_ sender: Any) {
        
        
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: remove - \(removeSuccessful)")
        try! FIRAuth.auth()?.signOut()
        if(self.presentingViewController != nil){
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            tableView.delegate = self
            tableView.dataSource = self
        
            imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
        
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
    
    @IBAction func addImageTapped(_ sender: Any) {
            present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageAdd.image = image
        }else{
            print("JESS: A valid image wasn't selected")
        }

        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            var img:UIImage!
            if let img = FeedVC.imageCache.object(forKey: post.imgUrl as NSString){
                cell.configureCell(post: post, img: img)
                return cell
            }else{
                cell.configureCell(post: post, img: nil)
                return cell
            }
        }
        else{
        return PostCell()
        }
      
    }

 
}
