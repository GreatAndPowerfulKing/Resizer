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
	
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var fitButton: UIBarButtonItem!
	@IBOutlet weak var centerButton: UIBarButtonItem!
	@IBOutlet weak var scrollView: UIScrollView! {
		didSet {
			scrollView.delegate = self
			adjustContentSize()
		}
	}
	
	var imageView = UIImageView()
	
	var image: UIImage? {
		get {
			return imageView.image
		}
		set {
			imageView.image = newValue
			imageView.sizeToFit()
			adjustContentSize()
			adjustContentInsets()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollView.addSubview(imageView)
		
		image = #imageLiteral(resourceName: "KPI")
				
		fit()
		center()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "show.options", let optionsVC = segue.destination as? OptionsTableViewController {
			optionsVC.delegate = self
			optionsVC.dataSource = self
		}
	}
	
	fileprivate func load() {
		
	}
	
	fileprivate func save() {
		
	}
	
	fileprivate func fit() {
		scrollView.setZoomScale(1.0, animated: true)
	}
	
	fileprivate func center() {
		let xOffset = max((scrollView.contentSize.width - scrollView.frame.size.width) * 0.5, 0)
		let yOffset = max((scrollView.contentSize.height - scrollView.frame.size.height) * 0.5, 0)
		
		scrollView.setContentOffset(CGPoint(x: xOffset,
		                                    y: yOffset), animated: true)
	}
	
	// MARK: - IBActions
	
	@IBAction func load(_ sender: UIBarButtonItem) {
		load()
	}
	
	@IBAction func save(_ sender: UIBarButtonItem) {
		save()
	}
	
	@IBAction func fit(_ sender: UIBarButtonItem) {
		fit()
	}
	
	@IBAction func center(_ sender: UIBarButtonItem) {
		center()
	}
	
	fileprivate func adjustContentSize() {
		scrollView.contentSize = imageView.frame.size
		scrollView.minimumZoomScale = min(scrollView.frame.size.width / imageView.frame.size.width,
		                                  scrollView.frame.size.height / imageView.frame.size.height)
		scrollView.maximumZoomScale = 1.5
	}
	
	fileprivate func adjustContentInsets() {
		let xOffset = max((scrollView.frame.size.width - scrollView.contentSize.width) * 0.5, 0)
		let yOffset = max((scrollView.frame.size.height - scrollView.contentSize.height) * 0.5, 0)
		
		imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + xOffset,
		                           y: scrollView.contentSize.height * 0.5 + yOffset)
	}
	
}

extension ResizerViewController: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		adjustContentInsets()
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
