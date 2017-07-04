//
//  PostCell.swift
//  mth-social3
//
//  Created by Myat Thu Hein on 7/4/17.
//  Copyright © 2017 Myat Thu Hein. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

   

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
