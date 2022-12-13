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
    private lazy var reservationFilterView = ReservationFilterView()
    
    private lazy var placeHolderView = PlaceHolderView(text: "아직 받은 예약이 없어요.")
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.view.addSubviews([reservationListTableView])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        reservationListTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureDataSource()
    }
    
    override func bind() {
        super.bind()
        
        let reservationType = reservationFilterView.rx.selectedSegmentIndex
            .withUnretained(self) { $0.filterMode(of: $1) }
            .startWith(.receive)
            .do(onNext: { [weak self] filterMode in
                switch filterMode {
                case .receive:
                    self?.placeHolderView.updateDescriptionText("아직 받은 예약이 없어요.")
                case .send:
                    self?.placeHolderView.updateDescriptionText("아직 보낸 예약이 없어요.")
                }
            })
        
        let input = ReservationPreviewListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.map { _ in return },
            reservationType: reservationType
        )
        let output = viewModel.transform(input: input)
        
        output.reservationPreviews
            .compactMap { [weak self] previews in
                self?.configurePlaceHolderView(with: previews)
                
                return self?.generateSnapshot(previews)
            }
            .drive(onNext: { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
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
            
            let selectedIndexPath = self.reservationFilterView.selectedSegmentIndex
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
    
    func filterMode(of index: Int) -> ReservationFilter {
        return ReservationFilter(rawValue: index) ?? .receive
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = TrinapAsset.white.color
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.titleView = reservationFilterView
        self.navigationItem.backButtonTitle = ""
    }
    
    func configurePlaceHolderView(with previews: [Reservation.Preview]) {
        if previews.isEmpty {
            self.view.addSubview(self.placeHolderView)
            
            self.placeHolderView.snp.makeConstraints { make in
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            }
        } else {
            self.placeHolderView.removeFromSuperview()
        }
    }
}
