//
//  UIColor+Hex.swift
//  Resizer
//
//  Created by Vasyl Pedos on 12.04.17.
//  Copyright © 2017 Vasyl Pedos. All rights reserved.
//

import UIKit

extension UIColor {
	
	/**
	Initialize `UIColor` from the hexademical representation
	
	- parameter argb: number with the following format 0xAARRGGBB
	*/
	convenience init(argb: UInt) {
		self.init(
			red: CGFloat((argb & 0x00FF0000) >> 16) / 255.0,
			green: CGFloat((argb & 0x0000FF00) >> 8) / 255.0,
			blue: CGFloat(argb & 0x000000FF) / 255.0,
			alpha: CGFloat((argb & 0xFF000000) >> 24) / 255.0)
	}
	
	/**
	Initialize `UIColor` from the hexademical representation
	
	- parameter rgb: number with the following format 0xRRGGBB
	- parameter alpha: alpha component
	*/
	convenience init(rgb: UInt, alpha: CGFloat = 1.0) {
		self.init(
			red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgb & 0x0000FF) / 255.0,
			alpha: alpha)
	}
	
	var rgb: UInt {
		var color: UInt = 0
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		self.getRed(&red, green: &green, blue: &blue, alpha: nil)
		color += UInt(red * 255) << 16
		color += UInt(green * 255) << 8
		color += UInt(blue * 255)
		return color
	}
	
	var argb: UInt {
		var color: UInt = 0
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		color += UInt(alpha * 255) << 24
		color += UInt(red * 255) << 16
		color += UInt(green * 255) << 8
		color += UInt(blue * 255)
		return color
	}
	
	
}
