//
//  PhotosPickerController.swift
//  AssetsPicker
//
//  Created by Aymen Rebouh on 2018/10/16.
//  Copyright © 2018 eure. All rights reserved.
//

import UIKit
import enum Photos.PHAssetMediaType

public protocol AssetPickerDelegate: class {
    func photoPicker(_ pickerController: AssetPickerViewController, didPickImages images: [UIImage])
    func photoPickerDidCancel(_ pickerController: AssetPickerViewController)
}

let PhotoPickerPickImageNotificationName = NSNotification.Name(rawValue: "PhotoPickerPickImageNotification")
let PhotoPickerCancelNotificationName = NSNotification.Name(rawValue: "PhotoPickerCancelNotification")

public final class AssetPickerViewController : UINavigationController {
    
    // MARK: - Properties
    
    public weak var pickerDelegate: AssetPickerDelegate?
    
    // MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRootController: do  {
            let controller = SelectAssetCollectionContainerViewController()
            pushViewController(controller, animated: false)
        }
        
        setupPickImagesNotification: do {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(didPickImages(notification:)),
                                                   name: PhotoPickerPickImageNotificationName,
                                                   object: nil)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(didCancel(notification:)),
                                                   name: PhotoPickerCancelNotificationName,
                                                   object: nil)
        }
        setupNavigationBar: do {
            let dismissBarButtonItem = UIBarButtonItem(title: AssetPickerConfiguration.shared.localize.dismiss, style: .plain, target: self, action: #selector(dismissPicker(sender:)))
            navigationBar.topItem?.leftBarButtonItem = dismissBarButtonItem
            navigationBar.tintColor = AssetPickerConfiguration.shared.tintColor
        }
    }
    
    @objc func didPickImages(notification: Notification) {
        if let images = notification.object as? [UIImage] {
            self.pickerDelegate?.photoPicker(self, didPickImages: images)
        }
    }
    
    @objc func didCancel(notification: Notification) {
        self.pickerDelegate?.photoPickerDidCancel(self)
    }
    
    @objc func dismissPicker(sender: Any) {
        NotificationCenter.default.post(name: PhotoPickerCancelNotificationName, object: nil)
    }
}


// MARK: Builder pattern

extension AssetPickerViewController {
    public func setSelectionMode(_ selectionMode: SelectionMode) -> AssetPickerViewController {
        AssetPickerConfiguration.shared.selectionMode = selectionMode
        return self
    }
    
    public func setSelectionMode(_ selectionColor: UIColor) -> AssetPickerViewController {
        AssetPickerConfiguration.shared.selectionColor = selectionColor
        return self
    }
    
    public func setSelectionColor(_ tintColor: UIColor) -> AssetPickerViewController {
        AssetPickerConfiguration.shared.tintColor = tintColor
        return self
    }
    
    public func setNumberOfItemsPerRow(_ numberOfItemsPerRow: Int) -> AssetPickerViewController {
        AssetPickerConfiguration.shared.numberOfItemsPerRow = numberOfItemsPerRow
        return self
    }
    
    public func setHeaderView(_ headerView: UIView, isHeaderFloating: Bool) -> AssetPickerViewController {
        AssetPickerConfiguration.shared.headerView = headerView
        AssetPickerConfiguration.shared.isHeaderFloating = isHeaderFloating
        return self
    }
    
    public func setCellRegistrator(_ cellRegistrator: AssetPickerCellRegistrator) -> AssetPickerViewController {
        AssetPickerConfiguration.shared.cellRegistrator = cellRegistrator
        return self
    }
    
    public func setMediaTypes(_ supportOnlyMediaType: [PHAssetMediaType]) -> AssetPickerViewController {
        AssetPickerConfiguration.shared.supportOnlyMediaType = supportOnlyMediaType
        return self
    }
    
    public func disableOnLibraryScrollAnimation() -> AssetPickerViewController {
        AssetPickerConfiguration.shared.disableOnLibraryScrollAnimation = true
        return self
    }
    
    public func localize(_ localize: LocalizedStrings) -> AssetPickerViewController {
        AssetPickerConfiguration.shared.localize = localize
        return self
    }
}
