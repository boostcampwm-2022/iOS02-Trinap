//
//  EditPhotographerPhotoHeaderView.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class EditPhotographerPhotoHeaderView: BaseCollectionReusableView {
    lazy var editButton = TrinapButton(style: .black, fillType: .border, isCircle: true)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        self.addSubview(editButton)
    }
    
    override func configureConstraints() {
        editButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        editButton.setTitle("포트폴리오 편집", for: .normal)
    }
}
