//
//  Demo3ViewController.swift
//  AssetsPicker
//
//  Created by Aymen Rebouh on 2018/11/07.
//  Copyright © 2018 eureka, Inc. All rights reserved.
//

import UIKit.UIImage
import MosaiqueAssetsPicker

class Demo3ViewController: UIViewController {
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: User Interaction
    
    @IBAction func didTapPresentButton(_ sender: Any) {
        let assetNib = UINib(nibName: String(describing: Demo3AssetNib.self), bundle: nil)
        let assetCollectionNib = UINib(nibName: String(describing: Demo3AssetCollectionNib.self), bundle: nil)

        let cellRegistrator = AssetPickerCellRegistrator()
        cellRegistrator.register(nib: assetNib, forCellType: .asset)
        cellRegistrator.register(nib: assetCollectionNib, forCellType: .assetCollection)
        
        let photoPicker = MosaiqueAssetPickerViewController()
                            .setCellRegistrator(cellRegistrator)

        photoPicker.pickerDelegate = self
        
        present(photoPicker, animated: true, completion: nil)
    }
}

extension Demo3ViewController: MosaiqueAssetPickerDelegate {
    func photoPicker(_ pickerController: MosaiqueAssetPickerViewController, didPickImages images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
        print("main didPickImages = \(images)")
    }
    
    func photoPickerDidCancel(_ pickerController: MosaiqueAssetPickerViewController) {
        print("photoPickerDidCancel")
        self.dismiss(animated: true, completion: nil)
    }
}
