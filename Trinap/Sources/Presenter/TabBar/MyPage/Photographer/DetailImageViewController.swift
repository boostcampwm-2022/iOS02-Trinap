//
//  DetailImageViewController.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/02.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DetailImageViewController: BaseViewController {
    
    private var imageURL: URL? {
        didSet { configureImageView(url: imageURL) }
    }
    
    private lazy var imageView = UIImageView().than {
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var backbutton = UIButton().than {
        $0.contentMode = .scaleAspectFill
        $0.imageView?.tintColor = .white
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([imageView, backbutton])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func configureConstraints() {
        let size = self.view.frame.width
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(size)
        }
        
        backbutton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalToSuperview().offset(trinapOffset * 8)
        }
    }
    
    override func configureAttributes() {
        self.view.backgroundColor = TrinapAsset.black.color.withAlphaComponent(0.98)
    }
    
    override func bind() {
        backbutton.rx.tap
            .subscribe(onNext: {
                print("gd")
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func configureImageView(url: URL?) {
        self.imageView.kf.setImage(with: url)
    }
}
