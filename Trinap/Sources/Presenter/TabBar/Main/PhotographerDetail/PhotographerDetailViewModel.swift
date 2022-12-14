//  PhotographerDetailViewModel.swift
//  Trinap
//
//  Created by kimchansoo on 2022/11/29.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class PhotographerDetailViewModel: ViewModelType {

    struct Input {
        let viewWillAppear: Observable<Bool>
        let tabState: Observable<Int>
        let calendarTrigger: Observable<Void>
        let confirmTrigger: Observable<Void>
    }

    struct Output {
        let confirmButtonEnabled: Driver<Bool>
        let resevationDates: Driver<String>
        let dataSource: Driver<[PhotographerDataSource]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    private let createReservationUseCase: CreateReservationUseCase
    private let createBlockUseCase: CreateBlockUseCase
    private let createChatroomUseCase: CreateChatroomUseCase
    private let sendFirstChatUseCase: SendFirstChatUseCase
    private let convertDateToStringUseCase: ConvertDateToStringUseCase
    private let fetchPhotographerUserUseCase: FetchPhotographerUserUseCase
    private let fetchReviewInformationUseCase: FetchReviewInformationUseCase
    
    private let reloadTrigger = PublishRelay<Void>()
    
    private let searchCoordinate: Coordinate
    private let userId: String
    private var reservationDates = BehaviorRelay<[Date]>(value: [])
    
    private weak var coordinator: PhotographerDetailCoordinator?
    
    // MARK: - Initializer
    init(
        createReservationUseCase: CreateReservationUseCase,
        createBlockUseCase: CreateBlockUseCase,
        createChatroomUseCase: CreateChatroomUseCase,
        sendFirstChatUseCase: SendFirstChatUseCase,
        convertDateToStringUseCase: ConvertDateToStringUseCase,
        fetchPhotographerUserUseCase: FetchPhotographerUserUseCase,
        fetchReviewInformationUseCase: FetchReviewInformationUseCase,
        userId: String,
        searchCoordinate: Coordinate,
        coordinator: PhotographerDetailCoordinator?
    ) {
        self.createReservationUseCase = createReservationUseCase
        self.createBlockUseCase = createBlockUseCase
        self.fetchPhotographerUserUseCase = fetchPhotographerUserUseCase
        self.fetchReviewInformationUseCase = fetchReviewInformationUseCase
        self.createChatroomUseCase = createChatroomUseCase
        self.sendFirstChatUseCase = sendFirstChatUseCase
        self.convertDateToStringUseCase = convertDateToStringUseCase
        self.coordinator = coordinator
        self.searchCoordinate = searchCoordinate
        self.userId = userId
    }

    // MARK: - Methods
    func transform(input: Input) -> Output {
        let photographer = fetchPhotographerUserUseCase.fetch(userId: userId)
        let reviewInformation = fetchReviewInformationUseCase.fetch(photographerUserId: userId)
        let buttonAvailable = reservationDates.map { $0.count == 2 }
        
        requestReservation(confirmTrigger: input.confirmTrigger)
        showCalendar(calendarTrigger: input.calendarTrigger, photographer: photographer)
        
        let dataSource = Observable.combineLatest(input.tabState, photographer, reviewInformation)
            .map { [weak self] section, photographer, review -> [PhotographerDataSource] in
                guard let self else { return [] }
                
                return self.mappingDataSource(isEditable: false, state: section, photographer: photographer, review: review)
            }
            .asDriver(onErrorPresentAlertTo: coordinator, andReturn: []) { [weak self] in
                self?.coordinator?.popViewController()
            }
        
        let reservationDates = reservationDates.asDriver(onErrorJustReturn: [])
            .map { [weak self] dates -> String in
                guard
                    let start = dates[safe: 0],
                    let end = dates[safe: 1]
                else { return "" }
                
                return self?.convertDateToStringUseCase.convert(startDate: start, endDate: end) ?? ""
            }

        return Output(
            confirmButtonEnabled: buttonAvailable.asDriver(onErrorJustReturn: false),
            resevationDates: reservationDates,
            dataSource: dataSource
        )
    }
    
    private func showAlert() -> Observable<Bool> {
        return Observable.create { [weak self] observable in
            guard
                let dates = self?.reservationDates.value,
                let startDate = dates[safe: 0],
                let endDate = dates[safe: 1]
            else {
                observable.onNext(false)
                return Disposables.create()
            }
            
            let alert = TrinapAlert(
                title: "예약을 확인해주세요",
                timeText: self?.convertDateToStringUseCase.convert(
                    startDate: startDate,
                    endDate: endDate
                ),
                subtitle: "선택한 날짜로 예약 신청하시겠어요?"
            )
            alert.addAction(title: "확인", style: .primary) {
                observable.onNext(true)
            }
            alert.addAction(title: "취소", style: .disabled) {
                Logger.print("취소")
                observable.onNext(false)
            }
            alert.showAlert(navigationController: self?.coordinator?.navigationController)
            return Disposables.create()
        }
    }
    
    func showDetailImage(urlString: String?) {
        coordinator?.showDetailImageView(urlString: urlString)
    }
    
    func showSueController() {
        coordinator?.showSueController(suedUserId: self.userId)
    }
}

// MARK: - Privates
private extension PhotographerDetailViewModel {
    
    func requestReservation(confirmTrigger: Observable<Void>) {
        confirmAlert(confirmTrigger)
            .withLatestFrom(reservationDates.asObservable())
            .withUnretained(self)
            .flatMap { $0.createAndSendReservationChat(at: $1) }
            .subscribe(
                onNext: { [weak self] chatroomId, nickname in
                    self?.coordinator?.connectChatDetailCoordinator(
                        chatroomId: chatroomId,
                        photographerNickname: nickname
                    )
                },
                onError: { [weak self] error in
                    self?.coordinator?.presentErrorAlert(message: error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func confirmAlert(_ confirmTrigger: Observable<Void>) -> Observable<Bool> {
        return confirmTrigger
            .withUnretained(self)
            .flatMap { $0.0.showAlert() }
            .filter { $0 }
            .distinctUntilChanged()
    }
    
    func createAndSendReservationChat(at dates: [Date]) -> Observable<(String, String)> {
        return createReservation(dates: dates)
            .withUnretained(self)
            .flatMap { $0.createChatroom(reservationId: $1) }
            .withUnretained(self)
            .flatMap { $0.sendFirstChat(chatroomId: $1.0, reservationId: $1.1) }
            .withUnretained(self)
            .flatMap { owner, chatroomId in
                return owner.fetchPhotographerUserUseCase.fetch(userId: owner.userId)
                    .map { return (chatroomId, $0.nickname) }
            }
    }
    
    func createReservation(dates: [Date]) -> Observable<String> {
        guard
            let start = dates[safe: 0],
            let end = dates[safe: 1]
        else { return Observable.just("") }

        return createReservationUseCase.create(
            photographerUserId: userId,
            startDate: start,
            endDate: end,
            coordinate: searchCoordinate
        )
    }
    
    func createChatroom(reservationId: String) -> Observable<(String, String)> {
        return createChatroomUseCase.create(photographerUserId: userId)
            .map { ($0, reservationId) }
    }
    
    func sendFirstChat(chatroomId: String, reservationId: String) -> Observable<String> {
        return sendFirstChatUseCase.send(chatroomId: chatroomId, reservationId: reservationId)
            .map { _ in return chatroomId }
    }
    
    func showCalendar(calendarTrigger: Observable<Void>, photographer: Observable<PhotographerUser>) {
        calendarTrigger.withLatestFrom(photographer)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                let photographerUser = value
                owner.coordinator?.showSelectReservationDateViewController(
                    with: photographerUser.possibleDate,
                    detailViewModel: self
                )
            })
            .disposed(by: disposeBag)
    }
}

extension PhotographerDetailViewModel {
    
    private func mappingDataSource(isEditable: Bool, state: Int, photographer: PhotographerUser, review: ReviewInformation) -> [PhotographerDataSource] {
        
        switch state {
        case 0:
            return [mappingProfileDataSource(photographer: photographer)] + [mappingPictureDataSource(isEditable: isEditable, photographer: photographer)]
        case 1:
            return [mappingProfileDataSource(photographer: photographer)] + [mappingDetailDataSource(photographer: photographer)]
        case 2:
            return [mappingProfileDataSource(photographer: photographer)] + mappingReviewDataSource(review: review)
        default:
            return []
        }
    }
    
    private func updatePictureState(isEditable: Bool, pictures: [Picture?]) -> [Picture?] {
        return pictures.map { picture in
            return Picture(isEditable: isEditable, picture: picture?.picture)
        }
    }
}

// MARK: - MappingDataSource
private extension PhotographerDetailViewModel {
    
    func mappingProfileDataSource(photographer: PhotographerUser) -> PhotographerDataSource {
        return [PhotographerSection.profile: [PhotographerSection.Item.profile(photographer)]]
    }
    
    func mappingPictureDataSource(isEditable: Bool, photographer: PhotographerUser) -> PhotographerDataSource {
        if photographer.pictures.isEmpty {
            return [PhotographerSection.photo: []]
        }
        
        return [PhotographerSection.photo: updatePictureState(isEditable: isEditable, pictures: photographer.pictures).map { PhotographerSection.Item.photo($0) } ]
    }
    
    func mappingDetailDataSource(photographer: PhotographerUser) -> PhotographerDataSource {
        guard photographer.introduction != nil else {
            return [PhotographerSection.detail: []]
        }
        return [PhotographerSection.detail: [PhotographerSection.Item.detail(photographer)]]
    }
    
    func mappingReviewDataSource(review: ReviewInformation) -> [PhotographerDataSource] {
        if review.reviews.isEmpty {
            return [[PhotographerSection.review: []]]
        }
        return [ [.detail: [.summaryReview(review.summary)]] ] +
        [ [.review: review.reviews.map { PhotographerSection.Item.review($0) } ] ]
    }
}


extension PhotographerDetailViewModel {
    func blockPhotographer() -> Single<Void> {
        self.createBlockUseCase.create(blockedUserId: self.userId)
    }
}

extension PhotographerDetailViewModel: SelectReservationDateViewModelDelegate {
    
    func selectedReservationDate(startDate: Date, endDate: Date) {
        self.reservationDates.accept([startDate, endDate])
    }
}
