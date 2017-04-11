//
//  OptionsTableViewController.swift
//  Resizer
//
//  Created by Vasyl Pedos on 10.04.17.
//  Copyright © 2017 Vasyl Pedos. All rights reserved.
//

import UIKit

typealias Options = UIImage.ResizeOptions

// MARK: - OptionsControllerDelegate

protocol OptionsControllerDelegate: class {
	
	func update(size: CGSize)
	func update(options: Options)
	func update(asyncronious: Bool)
}

// MARK: - OptionsControllerDataSource

protocol OptionsControllerDataSource: class {
	
	var size: CGSize { get }
	var options: Options { get }
	var isAsyncronious: Bool { get }
}

// MARK: - OptionsTableViewController

class OptionsTableViewController: UITableViewController {
	
	weak var delegate: OptionsControllerDelegate?
	weak var dataSource: OptionsControllerDataSource? {
		didSet {
			reload()
		}
	}
	
	private var options: Options {
		get {
			var options: Options = []
			for cell in optionCells {
				if cell.isChecked {
					options.insert(cell.option)
				}
			}
			return options
		}
		set {
			for cell in optionCells {
				let isChecked = newValue.contains(cell.option)
				cell.isChecked = isChecked
			}
		}
	}
	
	// MARK: - Outlets
	
	@IBOutlet weak var widthTextField: UITextField!
	@IBOutlet weak var heightTextField: UITextField!
	@IBOutlet weak var asyncSwitch: UISwitch!
	
	@IBOutlet var optionCells: [OptionCell]!
	
	// MARK: - View Controller Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditing))
		toolbar.items = [flex, done]
		widthTextField.inputAccessoryView = toolbar
		heightTextField.inputAccessoryView = toolbar
		
		for (index, option) in optionsBinding {
			optionCells[safe: index]?.option = option
		}
		
		reload()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		endEditing()
	}
	
	func reload() {
		guard let dataSource = self.dataSource, isViewLoaded else {
			return
		}
		
		options = dataSource.options
		asyncSwitch.isOn = dataSource.isAsyncronious
		widthTextField.text = "\(Int(dataSource.size.width))"
		heightTextField.text = "\(Int(dataSource.size.height))"
	}
	
	@IBAction func asyncSwitched(_ sender: UISwitch) {
		delegate?.update(asyncronious: sender.isOn)
	}
	
	func endEditing() {
		view.endEditing(true)
		
		let width = Int(widthTextField.text ?? "0") ?? 0
		let height = Int(heightTextField.text ?? "0") ?? 0
		delegate?.update(size: CGSize(width: width, height: height))
	}

    // MARK: - Table delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		if let cell = optionCells[safe: indexPath.row] {
			cell.isChecked = !cell.isChecked
			delegate?.update(options: options)
		}
	}

}

// MARK: - OptionCell

class OptionCell: UITableViewCell {
	
	var option: Options = []
	
	var isChecked: Bool {
		get {
			return self.accessoryType == .checkmark
		}
		set {
			self.accessoryType = newValue ? .checkmark : .none
		}
	}
}

// [cell_index: UIImage.ResizeOptions]
private let optionsBinding: [Int: Options] = [
	0: .scale,
	1: .aspectFit,
	2: .aspectFill,
	3: .center,
	4: .top,
	5: .bottom,
	6: .left,
	7: .right
]
