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

    // MARK: - Properties
    private let viewModel: PhotographerListViewModel

    // MARK: - Initializers
    init(viewModel: PhotographerListViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureHierarchy() {
        self.view.addSubviews([
        ])
    }

    override func configureConstraints() {
        <#view#>.snp.makeConstraints { make in
            make.<#code#>
        }
    }

    override func configureAttributes() {
        <#code#>
    }

    override func bind() {
        <#code#>
    }
}
