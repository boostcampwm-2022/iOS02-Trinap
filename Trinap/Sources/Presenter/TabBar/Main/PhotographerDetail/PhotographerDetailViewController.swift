//
//  PhotographerDetailViewController.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Than

class PhotographerDetailViewController: BaseViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<PhotographerSection, PhotographerSection.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PhotographerSection, PhotographerSection.Item>
    
    // MARK: - UI
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureCollectionViewLayout(.portfolio)
    ).than {
        $0.backgroundColor = TrinapAsset.white.color
    }
    
    private lazy var backgroundButtonView = UIView().than {
        $0.backgroundColor = TrinapAsset.white.color
    }
    
    private lazy var placeholderView = PhotographerPlaceholderView(isEditable: false)
    
    private lazy var calendarButton = TrinapButton(style: .primary, fillType: .border).than {
        $0.setTitle("예약 날짜 선택", for: .normal)
        $0.setTitleColor(TrinapAsset.primary.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 14)
    }
    
    private lazy var confirmButton = TrinapButton(style: .primary, fillType: .fill).than {
        $0.setTitle("예약 신청", for: .normal)
        $0.setTitleColor(TrinapAsset.white.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 14)
    }
    
    // MARK: - Properties
    private let tabState = BehaviorRelay<Int>(value: 0)
    private let viewModel: PhotographerDetailViewModel
    
    private lazy var dataSource = configureDataSource()
    
    // MARK: - Initializers
    init(viewModel: PhotographerDetailViewModel) {
        self.viewModel = viewModel

        super.init()
    }
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundButtonView.layer.addBorder([.top])
    }
    
    override func configureHierarchy() {
        backgroundButtonView.addSubviews([
            calendarButton,
            confirmButton
        ])
        
        self.view.addSubviews([
            collectionView,
            backgroundButtonView,
            placeholderView
        ])
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-88)
        }
        
        backgroundButtonView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }
        
        calendarButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(confirmButton.snp.width)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(calendarButton.snp.trailing).offset(8)
        }
        
        UIView.animate(withDuration: 1.5, delay: 1.0) {
            self.placeholderView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(self.trinapOffset * 18)
            }
        }
    }
    
    override func configureAttributes() {
        configureCollectionView()
        self.confirmButton.isEnabled = false
        self.placeholderView.isHidden = true
    }
    
    override func bind() {
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                if case let .photo(picture) = owner.dataSource.itemIdentifier(for: indexPath) {
                    owner.viewModel.showDetailImage(urlString: picture?.picture)
                }
            })
            .disposed(by: disposeBag)
        
        self.tabState
            .bind(to: placeholderView.rx.setState)
            .disposed(by: disposeBag)
        
        let input = PhotographerDetailViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            tabState: self.tabState.asObservable(),
            calendarTrigger: calendarButton.rx.tap.asObservable(),
            confirmTrigger: confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        self.tabState
            .compactMap { PhotographerLayout(rawValue: $0) }
            .withUnretained(self)
            .subscribe(onNext: { owner, section in
                owner.collectionView.setCollectionViewLayout(owner.configureCollectionViewLayout(section), animated: false)
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
        
        output.confirmButtonEnabled
            .drive(confirmButton.rx.enabled)
            .disposed(by: disposeBag)
        
        output.resevationDates
            .drive { [weak self] dateString in
                self?.configureCalendarButton(dateString: dateString)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func showActionSheet() {
        let alert = UIAlertController()
            .appendingAction(title: "신고하기", style: .default) { [weak self] in
                self?.viewModel.showSueController()
            }
            .appendingAction(title: "차단하기", style: .default) { [weak self] in
                self?.confirmBlock()
            }
            .appendingAction(title: "취소", style: .cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func confirmBlock() {
        self.viewModel.blockPhotographer()
            .asObservable()
            .subscribe(onNext: { [weak self] in
                let alert = TrinapAlert(
                    title: "차단 완료",
                    timeText: nil,
                    subtitle: "차단이 완료되었습니다.",
                    size: CGSize(width: 300, height: 170)
                )
                alert.addAction(title: "확인", style: .primary)
                alert.showAlert(navigationController: self?.navigationController)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - CollectionVIew
extension PhotographerDetailViewController {
    
    private func configureCollectionView() {
        collectionView.register(PhotographerProfileCell.self)
        collectionView.register(PhotographerDetailIntroductionCell.self)
        collectionView.register(PhotoCell.self)
        collectionView.register(PhotographerSummaryReviewcell.self)
        collectionView.register(PhotographerReivewCell.self)
    }
    
    private func generateSnapShot(_ data: [PhotographerDataSource]) -> Snapshot {
        var snapshot = Snapshot()
        data.forEach { items in
            items.forEach { section, values in
                if !values.isEmpty {
                    snapshot.appendSections([section])
                    snapshot.appendItems(values, toSection: section)
                } else {
                    self.placeholderView.isHidden = false
                }
            }
        }
        
        return snapshot
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            
            switch item {
            case let .profile(profile):
                guard let cell = collectionView.dequeueCell(PhotographerProfileCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                
                cell.filterView.rx.itemSelected
                    .map { $0.row }
                    .bind(to: self.tabState)
                    .disposed(by: self.disposeBag)
                
                cell.configure(with: profile)
                return cell
            case let .photo(picture):
                guard let cell = collectionView.dequeueCell(PhotoCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                self.placeholderView.isHidden = true
                cell.configure(picture: picture)
                return cell
            case .detail(let information):
                guard let cell = collectionView.dequeueCell(PhotographerDetailIntroductionCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                self.placeholderView.isHidden = true
                cell.configure(with: information)
                return cell
            case .review(let review):
                guard let cell = collectionView.dequeueCell(PhotographerReivewCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                self.placeholderView.isHidden = true
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
        return dataSource
    }
}


// MARK: - CollectionViewLayout
extension PhotographerDetailViewController {
    
    private func configureCollectionViewLayout(_ section: PhotographerLayout) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { index, _ -> NSCollectionLayoutSection? in
            return section.createLayout(index: index)
        }
    }
}

extension PhotographerDetailViewController {
    
    private func configureCalendarButton(dateString: String) {
        if dateString.isEmpty { return }
        
        calendarButton.titleLabel?.numberOfLines = 0
        calendarButton.titleLabel?.textAlignment = .left
        calendarButton.setTitle(nil, for: .normal)
        let buttonText = NSMutableAttributedString()
            .bold(string: dateString)
            .regular(string: "날짜 변경하기")
        calendarButton.setAttributedTitle(buttonText, for: .normal)
    }
}

private extension NSMutableAttributedString {

    func bold(string: String) -> NSMutableAttributedString {
        let font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }

    func regular(string: String) -> NSMutableAttributedString {
        let font = TrinapFontFamily.Pretendard.regular.font(size: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: TrinapAsset.subtext.color
        ]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}

// MARK: - Privates
private extension PhotographerDetailViewController {
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let backButtonImage = UIImage(systemName: "arrow.backward")
        
        appearance.configureWithOpaqueBackground()
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.shadowColor = TrinapAsset.white.color
        self.navigationController?.navigationBar.tintColor = .black
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.backButtonTitle = ""
        
        let buttonItem = UIBarButtonItem(
            image: TrinapAsset.dotdotdot.image,
            style: .plain,
            target: self,
            action: #selector(showActionSheet)
        )
        
        navigationItem.setRightBarButton(buttonItem, animated: false)
    }
}
