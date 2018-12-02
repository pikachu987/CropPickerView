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

    @IBOutlet weak var cropPickerView: CropPickerView!
    @IBOutlet weak var imageView: UIImageView!
    
//    private let cropPickerViewTemp = CropPickerView(frame: CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: 400))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        cropPickerViewTemp.image = UIImage(named: "4.png")
//        self.view.addSubview(cropPickerViewTemp)
        
        self.cropPickerView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.cropTap(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshTap(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cropTap(_ sender: UIBarButtonItem) {
        self.cropPickerView.crop { (error, image) in
            if let error = (error as NSError?) {
                let alertController = UIAlertController(title: "Error", message: error.domain, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.imageView.image = image
        }
    }
    
    @objc func refreshTap(_ sender: UIBarButtonItem) {
        let image = UIImage(named: "\(Int.random(in: 1...6)).png")
        self.cropPickerView.image = image
    }

}

// MARK: CropPickerViewDelegate
extension ViewController: CropPickerViewDelegate {
    func cropPickerView(_ cropPickerView: CropPickerView, error: Error) {
        
    }
    func cropPickerView(_ cropPickerView: CropPickerView, image: UIImage) {
        
    }
}
