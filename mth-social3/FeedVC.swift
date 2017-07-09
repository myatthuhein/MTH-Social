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
    @IBOutlet weak var captionField: FancyField!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!
    
    static var imageCache: NSCache<NSString,UIImage> = NSCache()
    
    var imageSelected = false

    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else{
            print("JESS: Caption must be entered.")
            return
        }
        guard let img = imageAdd.image,self.imageSelected == true else{
            print("JESS: An image must be selected.")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.0){
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata){(metadata,error) in
                if error != nil {
                    print("JESS: Unable to upload image to Firebase storage")
                }else{
                    print("JESS: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    self.postToFirebase(imgUrl: downloadURL!)
                    
                }
            }
        }
    }
    
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
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String,AnyObject> = [
        "caption": captionField.text as AnyObject,
        "imgUrl": imgUrl as AnyObject,
        "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageAdd.image = image
            imageSelected = true
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
                
            }else{
                cell.configureCell(post: post, img: nil)
                
            }
            return cell
        }
        else{
        return PostCell()
        }
      
    }

 
}
