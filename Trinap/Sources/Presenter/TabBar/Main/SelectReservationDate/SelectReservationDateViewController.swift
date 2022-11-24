//
//  SelectReservationDateViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/22.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxRelay
import HorizonCalendar
import SnapKit

enum TimeSection: String, Hashable {
    case startDate = "시작 시간"
    case endDate = "종료 시간"
}

struct ReservationDate: Hashable {
    let type: TimeSection
    let date: Date
}

final class SelectReservationDateViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var titleLabel = UILabel().than {
        $0.text = "원하시는 날짜와 시간을\n선택해 주세요"
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
        $0.numberOfLines = 0
    }
    
    private lazy var trinapCalenderView = TrinapCalendarView(
        type: TrinapCalendarView.CalendarType.singleSelect
    )
    
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
    private lazy var calendar = Calendar.current
    let creatDateUseCase = CreateReservationDateUseCase()
    var dataSource: ReservationDateDataSource?
    let selctedTime = PublishRelay<SelectedTime>()
    let viewModel = SelectReservationDateViewModel()
    // MARK: - Initializers
    //    init() {
    //        super.init()
    //
    //    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createDataSource()
        
        trinapCalenderView.selectedSingleDate
            .asObservable()
            .subscribe(onNext: { [weak self] date in
                guard let self else { return }
                let startDate = self.creatDateUseCase.createStartDate(date: date)
                let endDate = self.creatDateUseCase.createEndDate(date: startDate.first ?? Date())
                self.loadData(
                    startDate.map { ReservationDate(type: .startDate, date: $0) },
                    endDate.map { ReservationDate(type: .endDate, date: $0) }
                )
            })
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        //        let input = SelectReservationDateViewModel.Input(
        //            selectDoneButtonTap: self.selectDoneButton.rx.tap.asObservable(),
        //            startDate: self.collectionView.rx.itemSelected
        //                .asObservable()
        //                .compactMap { indexPath -> SelectedTime? in
        //                    guard let date = self.dataSource?.itemIdentifier(for: indexPath)?.date else {
        //                        return nil
        //                    }
        //                    if indexPath.section == 0 {
        //                        return SelectedTime(
        //                            date: date,
        //                            indexPath:
        //                                indexPath,
        //                            type: .startDate
        //                        )
        //                    }
        //                    return nil
        //                },
        //            endDate: self.collectionView.rx.itemSelected
        //                .asObservable()
        //                .compactMap { indexPath -> SelectedTime? in
        //                    guard let date = self.dataSource?.itemIdentifier(for: indexPath)?.date else {
        //                        return nil
        //                    }
        //                    if indexPath.section == 1 {
        //                        return SelectedTime(
        //                            date: date,
        //                            indexPath:
        //                                indexPath,
        //                            type: .endDate
        //                        )
        //                    }
        //                    return nil
        //                }
        //        )
        //
        //        viewModel.transform(input: input)
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

extension SelectReservationDateViewController {
    
    typealias ReservationDateDataSource = UICollectionViewDiffableDataSource<TimeSection, ReservationDate>
    typealias ReservationDateSnapshot = NSDiffableDataSourceSnapshot<TimeSection, ReservationDate>
    
    func createDataSource() {
        dataSource = ReservationDateDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueCell(TimeCell.self, for: indexPath)
                cell?.configureCell(with: item)
                return cell
            }
        )
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
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
        dataSource?.apply(snapshot)
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
        deselectSectionItem(collectionView, indexPath: indexPath)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let selectedDate = dataSource?.itemIdentifier(for: indexPath) {
            switch indexPath.section {
            case 0:
                // startDate 트리거
                if let otherIndexPath = getOtherSelectedIndexPath(collectionView, indexPath: indexPath),
                   let otherDate = dataSource?.itemIdentifier(for: otherIndexPath) {
                    if selectedDate.date >= otherDate.date {
                        let newEndDate = self.creatDateUseCase.calculateMinuteDate(date: selectedDate.date, minute: 30)
                        let endReservationDate = ReservationDate(type: .endDate, date: newEndDate)
                        let endReservationDateIndexPath = dataSource?.indexPath(for: endReservationDate)
                        self.deselectSectionItem(collectionView, indexPath: endReservationDateIndexPath)
                        collectionView.selectItem(at: endReservationDateIndexPath, animated: true, scrollPosition: .centeredHorizontally)
                    }
                } else {
                    let newEndDate = self.creatDateUseCase.calculateMinuteDate(date: selectedDate.date, minute: 30)
                    let endReservationDate = ReservationDate(type: .endDate, date: newEndDate)
                    let endReservationDateIndexPath = dataSource?.indexPath(for: endReservationDate)
                    collectionView.selectItem(at: endReservationDateIndexPath, animated: true, scrollPosition: .centeredHorizontally)
                }
            case 1:
                if let otherIndexPath = getOtherSelectedIndexPath(collectionView, indexPath: indexPath),
                   let otherDate = dataSource?.itemIdentifier(for: otherIndexPath) {
                    if selectedDate.date <= otherDate.date {
                        let newEndDate = self.creatDateUseCase.calculateMinuteDate(date: selectedDate.date, minute: -30)
                        let startReservationDate = ReservationDate(type: .startDate, date: newEndDate)
                        let startReservationDateIndexPath = dataSource?.indexPath(for: startReservationDate)
                        self.deselectSectionItem(collectionView, indexPath: startReservationDateIndexPath)
                        collectionView.selectItem(at: startReservationDateIndexPath, animated: true, scrollPosition: .centeredHorizontally)
                    }
                } else {
                    let newEndDate = self.creatDateUseCase.calculateMinuteDate(date: selectedDate.date, minute: -30)
                    let startReservationDate = ReservationDate(type: .startDate, date: newEndDate)
                    let startReservationDateIndexPath = dataSource?.indexPath(for: startReservationDate)
                    collectionView.selectItem(at: startReservationDateIndexPath, animated: true, scrollPosition: .centeredHorizontally)
                }
            default:
                break
            }
        }
        
        return true
    }
    
    func getOtherSelectedIndexPath(_ collectionView: UICollectionView, indexPath: IndexPath) -> IndexPath? {
        return collectionView.indexPathsForSelectedItems?.filter { $0.section != indexPath.section }.first
    }
    
    func deselectSectionItem(_ collectionView: UICollectionView, indexPath: IndexPath?) {
        guard let selectedItemSection = collectionView.indexPathsForSelectedItems,
              let indexPath = indexPath else { return }
        let selectedItemIndexPath = selectedItemSection.filter { $0.section == indexPath.section }
        
        if let indexPath = selectedItemIndexPath.last {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
}

struct SelectedTime {
    let date: Date
    let indexPath: IndexPath
    let type: TimeSection
}
