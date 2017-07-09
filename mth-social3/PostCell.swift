//
//  PostCell.swift
//  mth-social3
//
//  Created by Myat Thu Hein on 7/4/17.
//  Copyright © 2017 Myat Thu Hein. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

   
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    
    
    var post : Post!
    var likeRef : FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    
    func configureCell(post: Post,img: UIImage? = nil) {
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likeLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        }else{
            
            let ref = FIRStorage.storage().reference(forURL: post.imgUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024,completion:{ (data,error) in
                if error != nil{
                    print("JESS: Unable to download image from FB storage")
                }else{
                    print("JESS: image downloaded from FB storage")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey:post.imgUrl as NSString)
                        }
                    }
                }
            
            })
            
        }
        
        
        likeRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImg.image = UIImage(named: "empty-heart")
            }else{
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
    }
    
    func likeTapped(sender:UITapGestureRecognizer){
        
        likeRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            }else{
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
        
    }

    

}
