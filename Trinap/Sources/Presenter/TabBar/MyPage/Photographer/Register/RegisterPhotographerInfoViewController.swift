//
//  RegisterPhotographerInfoViewController.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/24.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import RxGesture

struct TagItem: Hashable {
    let tag: TagType
    let isSelected: Bool
}

final class RegisterPhotographerInfoViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var navigationBarView = TrinapNavigationBarView().than {
        $0.setTitleText("작가 프로필 등록")
    }
    
    private lazy var titleLabel = UILabel().than {
        $0.text = "고객님을 위해\n작가님의 정보를 등록해주세요"
        $0.textColor = TrinapAsset.black.color
        $0.numberOfLines = 0
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
    }
    
    private lazy var locationTitleLabel = UILabel().than {
        $0.text = "활동 지역"
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var registerLocationView = RegisterLocationView()
    
    private lazy var tagTitleLabel = UILabel().than {
        $0.text = "태그 추가"
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var priceTitleLabel = UILabel().than {
        $0.text = "가격 정보"
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.numberOfLines = 0
    }
    
    private lazy var priceSubtitleLabel = UILabel().than {
        $0.text = "가격은 30분 단위로 책정할 수 있어요."
        $0.textColor = TrinapAsset.subtext.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 12)
    }
    
    private lazy var registerPriceView = RegisterPriceView()
    
    private lazy var introduceLabel = UILabel().than {
        $0.text = "소개글"
        $0.textColor = TrinapAsset.black.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
    }
    
    private lazy var timeUnitLabel = PaddingLabel(padding: UIEdgeInsets(top: 13, left: 5, bottom: 13, right: 5)).than {
        $0.textColor = TrinapAsset.primary.color
        $0.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
        $0.text = "30분"
        $0.backgroundColor = TrinapAsset.sub1.color
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private lazy var introducingTextView = UITextView().than {
        $0.font = TrinapFontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = TrinapAsset.subtext2.color
        $0.text = "작가님의 능력을 알려주세요!"
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TrinapAsset.background.color.cgColor
        $0.textContainerInset = UIEdgeInsets(top: trinapOffset * 2, left: trinapOffset * 2, bottom: trinapOffset * 2, right: trinapOffset * 2)
    }
    
    private lazy var applyButton = TrinapButton(style: .primary, fillType: .fill).than {
        $0.isEnabled = false
        $0.style = .disabled
        $0.setTitle("작성 완료", for: .normal)
    }
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: TagCollectionViewLeftAlignFlowLayout(offset: trinapOffset, direction: .vertical)).than {
        $0.backgroundColor = TrinapAsset.white.color
    }
    
    // MARK: - Properties
    private let selectedTags = BehaviorRelay<[TagType]>(value: [])
    private var dataSource: UICollectionViewDiffableDataSource<Int, TagItem>?
    private let viewModel: RegisterPhotographerInfoViewModel
    
    // MARK: - Initializers
    init(viewModel: RegisterPhotographerInfoViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Configure
    override func configureHierarchy() {
        self.view.addSubviews([
            navigationBarView,
            scrollView
        ])
        self.scrollView.addSubview(contentView)
        self.contentView.addSubviews([
            titleLabel,
            locationTitleLabel,
            registerLocationView,
            tagCollectionView,
            tagTitleLabel,
            priceTitleLabel,
            priceSubtitleLabel,
            timeUnitLabel,
            registerPriceView,
            introduceLabel,
            introducingTextView,
            applyButton
        ])
    }
    
    override func configureConstraints() {
        navigationBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trinapOffset * 6)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.top.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(trinapOffset * 3)
            make.leading.equalToSuperview().inset(trinapOffset * 2)
        }
        
        locationTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(titleLabel.snp.bottom).offset(trinapOffset * 3)
        }
        
        registerLocationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(trinapOffset * 2)
            make.height.equalTo(trinapOffset * 6)
            make.top.equalTo(locationTitleLabel.snp.bottom).offset(trinapOffset)
        }
        
        tagTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(registerLocationView.snp.bottom).offset(trinapOffset * 3)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(tagTitleLabel.snp.bottom).offset(trinapOffset)
            make.height.equalTo(trinapOffset * 11)
        }
        
        priceTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(tagCollectionView.snp.bottom).offset(trinapOffset * 3)
        }
        
        priceSubtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(trinapOffset / 2)
        }
        
        timeUnitLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(priceSubtitleLabel.snp.bottom).offset(trinapOffset)
        }
        
        registerPriceView.snp.makeConstraints { make in
            make.leading.equalTo(timeUnitLabel.snp.trailing).offset(trinapOffset)
            make.centerY.height.equalTo(timeUnitLabel)
            make.trailing.equalToSuperview().inset(trinapOffset * 2)
        }
        
        introduceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(timeUnitLabel.snp.bottom).offset(trinapOffset * 3)
        }
        
        introducingTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(introduceLabel.snp.bottom).offset(trinapOffset)
            make.height.equalTo(trinapOffset * 15)
        }
        
        applyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(trinapOffset * 2)
            make.top.equalTo(introducingTextView.snp.bottom).offset(trinapOffset * 5)
            make.height.equalTo(trinapOffset * 6)
        }
    }
    
    override func configureAttributes() {
        self.hideKeyboardWhenTapped()
        contentView.backgroundColor = TrinapAsset.white.color
        self.navigationController?.navigationBar.topItem?.title = ""
        configureCollectionView()
    }
    
    override func bind() {
        
        self.textViewBinding()
        self.collectionViewBinding()
        
        let price = registerPriceView.textField.rx.text.orEmpty.asObservable()
        
        let input = RegisterPhotographerInfoViewModel.Input(
            locationTrigger: registerLocationView.rx.tapGesture().when(.recognized).map { _ in },
            tags: self.selectedTags.asObservable(),
            priceText: price,
            introduction: introducingTextView.rx.text.orEmpty.asObservable(),
            applyTrigger: applyButton.rx.tap.asObservable(),
            backButtonTap: self.navigationBarView.backButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.price
            .bind(to: registerPriceView.rx.setValue)
            .disposed(by: disposeBag)
        
        output.location
            .subscribe(onNext: {
                self.registerLocationView.configure(text: $0)
            })
            .disposed(by: disposeBag)
        
        output.introduction
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                if !text.isEmpty {
                    owner.introducingTextView.text = text
                    owner.introducingTextView.textColor = TrinapAsset.black.color
                }
            })
            .disposed(by: disposeBag)
        
        output.tagItems
            .withUnretained(self)
            .subscribe(onNext: { owner, tagItem in
                let selectedTag = tagItem.filter { $0.isSelected }.map { $0.tag }
                owner.selectedTags.accept(selectedTag)
                
                let snapshot = owner.generateSnapshot(tagItem)
                owner.dataSource?.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        output.isValid
            .bind(to: applyButton.rx.enabled)
            .disposed(by: disposeBag)
    }
}

// MARK: - Binding
extension RegisterPhotographerInfoViewController {
    
    private func textViewBinding() {
        self.introducingTextView.rx.didBeginEditing
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if owner.introducingTextView.text == "작가님의 능력을 알려주세요!" {
                    owner.introducingTextView.text = nil
                    owner.introducingTextView.textColor = TrinapAsset.black.color
                }
            })
            .disposed(by: disposeBag)
        
        self.introducingTextView.rx.didEndEditing
            .withUnretained(self)
            .subscribe { owner, _ in
                if owner.introducingTextView.text.isEmpty {
                    owner.introducingTextView.text = "작가님의 능력을 알려주세요!"
                    owner.introducingTextView.textColor = TrinapAsset.subtext2.color
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func collectionViewBinding() {        
        tagCollectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { owner, indexPath in
                return owner.dataSource?.itemIdentifier(for: indexPath)?.tag
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, tag in
                owner.selectedTags.accept(owner.selectedTags.value + [tag])
            })
            .disposed(by: disposeBag)

        tagCollectionView.rx.itemDeselected
            .withUnretained(self)
            .compactMap { owner, indexPath in
                return owner.dataSource?.itemIdentifier(for: indexPath)?.tag
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, tag in
                let removedValue = owner.selectedTags.value.filter { $0 != tag }
                self.selectedTags.accept(removedValue)
            })
            .disposed(by: self.disposeBag)
    }
}
// MARK: - CollectionView
extension RegisterPhotographerInfoViewController: UICollectionViewDelegateFlowLayout {
    
    private func configureCollectionView() {
        self.tagCollectionView.register(TagCell.self)
        self.generateDataSource()
        self.tagCollectionView.allowsMultipleSelection = true
        self.tagCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func generateSnapshot(_ items: [TagItem]) -> NSDiffableDataSourceSnapshot<Int, TagItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TagItem>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        
        return snapshot
    }
    
    private func generateDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: tagCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueCell(TagCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configure(tag: itemIdentifier.tag)
            if itemIdentifier.isSelected {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = dataSource?.itemIdentifier(for: indexPath)?.tag.title else {
            return .zero
        }
        
        let width = "#\(text)".size(withAttributes: [NSAttributedString.Key.font: TrinapFontFamily.Pretendard.regular.font(size: 16)]).width + trinapOffset * 4
        
        return CGSize(width: width, height: trinapOffset * 5)
    }
}
