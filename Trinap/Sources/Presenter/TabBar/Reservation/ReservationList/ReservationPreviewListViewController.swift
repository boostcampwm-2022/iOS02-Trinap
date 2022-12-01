//
//  ReservationPreviewListViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ReservationPreviewListViewController: BaseViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Reservation.Preview>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Reservation.Preview>
    
    enum Section {
        case main
    }
    
    // MARK: - UI
    private lazy var filterView = FilterView(filterMode: .reservation)
    
    // MARK: - Properties
    private lazy var reservationListTableView = UITableView().than {
        $0.separatorStyle = .none
        $0.rowHeight = 72.0
        $0.register(ReservationCell.self)
    }
    
    private var dataSource: DataSource?
    private let viewModel: ReservationPreviewListViewModel
    
    // MARK: - Initializers
    init(viewModel: ReservationPreviewListViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.view.addSubviews([filterView, reservationListTableView])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        filterView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        reservationListTableView.snp.makeConstraints { make in
            make.top.equalTo(self.filterView.snp.bottom).offset(2)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureDataSource()
    }
    
    override func bind() {
        super.bind()
        
        let reservationType = filterView.rx.itemSelected
            .withUnretained(self) { $0.filterMode(of: $1) }
            .startWith(.receive)
        
        let input = ReservationPreviewListViewModel.Input(reservationType: reservationType)
        let output = viewModel.transform(input: input)
        
        output.reservationPreviews
            .compactMap { [weak self] previews in
                self?.generateSnapshot(previews)
            }
            .drive(onNext: { [weak self] snapshot in
                self?.dataSource?.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        reservationListTableView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                self?.showReservationDetailViewController(at: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    private func showReservationDetailViewController(at indexPath: IndexPath) {
        guard let reservationPreview = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        
        viewModel.presentReservationDetail(reservationId: reservationPreview.reservationId)
    }
}

// MARK: - Privates
private extension ReservationPreviewListViewController {
    
    func configureDataSource() {
        self.dataSource = DataSource(tableView: reservationListTableView) { [weak self] tableView, indexPath, preview in
            guard
                let self,
                let cell = tableView.dequeueCell(ReservationCell.self, for: indexPath)
            else {
                return UITableViewCell()
            }
            
            let selectedIndexPath = self.filterView.indexPathsForSelectedItems?.first ?? IndexPath(item: 0, section: 0)
            cell.configureCell(preview, reservationFilter: self.filterMode(of: selectedIndexPath))
            
            return cell
        }
    }
    
    func generateSnapshot(_ previews: [Reservation.Preview]) -> Snapshot {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(previews)
        return snapshot
    }
    
    func filterMode(of indexPath: IndexPath) -> ReservationFilter {
        return ReservationFilter(rawValue: indexPath.item) ?? .receive
    }
}
