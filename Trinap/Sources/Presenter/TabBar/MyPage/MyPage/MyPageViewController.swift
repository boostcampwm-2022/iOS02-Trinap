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
    weak var coordinator: MyPageCoordinator?
    
    private let viewModel: MyPageViewModel
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var dataSource: UITableViewDiffableDataSource<MyPageSection, MyPageCellType> = generateDataSource()
    // MARK: - Initializers
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
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
        let input = MyPageViewModel.Input(viewWillAppear: self.rx.viewWillAppear.asObservable())
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .compactMap { [weak self] dataSource in
                self?.generateSnapshot(dataSource)
            }
            .drive { [weak self] snapshot in
                self?.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, indexPath in
                owner.showNextViewController(indexPath: indexPath)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView
extension MyPageViewController: UITableViewDelegate {
    
    private func configureTableView() {
        tableView.register(ProfileCell.self)
        tableView.register(MyPageInfoCell.self)
        tableView.separatorStyle = .none
    }
    
    private func generateDataSource() -> UITableViewDiffableDataSource<MyPageSection, MyPageCellType> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            if case let .profile(user) = itemIdentifier {
                guard let cell = tableView.dequeueCell(ProfileCell.self, for: indexPath) else {
                    return UITableViewCell()
                }
                cell.user = user
                cell.rx.rxShowViewController
                    .subscribe(onNext: { [weak self] _ in
                        self?.showNextViewController(indexPath: IndexPath(row: 0, section: 0))
                    })
                    .disposed(by: self.disposeBag)
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueCell(MyPageInfoCell.self, for: indexPath) else {
                    return UITableViewCell()
                }
                cell.type = itemIdentifier
                cell.selectionStyle = .none
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
    
    private func showNextViewController(indexPath: IndexPath) {
        guard let type = dataSource.itemIdentifier(for: indexPath) else { return }
        
        self.coordinator?.showNextView(state: type)
    }
}
