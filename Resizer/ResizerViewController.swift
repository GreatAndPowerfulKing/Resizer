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
	var options: Options = [.aspectFit, .center]
	var isAsyncronious = true
	var color: UIColor = .clear
	
	// MARK: - Outlets
	
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var fitButton: UIBarButtonItem!
	@IBOutlet weak var realSizeButton: UIBarButtonItem!
	@IBOutlet weak var centerButton: UIBarButtonItem!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var scrollView: UIScrollView! {
		didSet {
			scrollView.delegate = self
			adjustContentSize()
		}
	}
	
	let imageView = UIImageView()
	
	// MARK: - View Controller Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		postInit()
		
		scrollView.addSubview(imageView)
		
		image = #imageLiteral(resourceName: "KPI")
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(appWillTerminate),
		                                       name: NSNotification.Name.UIApplicationWillTerminate,
		                                       object: UIApplication.shared)
	}
	
	private func postInit() {
		let defaults = UserDefaults.standard
		
		if let width = defaults.object(forKey: "size.width") as? Float,
		   let height = defaults.object(forKey: "size.height") as? Float {
			size = CGSize(width: Int(width), height: Int(height))
		}
		
		if let options = defaults.object(forKey: "options") as? Int {
			self.options = Options(rawValue: options)
		}
		
		if let isAsyncronious = defaults.object(forKey: "is_syncronious") as? Bool {
			self.isAsyncronious = isAsyncronious
		}
	}
	
	@objc private func appWillTerminate(_ notification: Notification) {
		let defaults = UserDefaults.standard
		defaults.set(Float(size.width), forKey: "size.width")
		defaults.set(Float(size.height), forKey: "size.height")
		defaults.set(options.rawValue, forKey: "options")
		defaults.set(isAsyncronious, forKey: "is_syncronious")
		defaults.synchronize()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "show.options", let optionsVC = segue.destination as? OptionsTableViewController {
			optionsVC.delegate = self
			optionsVC.dataSource = self
		}
	}
	
	// MARK: - Image related stuff
	
	var image: UIImage? {
		get {
			return imageView.image
		}
		set {
			guard let image = newValue else {
				return
			}
			
			imageView.image = nil
			
			if isAsyncronious {
				spinner.startAnimating()
				image.resized(to: size, with: options, background: color) { image in
					self.spinner.stopAnimating()
					self.setImage(image)
				}
			} else {
				self.setImage(image.resized(to: size, with: options, background: color))
			}
		}
	}
	
	private func setImage(_ image: UIImage?) {
		imageView.image = image
		imageView.sizeToFit()
		adjustContentSize()
		adjustContentInsets()
		fit(animated: false)
		center(animated: false)
	}
	
	var minimumZoomScale: CGFloat {
		guard let image = image else {
			return 1
		}
		
		return min(min(scrollView.frame.size.width / image.size.width,
		               scrollView.frame.size.height / image.size.height), 1)
	}
	
	var maximumZoomScale: CGFloat {
		return 2
	}
	
	fileprivate func load() {
		
		func imagePicker(sourceType: UIImagePickerControllerSourceType) -> UIImagePickerController {
			let imagePickerController = UIImagePickerController()
			imagePickerController.sourceType = sourceType
			imagePickerController.delegate = self
			return imagePickerController
		}
		
		let alertController = UIAlertController()
		
		let takePhoto = UIAlertAction(title: "Camera", style: .default) { _ in
			self.present(imagePicker(sourceType: .camera), animated: true)
		}
		
		let choosePhoto = UIAlertAction(title: "Photo Library", style: .default) { _ in
			self.present(imagePicker(sourceType: .photoLibrary), animated: true)
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		alertController.addAction(takePhoto)
		alertController.addAction(choosePhoto)
		alertController.addAction(cancel)
		
		alertController.actions[0].isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		alertController.actions[1].isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
		
		present(alertController, animated: true, completion: nil)
	}
	
	fileprivate func save() {
		guard let image = image else {
			return
		}
		let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		present(activityController, animated: true, completion: nil)
	}
	
	fileprivate func fit(animated: Bool = true) {
		scrollView.setZoomScale(minimumZoomScale, animated: animated)
	}
	
	fileprivate func realSize(animated: Bool = true) {
		scrollView.setZoomScale(1.0, animated: animated)
	}
	
	fileprivate func center(animated: Bool = true) {
		let xOffset = max((scrollView.contentSize.width - scrollView.frame.size.width) * 0.5, 0)
		let yOffset = max((scrollView.contentSize.height - scrollView.frame.size.height) * 0.5, 0)
		
		scrollView.setContentOffset(CGPoint(x: xOffset,
		                                    y: yOffset), animated: animated)
	}
	
	// MARK: - Scroll view adjustments
	
	fileprivate func adjustContentSize() {
		scrollView.setZoomScale(1.0, animated: false)
		imageView.sizeToFit()
		scrollView.contentSize = imageView.frame.size
		scrollView.minimumZoomScale = minimumZoomScale
		scrollView.maximumZoomScale = maximumZoomScale
	}
	
	fileprivate func adjustContentInsets() {
		let xOffset = max((scrollView.frame.size.width - scrollView.contentSize.width) * 0.5, 0)
		let yOffset = max((scrollView.frame.size.height - scrollView.contentSize.height) * 0.5, 0)
		
		imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + xOffset,
		                           y: scrollView.contentSize.height * 0.5 + yOffset)
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
	
	@IBAction func realSize(_ sender: UIBarButtonItem) {
		realSize()
	}
	
	@IBAction func center(_ sender: UIBarButtonItem) {
		center()
	}
	
}

// MARK: - Scroll view delegate

extension ResizerViewController: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		adjustContentInsets()
	}
}

// MARK: - Options data source

extension ResizerViewController: OptionsControllerDataSource {
	
}

// MARK: - Options delegate

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

// MARK: - Image picker delegate

extension ResizerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
			return
		}
		self.image = image
		picker.dismiss(animated: true, completion: nil)
	}
	
}
