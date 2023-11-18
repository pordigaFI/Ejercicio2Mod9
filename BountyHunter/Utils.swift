//
//  Utils.swift
//  BountyHunter
//
//  Created by Ángel González on 17/11/23.
//

import Foundation
import UIKit

class Utils {
    static func createButton (_ title:String, color:UIColor) -> UIButton {
        let boton = UIButton(type: .custom)
        boton.backgroundColor = color
        boton.setTitle(title, for:.normal)
        boton.layer.cornerRadius = 7.5
        return boton
    }
}
