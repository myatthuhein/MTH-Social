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

   

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    
    
    var post : Post!
    func configureCell(post: Post,img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likeLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        }else{
            
            let ref = FIRStorage.storage().reference(forURL: post.imgUrl)
            ref.data(withMaxSize: 8 * 1024 * 1024,completion:{ (data,error) in
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
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
