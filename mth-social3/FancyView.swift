//
//  FancyView.swift
//  mth-social3
//
//  Created by Myat Thu Hein on 6/27/17.
//  Copyright © 2017 Myat Thu Hein. All rights reserved.
//

import UIKit

class FancyView: UIView {
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }

}
