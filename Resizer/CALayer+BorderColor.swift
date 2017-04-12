//
//  CALayer+BorderColor.swift
//  Resizer
//
//  Created by Vasyl Pedos on 12.04.17.
//  Copyright © 2017 Vasyl Pedos. All rights reserved.
//

import UIKit

extension CALayer {
	
	var borderUIColor: UIColor {
		get {
			guard let color = self.borderColor else {
				return .clear
			}
			return UIColor(cgColor: color)
		}
		set {
			self.borderColor = newValue.cgColor
		}
	}
}
