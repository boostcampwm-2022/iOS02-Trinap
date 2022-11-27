//
//  EditPhotographerViewController.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

enum PhotographerLayout: Int, CaseIterable {
    case picture
    case detail
    case review
}

final class EditPhotographerViewController: BaseViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<PhotographerSection, PhotographerSection.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PhotographerSection, PhotographerSection.Item>
    
    private let tabState = BehaviorRelay<Int>(value: 0)
    private let isEditable = BehaviorRelay<Bool>(value: false)
    private let selectedCell = BehaviorRelay<[Int]>(value: [])
    
    // MARK: - Properties
    weak var coordinator: MyPageCoordinator?
    
    private let viewModel: EditPhotographerViewModel
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureCollectionViewLayout(.picture)
    )
    
    private lazy var dataSource = configureDataSource()
    
    // MARK: - Initializers
    init(viewModel: EditPhotographerViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigation()
    }
    
    // MARK: - Configuration
    override func configureHierarchy() {
        self.view.addSubview(collectionView)
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        let input = EditPhotographerViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            tabState: self.tabState.asObservable(),
            isEditable: self.isEditable.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        self.tabState
            .compactMap { PhotographerLayout(rawValue: $0) }
            .withUnretained(self)
            .subscribe(onNext: { owner, section in
                owner.collectionView.setCollectionViewLayout(owner.configureCollectionViewLayout(section), animated: false)
                
                if section != .picture {
                    self.isEditable.accept(false)
                }
            })
            .disposed(by: disposeBag)

        output.dataSource
            .compactMap { dataSource in
                self.generateSnapShot(dataSource)
            }
            .drive { snapshot in
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        isEditable.subscribe { value in
            print(value)
        }
        .disposed(by: disposeBag)
    }
    
    override func configureAttributes() {
        configureCollectionView()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "작가 프로필 설정"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .black
    }
}

// MARK: - CollectionVIew
extension EditPhotographerViewController {
    
    private func configureCollectionView() {
        collectionView.register(EditPhotographerProfileCell.self)
        collectionView.registerReusableView(EditPhotographerPhotoHeaderView.self)
        collectionView.register(PhotographerDetailIntroductionCell.self)
        collectionView.register(PhotoCell.self)
        collectionView.register(PhotographerSummaryReviewcell.self)
        collectionView.register(PhotographerReivewCell.self)
    }
    
    private func generateSnapShot(_ data: [EditPhotographerDataSource]) -> Snapshot {
        var snapshot = Snapshot()
        
        data.forEach { items in
            items.forEach { section, values in
                snapshot.appendSections([section])
                snapshot.appendItems(values, toSection: section)
            }
        }
        
        return snapshot
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            
            switch item {
            case let .profile(profile):
                guard let cell = collectionView.dequeueCell(EditPhotographerProfileCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                
                cell.filterView.rx.itemSelected
                    .map { $0.row }
                    .bind(to: self.tabState)
                    .disposed(by: self.disposeBag)
                
                cell.rx.rxTap
                    .subscribe(onNext: {
                        self.coordinator?.showUpdatePhotographerViewController()
                    })
                    .disposed(by: self.disposeBag)
                
                cell.configure(with: profile)
                return cell
            case let .photo(picture):
                guard let cell = collectionView.dequeueCell(PhotoCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.configure(picture: picture)
                return cell
            case .detail(let information):
                guard let cell = collectionView.dequeueCell(PhotographerDetailIntroductionCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.configure(with: information)
                return cell
            case .review(let review):
                guard let cell = collectionView.dequeueCell(PhotographerReivewCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.configure(with: review)
                return cell
            case .summaryReview(let review):
                guard let cell = collectionView.dequeueCell(PhotographerSummaryReviewcell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.configure(with: review)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let self else { return nil }
            
            switch kind {
            case EditPhotographerPhotoHeaderView.reuseIdentifier:
                guard let header = collectionView.dequeResuableView(EditPhotographerPhotoHeaderView.self, for: indexPath) else {
                    return UICollectionReusableView()
                }
                header.rx.rxTap
                    .subscribe(onNext: {
                        self.isEditable.accept(!self.isEditable.value)
                    })
                    .disposed(by: self.disposeBag)
                return header
            default:
                return UICollectionReusableView()
            }
        }
        return dataSource
    }
}

// MARK: - CollectionViewLayout
extension EditPhotographerViewController {
    
    private func configureCollectionViewLayout(_ section: PhotographerLayout) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { index, _ -> NSCollectionLayoutSection? in
            switch section {
            case .picture:
                return self.photoSectionLayout(index: index)
            case .detail:
                return self.detailSectionLayout(index: index)
            case .review:
                return self.reviewSetionLayout(index: index)
            }
        }
    }
    
    private func photoSectionLayout(index: Int) -> NSCollectionLayoutSection {
        return index == 0 ? self.generateProfileLayout() : self.generatePhotoLayout()
    }
    
    private func detailSectionLayout(index: Int) -> NSCollectionLayoutSection {
        return index == 0 ? self.generateProfileLayout() : self.generateDetailLayout()
    }
    
    private func reviewSetionLayout(index: Int) -> NSCollectionLayoutSection {
        let isProfile = index == 0
        return isProfile ? generateProfileLayout() : index == 1 ? generateReviewRatingLayout() : generateReviewLayout()
    }
    
    /// 작가 프로필 ~ 필터포함
    private func generateProfileLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(trinapOffset * 19)
                ),
            subitems: [item]
        )
        
        return NSCollectionLayoutSection(group: group)
    }
    
    /// 사진 레이아웃
    private func generatePhotoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1 / 3)
        )
        
        let inset = trinapOffset / 2
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(trinapOffset * 6)
            ),
            elementKind: EditPhotographerPhotoHeaderView.reuseIdentifier,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: 0, bottom: 0, trailing: inset)
        return section
    }
    
    /// 상세 정보 레이아웃
    private func generateDetailLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(trinapOffset * 40)
                ),
            subitems: [item]
        )
        
        let offset = trinapOffset * 2
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: offset, leading: offset, bottom: offset, trailing: offset)
        return section
    }
    
    private func generateReviewRatingLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(trinapOffset * 8)),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let offset = trinapOffset * 2
        section.contentInsets = NSDirectionalEdgeInsets(
            top: offset,
            leading: offset,
            bottom: offset,
            trailing: offset
        )
        
        return section
    }
    
    private func generateReviewLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(trinapOffset * 12)),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let offset = trinapOffset * 2
        section.contentInsets = NSDirectionalEdgeInsets(
            top: offset,
            leading: offset,
            bottom: offset,
            trailing: offset
        )
        
        return section
    }
}
