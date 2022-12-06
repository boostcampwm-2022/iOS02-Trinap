//
//  CustomerReviewListViewController.swift
//  Trinap
//
//  Created by 김세영 on 2022/12/05.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class CustomerReviewListViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var backButton = UIButton().than {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = TrinapAsset.black.color
    }
    
    private lazy var titleLabel = UILabel().than {
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = TrinapAsset.black.color
    }
    
    private lazy var reviewListTableView = UITableView().than {
        $0.register(ReviewCell.self)
    }
    
    // MARK: - Properties
    private let viewModel: CustomerReviewListViewModel
    
    private var dataSource: UITableViewDiffableDataSource<Int, UserReview>?
    
    // MARK: - Initializers
    init(viewModel: CustomerReviewListViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.view.addSubviews([
            backButton,
            titleLabel,
            reviewListTableView
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(backButton)
        }
        
        reviewListTableView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureDataSource()
        self.titleLabel.text = "\(viewModel.userNickname)님의 리뷰"
    }
    
    override func bind() {
        super.bind()
        
        let input = CustomerReviewListViewModel.Input(backButtonTap: backButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.reviewList
            .withUnretained(self) { owner, reviews in
                return owner.generateSnapshot(reviews)
            }
            .bind(onNext: { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Privates
private extension CustomerReviewListViewController {
    
    func configureDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: reviewListTableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueCell(ReviewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            
            cell.configureCell(item)
            
            return cell
        }
    }
    
    func generateSnapshot(_ userReviews: [UserReview]) -> NSDiffableDataSourceSnapshot<Int, UserReview> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserReview>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(userReviews)
        
        return snapshot
    }
}
