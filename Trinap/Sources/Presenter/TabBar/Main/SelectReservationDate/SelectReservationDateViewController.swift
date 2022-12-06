//
//  SelectReservationDateViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

final class SelectReservationDateViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var titleLabel = UILabel().than {
        $0.text = "원하시는 날짜와 시간을\n선택해 주세요"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
        $0.numberOfLines = 0
    }
    
    private lazy var trinapCalenderView = TrinapSingleSelectionCalendarView()
    
    private lazy var selectDoneButton = TrinapButton(style: .primary).than {
        $0.setTitle("선택 완료", for: .normal)
        $0.setTitleColor(TrinapAsset.white.color, for: .normal)
        $0.titleLabel?.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).than {
        $0.backgroundColor = TrinapAsset.white.color
        $0.register(TimeCell.self, forCellWithReuseIdentifier: TimeCell.reuseIdentifier)
        $0.register(
            TitleSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleSectionHeaderView.reuseIdentifier
        )
        $0.delegate = self
        $0.allowsMultipleSelection = true
        $0.isScrollEnabled = false
    }
    
    // MARK: - Properties
    private var dataSource: ReservationDateDataSource?
    private let viewModel: SelectReservationDateViewModel
    
    // MARK: - Initializers
    init(
        viewModel: SelectReservationDateViewModel
    ) {
        self.viewModel = viewModel
        super.init()
        self.createDataSource()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = SelectReservationDateViewModel.Input(
            calendarDateTap: self.trinapCalenderView.selectedSingleDate
                .asObservable()
                .compactMap { $0 },
            selectDoneButtonTap: self.selectDoneButton.rx.tap.asObservable(),
            selectedDate: self.transformSelectedItemToInput(),
            deselectedDate: self.transformDeselectedItemToInput()
        )
        
        let output = viewModel.transform(input: input)
        output.newSelectDate
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, reservationDate in
                owner.updateNewSelectDate(reservationDate)
            })
            .disposed(by: disposeBag)
        
        output.reservationTime
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.updateReservationTime(date: date)
            })
            .disposed(by: disposeBag)
        
        output.selectDoneButtonEnable
            .bind(to: self.selectDoneButton.rx.enabled)
            .disposed(by: disposeBag)
        
        output.fetchPossibleDate
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, possibleDate in
                owner.trinapCalenderView.configurePossibleDate(possibleDate: possibleDate)
            })
            .disposed(by: disposeBag)
        
        output.selectDone
            .withUnretained(self)
            .subscribe(onNext: { owner, isDone in
                if isDone {
                    owner.dismiss(animated: true)
                } else {
                    Logger.print("날짜선택 실패!")
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubviews([
            titleLabel,
            trinapCalenderView,
            collectionView,
            selectDoneButton
        ])
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(trinapOffset * 5)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(trinapOffset * 2)
        }
        
        trinapCalenderView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(trinapOffset * 3)
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel)
        }
        
        selectDoneButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(trinapOffset * 6)
            make.bottom.equalToSuperview().inset(trinapOffset * 4)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(trinapCalenderView.snp.bottom).offset(trinapOffset * 2)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(selectDoneButton.snp.top).offset(-trinapOffset)
        }
    }
}

private extension SelectReservationDateViewController {
    
    func transformSelectedItemToInput() -> Observable<ReservationDate> {
        return self.collectionView.rx.itemSelected
            .asObservable()
            .compactMap { [weak self] indexPath -> ReservationDate? in
                guard
                    let self,
                    let selectedDate = self.dataSource?.itemIdentifier(for: indexPath)
                else {
                    return nil
                }
                
                switch indexPath.section {
                case 0:
                    return ReservationDate(
                        date: selectedDate.date,
                        type: .startDate
                    )
                case 1:
                    return ReservationDate(
                        date: selectedDate.date,
                        type: .endDate
                    )
                default:
                    return nil
                }
            }
    }
    
    func transformDeselectedItemToInput() -> Observable<ReservationTimeSection> {
        return self.collectionView.rx.itemDeselected
            .asObservable()
            .compactMap { indexPath -> ReservationTimeSection? in
                switch indexPath.section {
                case 0:
                    return ReservationTimeSection.startDate
                case 1:
                    return ReservationTimeSection.endDate
                default:
                    return nil
                }
            }
    }
    
    func updateNewSelectDate(_ reservationDate: ReservationDate) {
        guard let indexPath = self.dataSource?.indexPath(for: reservationDate) else {
            return
        }
        self.deselectSectionItem(self.collectionView, indexPath: indexPath)
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func updateReservationTime(date: ([Date], [Date])) {
        let (startDate, endDate) = date
        self.loadData(
            startDate.map { ReservationDate(date: $0, type: .startDate) },
            endDate.map { ReservationDate(date: $0, type: .endDate) }
        )
    }
}

extension SelectReservationDateViewController {
    
    typealias ReservationDateDataSource = UICollectionViewDiffableDataSource<ReservationTimeSection, ReservationDate>
    typealias ReservationDateSnapshot = NSDiffableDataSourceSnapshot<ReservationTimeSection, ReservationDate>
    
    func createDataSource() {
        self.dataSource = ReservationDateDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueCell(TimeCell.self, for: indexPath)
                cell?.configureCell(with: item)
                return cell
            }
        )
        
        self.dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard
                kind == UICollectionView.elementKindSectionHeader,
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: TitleSectionHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? TitleSectionHeaderView,
                let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            else {
                return UICollectionReusableView()
            }
            view.configureHeaderView(title: section.rawValue)
            return view
        }
    }
    
    func loadData(_ startDate: [ReservationDate], _ endDate: [ReservationDate]) {
        var snapshot = ReservationDateSnapshot()
        snapshot.appendSections([.startDate, .endDate])
        snapshot.appendItems(startDate, toSection: .startDate)
        snapshot.appendItems(endDate, toSection: .endDate)
        self.dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1 / 6),
                    heightDimension: .fractionalWidth(1 / 11)
                ),
                subitems: [item]
            )
            
            let trinapDoubleOffset = self.trinapOffset * 2
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = self.trinapOffset
            section.contentInsets = .init(
                top: self.trinapOffset,
                leading: trinapDoubleOffset,
                bottom: trinapDoubleOffset,
                trailing: trinapDoubleOffset
            )
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .estimated(1),
                heightDimension: .estimated(1)
            )
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
}

extension SelectReservationDateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.deselectSectionItem(collectionView, indexPath: indexPath)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        return true
    }
    
    func deselectSectionItem(_ collectionView: UICollectionView, indexPath: IndexPath?) {
        guard
            let selectedItemSection = collectionView.indexPathsForSelectedItems,
            let indexPath = indexPath
        else {
            return
        }
        let selectedItemIndexPath = selectedItemSection.filter { $0.section == indexPath.section }
        
        if let indexPath = selectedItemIndexPath.last {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
}
