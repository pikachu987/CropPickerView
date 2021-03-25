//
//  ViewController.swift
//  CropPickerView
//
//  Created by pikachu987 on 11/28/2018.
//  Copyright (c) 2018 pikachu987. All rights reserved.
//

import UIKit
import CropPickerView

class ViewController: UIViewController {
    private let cropPickerView: CropPickerView = {
        let cropPickerView = CropPickerView(isSquare: true)
        cropPickerView.translatesAutoresizingMaskIntoConstraints = false
        cropPickerView.backgroundColor = .black
        return cropPickerView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        return descriptionLabel
    }()

    private let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 500
        slider.value = 0
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(self.cropPickerView)
        self.view.addSubview(self.slider)
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.descriptionLabel)
        
        var topConstant: CGFloat = UIApplication.shared.statusBarFrame.height
        if #available(iOS 11.0, *) {
            topConstant += UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
        self.view.addConstraints([
            NSLayoutConstraint(item: self.view!, attribute: .top, relatedBy: .equal, toItem: self.cropPickerView, attribute: .top, multiplier: 1, constant: -topConstant),
            NSLayoutConstraint(item: self.view!, attribute: .leading, relatedBy: .equal, toItem: self.cropPickerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: self.cropPickerView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        
        self.cropPickerView.addConstraints([
            NSLayoutConstraint(item: self.cropPickerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 200)
        ])
        
        self.view.addConstraints([
            NSLayoutConstraint(item: self.cropPickerView, attribute: .bottom, relatedBy: .equal, toItem: self.slider, attribute: .top, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: self.view!, attribute: .leading, relatedBy: .equal, toItem: self.slider, attribute: .leading, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: self.slider, attribute: .trailing, multiplier: 1, constant: 20)
        ])
        
        self.view.addConstraints([
            NSLayoutConstraint(item: self.slider, attribute: .bottom, relatedBy: .equal, toItem: self.imageView, attribute: .top, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: self.view!, attribute: .leading, relatedBy: .equal, toItem: self.imageView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: self.imageView, attribute: .trailing, multiplier: 1, constant: 0)
        ])

        self.imageView.addConstraints([
            NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 200)
        ])

        self.view.addConstraints([
            NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self.descriptionLabel, attribute: .top, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: self.view!, attribute: .leading, relatedBy: .equal, toItem: self.descriptionLabel, attribute: .leading, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: self.descriptionLabel, attribute: .trailing, multiplier: 1, constant: 8)
        ])
        
        self.cropPickerView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.cropTap(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshTap(_:)))
        let button = UIButton(type: .system)
        button.setTitle("Picture", for: .normal)
        button.addTarget(self, action: #selector(self.albumTap(_:)), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        self.slider.addTarget(self, action: #selector(self.radiusChange(_:)), for: .valueChanged)
    
        DispatchQueue.main.async {
            self.cropPickerView.image(UIImage(named: "1.png"))
        }
        
        //        self.cropPickerView.image = image
        //        self.cropPickerView.image(image, crop: CGRect(x: 50, y: 30, width: 100, height: 80), isRealCropRect: false)
        //        self.cropPickerView.image(image, crop: CGRect(x: 50, y: 30, width: 100, height: 80), isRealCropRect: true)
        //        self.cropPickerView.image(image, isMin: false, crop: CGRect(x: 50, y: 30, width: 100, height: 80), isRealCropRect: true)
        //        self.cropPickerView.image(image, isMin: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cropTap(_ sender: UIBarButtonItem) {
        self.cropPickerView.crop { (crop) in
            self.imageView.image = crop.image
            self.descriptionLabel.text = ""
            if let error = (crop.error as NSError?) {
                self.descriptionLabel.text?.append("\n\n-error\n\(error.localizedDescription)(\(error.code))")
            }
            if let value = crop.cropFrame {
                self.descriptionLabel.text?.append("\n\n-crop frame\n\(value)")
            }
            if let value = crop.realCropFrame {
                self.descriptionLabel.text?.append("\n\n-real crop frame\n\(value)")
            }
            if let value = crop.imageSize {
                self.descriptionLabel.text?.append("\n\n-before image size\n\(value)")
            }
        }
    }
    
    @objc func albumTap(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Album", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.mediaTypes = ["public.image"]
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.mediaTypes = ["public.image"]
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }

    @objc func refreshTap(_ sender: UIBarButtonItem) {
        let image = UIImage(named: "\(Int.random(in: 1...5)).png")
        self.cropPickerView.image(image)
    }
    
    @objc func radiusChange(_ sender: UISlider) {
        self.cropPickerView.radius = CGFloat(sender.value)
    }

}

// MARK: CropPickerViewDelegate
extension ViewController: CropPickerViewDelegate {
    func cropPickerView(_ cropPickerView: CropPickerView, result: CropResult) {

    }

    func cropPickerView(_ cropPickerView: CropPickerView, didChange frame: CGRect) {
        print("frame: \(frame)")
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        self.cropPickerView.image(image)
    }
}
