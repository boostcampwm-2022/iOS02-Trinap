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
        collectionViewLayout: configureCollectionViewLayout(.picture)
    )
    
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
    
    //TODO: 예약 관련 컴포넌트들 선언 및 연결
    
    // MARK: - Properties
    private let tabState = BehaviorRelay<Int>(value: 0)
    
    weak var coordinator: MainCoordinator?
    
    private let viewModel: PhotographerDetailViewModel
    
    private lazy var dataSource = configureDataSource()
    
    // MARK: - Initializers
    init(viewModel: PhotographerDetailViewModel) {
        self.viewModel = viewModel

        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.backgroundColor = .blue
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            collectionView,
            calendarButton,
            confirmButton
        ])
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
        }
        
        calendarButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(trinapOffset)
            make.leading.equalToSuperview().offset(trinapOffset)
            make.width.equalTo((view.frame.width - 4 * trinapOffset) / 2)
            make.height.equalTo(48)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(trinapOffset)
            make.trailing.equalToSuperview().offset(-trinapOffset)
            make.width.equalTo((view.frame.width - 2 * trinapOffset) / 2)
            make.height.equalTo(48)
        }
    }
    
    override func configureAttributes() {
        configureCollectionView()
    }
    
    override func bind() {
        let input = PhotographerDetailViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            tabState: self.tabState.asObservable()
//            confirmTrigger:
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

        output.resevationDates
            .drive { [weak self] dates in
                guard
                    let start = dates[safe: 0],
                    let end = dates[safe: 1]
                else { return }
                      
                self?.configureCalendarButton(startDate: start, endDate: end)
            }
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
                cell.configure(picture: picture)
                return cell
            case .detail(let information):
                guard let cell = collectionView.dequeueCell(PhotographerDetailIntroductionCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.configure(with: information)
                cell.isUserInteractionEnabled = false
                return cell
            case .review(let review):
                guard let cell = collectionView.dequeueCell(PhotographerReivewCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.configure(with: review)
                cell.isUserInteractionEnabled = false
                return cell
            case .summaryReview(let review):
                guard let cell = collectionView.dequeueCell(PhotographerSummaryReviewcell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.configure(with: review)
                cell.isUserInteractionEnabled = false
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

extension PhotographerDetailViewController {
    
    private func configureCalendarButton(startDate: Date, endDate: Date) {
        guard let dateInfo = formattingCalendarButtonText(
            startDate: startDate,
            endDate: endDate
        )
        else { return }
        
        calendarButton.titleLabel?.numberOfLines = 0
        calendarButton.titleLabel?.textAlignment = .left
        calendarButton.setTitle(nil, for: .normal)
        let buttonText = NSMutableAttributedString()
            .bold(string: dateInfo)
            .regular(string: "날짜 변경하기")
        calendarButton.setAttributedTitle(buttonText, for: .normal)
    }
    
    private func formattingCalendarButtonText(startDate: Date, endDate: Date) -> String? {
        let startSeperated = startDate.toString(type: .yearToSecond).components(separatedBy: " ")
        let endSeperated = endDate.toString(type: .yearToSecond).components(separatedBy: " ")
        
        guard let date = startSeperated[safe: 0] else { return nil }
        let dateSeperated = date.components(separatedBy: "-")
        guard
            let month = dateSeperated[safe: 1],
            let day = dateSeperated[safe: 2]
        else { return nil }
        
        guard
            let startTime = startSeperated.last,
            let endTime = endSeperated.last
        else { return nil }
        let startHourToSec = startTime.components(separatedBy: ":")
        let endHourToSec = endTime.components(separatedBy: ":")
        guard
            let startHour = startHourToSec[safe: 0],
            let startMin = startHourToSec[safe: 1],
            let endHour = endHourToSec[safe: 0],
            let endMin = endHourToSec[safe: 1]
        else { return nil }

        let reservationDate = "\(month)/\(day)"
        let reservationStart = "\(startHour):\(startMin)"
        let reservationEnd = "\(endHour):\(endMin)"
        let dateInfo = "\(reservationDate) \(reservationStart)-\(reservationEnd)\n"
        return dateInfo
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

