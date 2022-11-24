//
//  PhotographerListViewController.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class PhotographerListViewController: BaseViewController {

    // MARK: - UI
    private lazy var searchBar = UISearchBar().than {
        $0.setImage(UIImage(named: "icSearchNonW"), for: UISearchBar.Icon.search, state: .normal)
        $0.placeholder = "추억을 만들 장소를 선택해주세요."
    }
    
    private lazy var filterView = FilterView(filterMode: .main)
    
//    private lazy var containerViewController = ContainerView
    
    // MARK: - Properties
    private let viewModel: PhotographerListViewModel
    var searchText = BehaviorRelay<String>(value: "")
    var coordinate = BehaviorRelay<Coordinate?>(value: nil)
    
    // MARK: - Initializers
    init(viewModel: PhotographerListViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }

    override func configureHierarchy() {
        self.view.addSubviews([
            searchBar,
            filterView
        ])
    }

    override func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        filterView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(trinapOffset)
            make.trailing.equalToSuperview().offset(-trinapOffset)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
    }

    override func configureAttributes() {
        searchBar.isUserInteractionEnabled = false
    }

    override func bind() {
        
        searchText.bind(to: searchBar.searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        let type = self.filterView.rx.itemSelected
            .map { TagType(index: $0.row) }
        let searchTrigger = searchBar.rx.tapGesture()
            .when(.recognized).asObservable()
            .map { _ in return () }
        
        let input = PhotographerListViewModel.Input(
            searchTrigger: searchTrigger,
            coordinate: coordinate.asObservable(),
            tagType: type,
            searchText: searchText
        )
        
        let output = viewModel.transform(input: input)
        
    }
}
