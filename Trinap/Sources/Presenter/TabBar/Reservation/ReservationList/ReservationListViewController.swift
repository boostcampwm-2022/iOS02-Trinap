//
//  ReservationListViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit

final class ReservationListViewController: BaseViewController {
    
    private enum Section {
        case main
    }
    
    // MARK: - UI
    private lazy var filterView = FilterView(filterMode: .reservation)
    
    // MARK: - Properties
    private lazy var reservationListTableView = UITableView().than {
        $0.separatorStyle = .none
        $0.register(ReservationCell.self)
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, Reservation>?
    
    // MARK: - Initializers
    
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
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureDataSource()
    }
}

// MARK: - Privates
private extension ReservationListViewController {
    
    func configureDataSource() {
        let dataSource = UITableViewDiffableDataSource<Section, Reservation>(
            tableView: self.reservationListTableView,
            cellProvider: reservationCellProvider
        )
    }
    
    func reservationCellProvider(tableView: UITableView, indexPath: IndexPath, item: Reservation) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(ReservationCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        
        return cell
    }
}
