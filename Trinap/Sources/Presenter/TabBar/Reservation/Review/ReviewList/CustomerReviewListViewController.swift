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
    private lazy var reviewListTableView = UITableView().than {
        $0.tableHeaderView = UIView()
        $0.tableFooterView = UIView()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.view.addSubview(reviewListTableView)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        reviewListTableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureDataSource()
    }
    
    override func bind() {
        super.bind()
        
        let input = CustomerReviewListViewModel.Input()
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
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let backButtonImage = UIImage(systemName: "arrow.left")
        
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = TrinapAsset.white.color
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.scrollEdgeAppearance?.shadowColor = .clear
        self.navigationItem.title = "\(viewModel.userNickname)님의 리뷰"
    }
}
