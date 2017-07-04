//
//  CircleView.swift
//  mth-social3
//
//  Created by Myat Thu Hein on 7/2/17.
//  Copyright © 2017 Myat Thu Hein. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true

    }
    

}
