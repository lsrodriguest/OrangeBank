//
//  UIColor.swift
//  OrangeBank
//
//  Created by Luis Rodrigues on 24/01/2019.
//  Copyright © 2018 Luis Rodrigues. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(rgb: UInt, alpha: CGFloat) {
        
        self.init(
            red  : CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >>  8) / 255.0,
            blue : CGFloat((rgb & 0x0000FF) >>  0) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(rgb: UInt) {
        
        self.init(rgb: rgb, alpha: 1.0)
    }
}
