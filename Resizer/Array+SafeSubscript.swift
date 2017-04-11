//
//  Array+SafeSubscript.swift
//  Resizer
//
//  Created by Vasyl Pedos on 11.04.17.
//  Copyright © 2017 Vasyl Pedos. All rights reserved.
//

import Foundation

extension Array {
	
	subscript (safe index: Int?) -> Element? {
		guard let index = index, index >= 0 && index < count else {
			return nil
		}
		return self[index]
	}
	
}
