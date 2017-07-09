//
//  Post.swift
//  mth-social3
//
//  Created by Myat Thu Hein on 7/5/17.
//  Copyright © 2017 Myat Thu Hein. All rights reserved.
//

import Foundation
import Firebase

class Post{

    private var _caption: String!
    private var _imgUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    var caption:String{
        return _caption
    }
    
    var imgUrl:String{
        return _imgUrl
    }
    
    var likes:Int{
        return _likes
    }
    
    var postKey:String{
        return _postKey
    }
    
    var postRef:FIRDatabaseReference{
        return _postRef
    }
    
    
    init(caption:String,imgUrl:String,likes:Int){
        self._caption = caption
        self._imgUrl = imgUrl
        self._likes = likes
    }
    
    init(postKey: String,postData: Dictionary<String,AnyObject>){
        self._postKey = postKey
        if let caption = postData["caption"]{
            self._caption = caption as! String
        }
        
        if let imgUrl = postData["imgUrl"]{
            self._imgUrl = imgUrl as! String
        }
        
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(postKey)
    }
    
    func adjustLikes(addLike:Bool){
        if addLike {
         self._likes = self._likes + 1
        }else{
         self._likes = self._likes - 1
        }
        
        postRef.child("likes").setValue(_likes)
    }
    
}
