//
//  EditPhotographerPhotoDeleteHeaderView.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/28.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class EditPhotographerPhotoDeleteHeaderView: BaseCollectionReusableView {
    
    lazy var containerView = UIView().than {
        $0.layer.borderColor = TrinapAsset.black.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8.0
        $0.layer.masksToBounds = true
    }
    
    private lazy var countLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
    }
    
    private lazy var deleteLabel = UILabel().than {
        $0.textColor = TrinapAsset.gray40.color
        $0.text = "삭제"
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 14)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    override func layoutIfNeeded() {
        self.containerView.layer.cornerRadius = self.containerView.frame.height / 2
        super.layoutIfNeeded()
    }
    
    override func configureHierarchy() {
        self.addSubview(containerView)
        self.containerView.addSubviews([countLabel, deleteLabel])
    }
    
    override func configureConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(trinapOffset * 2)
        }
        
        deleteLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
        }
    }
    
    func configure(countText: NSMutableAttributedString, deleteColor: UIColor) {
        self.countLabel.attributedText = countText
        self.deleteLabel.textColor = deleteColor
    }
}

extension Reactive where Base: EditPhotographerPhotoDeleteHeaderView {
    var setCount: Binder<Int> {
        Binder(base) { headerView, count in
            let text = "\(count)개 선택"
            let attributedString = NSMutableAttributedString(string: text)
            let range = (text as NSString).range(of: "\(count)")
            attributedString.addAttributes([.foregroundColor: TrinapAsset.primary.color], range: range)
            headerView.configure(countText: attributedString, deleteColor: count == 0 ? TrinapAsset.background.color : TrinapAsset.primary.color)
        }
    }
}
