//
//  Palette.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/28/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit

enum Palette {
    
    case lightBlue
    case white
    case black
    case borderDark
    
    var color: UIColor {
        switch self {
        case .lightBlue:
            return UIColor.rgb(r: 17, g: 154, b: 237)
        case .white:
            return UIColor(white: 1, alpha: 1)
        case .black:
            return UIColor(white: 0, alpha: 1)
        case .borderDark:
            return UIColor.init(white: 0, alpha: 0.2)
        }
    }
    
}

