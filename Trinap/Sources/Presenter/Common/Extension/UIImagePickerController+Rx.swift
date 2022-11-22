//
//  UIImagePickerController+Rx.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

enum ImagePickerAction {
    case photo(observer: AnyObserver<UIImage>)
}

enum ImagePickerError: Error {
    case unknown
    case cancelled
}

protocol ImagePickerDelegate: AnyObject {
    func present(picker: UIImagePickerController)
    func dismiss(picker: UIImagePickerController)
}

/**
 사용법
 
 ```
 class SomeViewController: UIViewController {
    
    private let imagePicker = ImagePickerController()
    
    init(...) {
        super.init(...)
 
        self.imagePicker.delegate = self
    }
 
    ...
    imagePicker.pickImage(source: ..., allowsEditing: ...) // <- 둘 다 Default로 지정되어 있습니다.
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { image in
            // processing image
        })
        .disposed(by: disposeBag)
 }
 ```
 */
final class ImagePickerController: NSObject {
    
    // MARK: - Properties
    weak var delegate: ImagePickerDelegate?
    private var action: ImagePickerAction?
    private var allowsEditing = false
    
    // MARK: - Initializer
    
    // MARK: - Methods
    func pickImage(
        source: UIImagePickerController.SourceType = .photoLibrary,
        allowsEditing: Bool = false
    ) -> Observable<UIImage> {
        self.allowsEditing = allowsEditing
        
        return Observable.create { [weak self] observer in
            guard let self else {
                observer.onError(ImagePickerError.unknown)
                return Disposables.create()
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = allowsEditing
            picker.delegate = self
            
            self.action = .photo(observer: observer)
            self.present(picker)
            
            return Disposables.create()
        }
    }
    
    private func present(_ uiImagePickerController: UIImagePickerController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.present(picker: uiImagePickerController)
        }
    }
    
    private func dismiss(_ uiImagePickerController: UIImagePickerController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.dismiss(picker: uiImagePickerController)
        }
    }
}

// MARK: - ImagePicker Delegate
extension ImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let action else { return }
        
        switch action {
        case .photo(let observer):
            acceptPhoto(info: info, observer: observer)
            dismiss(picker)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(picker)
        
        guard let action else { return }
        
        switch action {
        case .photo(let observer):
            observer.onCompleted()
        }
    }
    
    private func acceptPhoto(
        info: [UIImagePickerController.InfoKey: Any],
        observer: AnyObserver<UIImage>
    ) {
        var option: UIImagePickerController.InfoKey = .originalImage
        
        if allowsEditing {
            option = .editedImage
        }
        
        guard let image = info[option] as? UIImage else {
            observer.onError(ImagePickerError.unknown)
            return
        }
        
        observer.onNext(image)
        observer.onCompleted()
    }
}

// MARK: - Default Delegate
extension UIViewController: ImagePickerDelegate {
    
    func present(picker: UIImagePickerController) {
        self.present(picker, animated: true)
    }
    
    func dismiss(picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
