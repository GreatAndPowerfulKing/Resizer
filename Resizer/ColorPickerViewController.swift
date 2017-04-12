//
//  ColorPickerViewController.swift
//  Resizer
//
//  Created by Vasyl Pedos on 12.04.17.
//  Copyright © 2017 Vasyl Pedos. All rights reserved.
//

import UIKit

// MARK: - OptionsControllerDelegate

protocol ColorPickerDelegate: class {
	
	func colorChanged(_ color: UIColor)
	func colorSelected(_ color: UIColor, canceled: Bool)
}

// MARK: - OptionsControllerDataSource

protocol ColorPickeDataSource: class {
	
	var color: UIColor { get }
}

// MARK: - ColorPickerViewController

class ColorPickerViewController: UIViewController {
	
	weak var delegate: ColorPickerDelegate?
	weak var dataSource: ColorPickeDataSource? {
		didSet {
			reload()
		}
	}

	@IBOutlet weak var colorPicker: HRColorPickerView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		(colorPicker.colorMapView as? HRColorMapView)?.tileSize = 1
		
		reload()
	}
	
	func reload() {
		guard let dataSource = self.dataSource, isViewLoaded else {
			return
		}
		
		colorPicker.color = dataSource.color
	}
	
	@IBAction func cancel(_ sender: UIBarButtonItem) {
		endSelection(canceled: true)
	}
	
	@IBAction func done(_ sender: UIBarButtonItem) {
		endSelection()
	}
	
	@IBAction func colorChanged(_ sender: HRColorPickerView) {
		delegate?.colorChanged(sender.color)
	}
	
	private func endSelection(canceled: Bool = false) {
		delegate?.colorSelected(colorPicker.color, canceled: canceled)
		presentingViewController?.dismiss(animated: true, completion: nil)
	}
	
}

// MARK: - OptionsControllerDelegate default implementation

extension ColorPickerDelegate {
	
	func colorChanged(_ color: UIColor) { }
	func colorSelected(_ color: UIColor, canceled: Bool) { }
}
