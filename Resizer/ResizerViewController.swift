//
//  ResizerViewController.swift
//  Resizer
//
//  Created by Vasyl Pedos on 11.04.17.
//  Copyright © 2017 Vasyl Pedos. All rights reserved.
//

import UIKit

class ResizerViewController: UIViewController {
	
	var size = CGSize(width: 512, height: 512)
	var options: Options = []
	var isAsyncronious = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "show.options", let optionsVC = segue.destination as? OptionsTableViewController {
			optionsVC.delegate = self
			optionsVC.dataSource = self
		}
	}
	
}

extension ResizerViewController: OptionsControllerDataSource {
	
}

extension ResizerViewController: OptionsControllerDelegate {
	
	func update(size: CGSize) {
		self.size = size
	}
	
	func update(options: Options) {
		self.options = options
	}
	
	func update(asyncronious: Bool) {
		self.isAsyncronious = asyncronious
	}
}
