//
//  UpdateDetailPhotographerViewController.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class UpdateDetailPhotographerViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: UpdateDetailPhotographerViewModel
    
    private lazy var titleLabel = UILabel().than {
        $0.text = "고객님을 위해\n작가님의 정보를 등록해주세요"
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
    }
    
    private lazy var locationLabel = UILabel().than {
        $0.text = "활동 지역"
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var tagTitleLabel = UILabel().than {
        $0.text = "태그 추가"
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var priceTitleLabel = UILabel().than {
        $0.text = "가격 정보"
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var priceSubtitleLabel = UILabel().than {
        $0.text = "가격은 30분 단위로 책정할 수 있어요."
        $0.textColor = TrinapAsset.gray20.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 12)
    }
    
    private lazy var introduceLabel = UILabel().than {
        $0.text = "소개글"
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    // MARK: - Initializers
    init(viewModel: UpdateDetailPhotographerViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Configure
    override func configureHierarchy() {
        self.view.addSubviews([titleLabel, tagTitleLabel, priceTitleLabel, priceSubtitleLabel, introduceLabel])
    }
    
    override func configureConstraints() {

    }
    
    override func configureAttributes() {
        
    }
    
    override func bind() {
        
    }
}
