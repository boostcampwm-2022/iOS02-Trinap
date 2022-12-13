//
//  ContactUsListViewController.swift
//  Trinap
//
//  Created by Doyun Park on 2022/12/06.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class ContactListViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var addButton = UIButton().than {
        $0.imageView?.tintColor = TrinapAsset.black.color
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    private lazy var navigationBarView = TrinapNavigationBarView().than {
        $0.setTitleText("문의 내역")
        $0.addRightButton(addButton)
    }
    
    private lazy var tableView = UITableView(frame: self.view.bounds, style: .plain).than {
        $0.separatorStyle = .none
    }
    
    private lazy var placeHolderView = PlaceHolderView(text: "문의 내역이 없어요.")
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Contact>
    
    enum Section {
        case main
    }
    
    private var dataSource: DataSource?
    
    private let viewModel: ContactListViewModel
    
    init(viewModel: ContactListViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([
            navigationBarView,
            tableView
        ])
    }
    
    override func configureConstraints() {
        navigationBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        configureTableView()
        configureDataSource()
    }
    
    override func bind() {
        let input = ContactListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.map { _ in }.asObservable(),
            cellDidSelect: tableView.rx.itemSelected
                .compactMap { self.dataSource?.itemIdentifier(for: $0)?.contactId }
                .asObservable(),
            addContactTap: self.addButton.rx.tap.asSignal(),
            backButtonTap: self.navigationBarView.backButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .map { contacts in
                self.configurePlaceHolderView(with: contacts)
                
                return self.configureSnapshot(contacts)
            }
            .drive(onNext: {
                self.dataSource?.apply($0, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func configurePlaceHolderView(with contacts: [Contact]) {
        if contacts.isEmpty {
            self.view.addSubview(self.placeHolderView)
            
            self.placeHolderView.snp.makeConstraints { make in
                make.top.equalTo(self.navigationBarView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        } else {
            self.placeHolderView.removeFromSuperview()
        }
    }
}

// MARK: - TableView
extension ContactListViewController: UITableViewDelegate {
    
    private func configureTableView() {
        self.tableView.rowHeight = trinapOffset * 6
        self.tableView.register(ContactTableViewCell.self)
    }
    
    private func configureDataSource() {
        self.dataSource = DataSource(tableView: self.tableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueCell(ContactTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            cell.selectionStyle = .none
            return cell
        })
    }
    
    private func configureSnapshot(_ data: [Contact]) -> NSDiffableDataSourceSnapshot<Section, Contact> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Contact>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
    
    
}
