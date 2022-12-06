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
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Contact>
    
    enum Section {
        case main
    }
    
    private var dataSource: DataSource?
    private let addTrigger = PublishSubject<Void>()
    
    private lazy var tableView = UITableView(frame: self.view.bounds, style: .plain)
    
    private lazy var addButton = UIButton().than {
        $0.imageView?.tintColor = TrinapAsset.black.color
        $0.setImage(UIImage(systemName: "circle.plus"), for: .normal)
    }
    
    private let viewModel: ContactListViewModel
    
    init(viewModel: ContactListViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    override func configureHierarchy() {
        self.view.addSubviews([tableView])
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        configureTableView()
        configureDataSource()
    }
    
    override func bind() {
        
        self.rx.viewWillAppear.subscribe(onNext: { _ in
            print("viewWillAppear")
        })
        .disposed(by: disposeBag)
        let input = ContactListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.map { _ in }.asObservable(),
            cellDidSelect: tableView.rx.itemSelected.compactMap {
                self.dataSource?.itemIdentifier(for: $0)?.contactId
            }
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .map { self.configureSnapshot($0) }
            .drive(onNext: {
                self.dataSource?.apply($0, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "문의 내역"
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = TrinapAsset.black.color
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(addContact))
    }
    
    @objc func addContact() {
        self.viewModel.showAddContactViewController()
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
