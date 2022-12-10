//
//  MockMyPageViewController.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/19.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxSwift

final class MyPageViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: MyPageViewModel
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    private var dataSource: UITableViewDiffableDataSource<MyPageSection, MyPageCellType>?
    // MARK: - Initializers
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        self.view.addSubview(tableView)
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureAttributes() {
        self.configureTableView()
        self.dataSource = generateDataSource()
    }
    
    override func bind() {
        let input = MyPageViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            cellDidSelect: self.tableView.rx.itemSelected.asObservable()
                .withUnretained(self)
                .map { owner, indexPath -> MyPageCellType? in
                    return owner.dataSource?.itemIdentifier(for: indexPath)
                }
                .compactMap { $0 }
        )
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .compactMap { [weak self] dataSource in
                self?.generateSnapshot(dataSource)
            }
            .drive { [weak self] snapshot in
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView
extension MyPageViewController: UITableViewDelegate {
    
    private func configureTableView() {
        tableView.register(ProfileCell.self)
        tableView.register(MyPageInfoCell.self)
        tableView.register(MyPageSwitchRow.self)
        
        tableView.separatorStyle = .none
    }
    
    private func generateDataSource() -> UITableViewDiffableDataSource<MyPageSection, MyPageCellType> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            
            switch item {
            case let .profile(user):
                guard let cell = tableView.dequeueCell(ProfileCell.self, for: indexPath) else {
                    return UITableViewCell()
                }
                cell.user = user
                return cell
            case let .photographerExposure(isExposure):
                guard let cell = tableView.dequeueCell(MyPageSwitchRow.self, for: indexPath) else {
                    return UITableViewCell()
                }
                cell.configure(isExposure: isExposure)
                
                cell.exposureSwitch.rx.controlEvent(.valueChanged)
                    .withUnretained(self)
                    .subscribe(onNext: { owner, _ in
                        owner.viewModel.updatePhotographerExposure(cell.exposureSwitch.isOn)
                    })
                    .disposed(by: cell.disposeBag)
                return cell
            default:
                guard let cell = tableView.dequeueCell(MyPageInfoCell.self, for: indexPath) else {
                    return UITableViewCell()
                }
                cell.type = item
                return cell
            }
        }
    }
    
    private func generateSnapshot(_ sources: [MyPageDataSource]) -> NSDiffableDataSourceSnapshot<MyPageSection, MyPageCellType> {
        var snapshot = NSDiffableDataSourceSnapshot<MyPageSection, MyPageCellType>()
        snapshot.appendSections(MyPageSection.allCases)
        
        sources.forEach { data in
            data.forEach { section, data in
                snapshot.appendItems(data, toSection: section)
            }
        }
        return snapshot
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = MyPageSection.allCases[section].title else { return nil }
        let view = MyPageSectionHeader()
        view.configure(with: title)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 0 || section == 3) ? .leastNormalMagnitude : 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let lastIndex = 3
        if section == lastIndex {
            return nil
        }
        let view = UIView()
        view.backgroundColor = TrinapAsset.background.color
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 185 : self.trinapOffset * 6
    }
}
