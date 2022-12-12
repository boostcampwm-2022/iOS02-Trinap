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

final class EditPhotographerViewController: BaseViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<PhotographerSection, PhotographerSection.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PhotographerSection, PhotographerSection.Item>
    
    private let tabState = BehaviorRelay<Int>(value: 0)
    private let isEditable = BehaviorRelay<Bool>(value: false)
    private let selectedPicture = BehaviorRelay<[Int]>(value: [])
    private let deleteTrigger = PublishSubject<Void>()
    private let portfolioUpdateTigger = PublishSubject<Void>()
    
    // MARK: - Properties
    weak var coordinator: MyPageCoordinator?
    
    private lazy var imagePicker = ImagePickerController()
    
    private let viewModel: EditPhotographerViewModel
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureCollectionViewLayout(.portfolio, isEditable: self.isEditable.value)
    )
    
    private lazy var defaultPhotographerView = DefaultEditPhotographerView()
    
    private var dataSource: DataSource?
    
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
        self.view.addSubviews([collectionView, defaultPhotographerView])
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 1.5, delay: 1.0) {
            self.defaultPhotographerView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(self.trinapOffset * 18)
            }
        }
    }
    
    override func bind() {
        
        self.isEditable
            .map { _ in [] }
            .bind(to: selectedPicture)
            .disposed(by: disposeBag)
        
        let willUploadImage = portfolioUpdateTigger
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.imagePicker
                    .pickImage()
                    .compactMap { $0.jpegData(compressionQuality: 0.7) }
            }
            .share()
        
        defaultPhotographerView.applyButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.defaultPhotographerView.type.rawValue
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, state in
                switch state {
                case 0:
                    owner.portfolioUpdateTigger.onNext(())
                case 1:
                    owner.coordinator?.showUpdatePhotographerViewController()
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
        let input = EditPhotographerViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            tabState: self.tabState.asObservable(),
            isEditable: self.isEditable.asObservable().distinctUntilChanged(),
            selectedPicture: self.selectedPicture
                .map { $0.compactMap { $0 }.map { $0 - 1 } }
                .asObservable(),
            uploadImage: willUploadImage,
            deleteTrigger: self.deleteTrigger.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        self.tabState
            .compactMap { PhotographerLayout(rawValue: $0) }
            .withUnretained(self)
            .subscribe(onNext: { owner, section in
                owner.collectionView.setCollectionViewLayout(
                    owner.configureCollectionViewLayout(section, isEditable: owner.isEditable.value),
                    animated: false
                )
                if section != .portfolio && self.isEditable.value {
                    self.isEditable.accept(false)
                }
            })
            .disposed(by: disposeBag)
        self.tabState
            .bind(to: defaultPhotographerView.rx.setState)
            .disposed(by: disposeBag)
        
        output.dataSource
            .compactMap { dataSource in
                self.generateSnapShot(dataSource)
            }
            .drive { snapshot in
                self.dataSource?.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { owner, indexPath -> Int? in
                if case let .photo(picture) = owner.dataSource?.itemIdentifier(for: indexPath) {
                    if picture?.picture == nil {
                        owner.portfolioUpdateTigger.onNext(())
                    } else {
                        if owner.isEditable.value {
                            return indexPath.row
                        } else {
                            owner.coordinator?.showDetailImageView(urlString: picture?.picture)
                            return nil
                        }
                    }
                }
                return nil
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, i in
                owner.selectedPicture.accept(owner.selectedPicture.value + [i])
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected
            .withUnretained(self)
            .compactMap { owner, indexPath -> Int? in
                if case .photo = owner.dataSource?.itemIdentifier(for: indexPath) {
                    return indexPath.row
                } else {
                    return nil
                }
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, pictureURL in
                let removedValue = owner.selectedPicture.value.filter { $0 != pictureURL }
                owner.selectedPicture.accept(removedValue)
            })
            .disposed(by: self.disposeBag)
        
        deleteTrigger
            .map { _ in false }
            .bind(to: isEditable)
            .disposed(by: disposeBag)
    }
    
    override func configureAttributes() {
        configureDataSource()
        configureCollectionView()
        imagePicker.delegate = self
        self.defaultPhotographerView.isHidden = true
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "작가 프로필 설정"
        self.navigationController?.navigationBar.tintColor = TrinapAsset.black.color
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
        collectionView.registerReusableView(EditPhotographerPhotoDeleteHeaderView.self)
        collectionView.allowsMultipleSelection = true
    }
    
    private func generateSnapShot(_ data: [PhotographerDataSource]) -> Snapshot {
        var snapshot = Snapshot()
        data.forEach { items in
            items.forEach { section, values in
                if !values.isEmpty {
                    snapshot.appendSections([section])
                    snapshot.appendItems(values, toSection: section)
                } else {
                    self.defaultPhotographerView.isHidden = false
                }
            }
        }
        
        return snapshot
    }
    
    private func configureDataSource() {
//        self.dataSource = PhotographerListSkeletonDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            <#code#>
//        })
        self.dataSource = DataSource(collectionView: self.collectionView) { [weak self] collectionView, indexPath, item in
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
                
                cell.editButton.rx.tap
                    .throttle(.seconds(1), scheduler: MainScheduler.instance)
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
                self.defaultPhotographerView.isHidden = true
                return cell
            case .detail(let information):
                guard let cell = collectionView.dequeueCell(PhotographerDetailIntroductionCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.configure(with: information)
                self.defaultPhotographerView.isHidden = true
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
        
        self.dataSource?.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let self else { return nil }
            
            switch kind {
            case EditPhotographerPhotoHeaderView.reuseIdentifier:
                
                guard let header = collectionView.dequeResuableView(EditPhotographerPhotoHeaderView.self, for: indexPath) else {
                    return UICollectionReusableView()
                }
                
                header.editButton.rx.tap
                    .subscribe(onNext: {
                        self.isEditable.accept(!self.isEditable.value)
                    })
                    .disposed(by: header.disposeBag)
                return header
                
            case EditPhotographerPhotoDeleteHeaderView.reuseIdentifier:
                
                guard let header = collectionView.dequeResuableView(EditPhotographerPhotoDeleteHeaderView.self, for: indexPath) else {
                    return UICollectionReusableView()
                }
                header.containerView.rx.tapGesture()
                    .when(.recognized)
                    .asObservable()
                    .map { _ in }
                    .bind(to: self.deleteTrigger)
                    .disposed(by: header.disposeBag)
                
                self.selectedPicture
                    .map { $0.count }
                    .bind(to: header.rx.setCount)
                    .disposed(by: self.disposeBag)
                
                return header
                
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    private func configureCollectionViewLayout(_ section: PhotographerLayout, isEditable: Bool) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { index, _ -> NSCollectionLayoutSection? in
            return section.createLayout(index: index, isEditable: isEditable)
        }
    }
}
