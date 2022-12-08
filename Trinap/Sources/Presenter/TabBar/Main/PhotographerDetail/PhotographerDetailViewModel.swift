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
        let resevationDates: Driver<[Date]>
        let dataSource: Driver<[PhotographerDataSource]>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()

    //TODO: PhotographerUser로 반환하는 UseCase 만들어서 바로 받아오도록 변경
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchPhotographerUseCase: FetchPhotographerUseCase
    private let fetchReviewUseCase: FetchReviewUseCase
    private let createReservationUseCase: CreateReservationUseCase
    private let createBlockUseCase: CreateBlockUseCase
    private let createChatroomUseCase: CreateChatroomUseCase
    private let sendFirstChatUseCase: SendFirstChatUseCase
    private let mapRepository: MapRepository
    
    private let reloadTrigger = BehaviorSubject<Void>(value: ())
    
    private let searchCoordinate: Coordinate
    private let userId: String
    //TODO: 델리게이트로 넘어오는 값 여기에 넣기
    private var reservationDate = BehaviorRelay<[Date]>(value: [])
    
    private weak var coordiantor: MainCoordinator?
    
    // MARK: - Initializer
    init(
        fetchUserUseCase: FetchUserUseCase,
        fetchPhotographerUseCase: FetchPhotographerUseCase,
        fetchReviewUseCase: FetchReviewUseCase,
        createReservationUseCase: CreateReservationUseCase,
        createBlockUseCase: CreateBlockUseCase,
        createChatroomUseCase: CreateChatroomUseCase,
        sendFirstChatUseCase: SendFirstChatUseCase,
        mapRepository: MapRepository,
        userId: String,
        searchCoordinate: Coordinate,
        coordinator: MainCoordinator?
    ) {
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchPhotographerUseCase = fetchPhotographerUseCase
        self.fetchReviewUseCase = fetchReviewUseCase
        self.createReservationUseCase = createReservationUseCase
        self.createBlockUseCase = createBlockUseCase
        self.mapRepository = mapRepository
        self.createChatroomUseCase = createChatroomUseCase
        self.sendFirstChatUseCase = sendFirstChatUseCase
        self.coordiantor = coordinator
        self.searchCoordinate = searchCoordinate
        self.userId = userId
    }

    // MARK: - Initializer

    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .map { _ in }
            .bind(to: reloadTrigger)
            .disposed(by: disposeBag)
        
        let photographer = self.reloadTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchPhotographer()
            }
            .share()
        
        let reviewInformation = Observable.combineLatest(reloadTrigger, photographer)
            .withUnretained(self)
            .flatMap { owner, value in
                return owner.fetchReviews(photographerId: value.1.photographerId)
            }
            .share()
        
        let buttonAvailable = self.reservationDate
            .map { date -> Bool in
                return date.count == 2
            }
        
        // 1. 얼럿 띄워주기
        // 2. 얼럿에서 false 나오면 종료. true 나오면 계속.
        // 3. reservation만들어주기
        // 4. 채팅방 만들기
        // 5. 채팅 보내기
        // 6. 채팅방으로 이동하는 coordinator 함수 실행
        // TODO: chatroom 중복되는 부분 있으면 만들지 않고 해당 chatroomId만 반환하도록 createChatroomUseCase 수정
        // TODO: 채팅방으로 이동하는 coordinator 함수 만들어서 연결
        input.confirmTrigger
            .withUnretained(self)
            .flatMap { $0.0.showAlert() }
            .filter { $0 }
            .distinctUntilChanged()
            .withLatestFrom(reservationDate.asObservable())
            .withUnretained(self)
            .flatMap { owner, dates -> Observable<String> in
                Logger.print(111)
                guard
                    let start = dates[safe: 0],
                    let end = dates[safe: 1]
                else { return Observable.just("") }
                
                return owner.createReservationUseCase.create(
                    photographerUserId: owner.userId,
                    startDate: start,
                    endDate: end,
                    coordinate: owner.searchCoordinate
                )
            }
            .withUnretained(self)
            .flatMap { owner, reservationId -> Observable<(String, String)> in
                Logger.print(222)
                return owner.createChatroomUseCase.create(photographerUserId: owner.userId)
                    .map { ($0, reservationId) }
            }
            .withUnretained(self)
            .flatMap { owner, value in
                Logger.print(333)
                let (chatroomId, reservationId) = value
                return owner.sendFirstChatUseCase
                    .send(chatroomId: chatroomId, reservationId: reservationId)
                    .map { _ in return chatroomId }
            }
            .subscribe(onNext: { [weak self] chatroomId in
                self?.coordiantor?.connectChatDetailCoordinator(chatroomId: chatroomId, nickname: "이게 된다고?")
            })
            .disposed(by: disposeBag)
        
//        //TODO: 같은 일자면 못 보내도록 서버에서 받아와서 확인하고 처리
//        Observable
//            .combineLatest(input.confirmTrigger, self.reservationDate.asObservable())
//            .map { _, dates -> [Date] in
//                dates
//            }
//        //어떤 값 누르는지에 따라 바뀌게
//            .flatMap { dates in
//                showAlert(), dates
//            }
//            .filter { $0 }
//            .distinctUntilChanged()
//            .withUnretained(self)
//            .flatMap { owner, dates -> Observable<Void> in
//                guard
//                    let start = dates[safe: 0],
//                    let end = dates[safe: 1]
//                else { return Observable.just(()) }
//
//                return owner.createReservationUseCase.create(
//                    photographerUserId: owner.userId,
//                    startDate: start,
//                    endDate: end,
//                    coordinate: owner.searchCoordinate
//                )
//            }
////            .do(onNext: { self.showAlert()})
//            //TODO: 채팅 전달
//            .subscribe()
//            .disposed(by: disposeBag)
                
        Observable.combineLatest(input.calendarTrigger, photographer)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                let photographerUser = value.1
//                owner.coordiantor?.showSelectReservationDateViewController(with: photographerUser.possibleDate, detailViewModel: self)
                owner.coordiantor?.showSelectReservationDateViewController(with: [Date()], detailViewModel: self)
            })
            .disposed(by: disposeBag)
        
        let dataSource = Observable.combineLatest(input.tabState, photographer, reviewInformation)
            .map { [weak self] section, photographer, review -> [PhotographerDataSource] in
                guard let self else { return [] }
                
                return self.mappingDataSource(isEditable: false, state: section, photographer: photographer, review: review)
            }
        
        let reservationDates = self.reservationDate.asDriver(onErrorJustReturn: [])
            

        return Output(
            confirmButtonEnabled: buttonAvailable.asDriver(onErrorJustReturn: false),
            resevationDates: reservationDates,
            dataSource: dataSource.asDriver(onErrorJustReturn: [])
        )
    }
    
    private func showAlert() -> Observable<Bool> {
        return Observable.create { [weak self] observable in
            guard
                let dates = self?.reservationDate.value,
                let startDate = dates[safe: 0],
                let endDate = dates[safe: 1]
            else {
                observable.onNext(false)
                return Disposables.create()
            }
            
            let alert = TrinapAlert(
                title: "예약을 확인해주세요",
                timeText: self?.formattingCalendarButtonText(
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
            alert.showAlert(navigationController: self?.coordiantor?.navigationController)
            return Disposables.create()
        }
    }
}


extension PhotographerDetailViewModel {
    
    private func fetchPhotographer() -> Observable<PhotographerUser> {
        return self.fetchUserUseCase.fetchUserInfo(userId: userId)
            .flatMap { user in
                self.fetchPhotographerUseCase.fetch(photographerUserId: user.userId)
                    .flatMap { photographer in
                        return self.mapRepository.fetchLocationName(
                            using: Coordinate(lat: photographer.latitude, lng: photographer.latitude)
                        )
                        .map { location in
                            var photographer = PhotographerUser(user: user, photographer: photographer, location: location)
                            photographer.pictures.removeFirst()
                            return photographer
                        }
                    }
            }
    }
    
    private func fetchReviews(photographerId: String) -> Observable<ReviewInformation> {
        let summary = self.fetchReviewUseCase.fetchAverageReview(photographerUserId: userId)
        let reviews = self.fetchReviewUseCase.fetchReviews(photographerUserId: userId)
        return Observable.zip(summary, reviews)
            .map { summary, reviews in
                Logger.print(summary)
                Logger.printArray(reviews)
                guard !summary.rating.isNaN
                else {
                    return ReviewInformation(
                        summary: ReviewSummary(
                            rating: 0.0,
                            count: summary.count
                        ),
                        reviews: reviews
                    )
                }
                return ReviewInformation(summary: summary, reviews: reviews)
            }
    }
    
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
extension PhotographerDetailViewModel {
    
    private func mappingProfileDataSource(photographer: PhotographerUser) -> PhotographerDataSource {
        return [PhotographerSection.profile: [PhotographerSection.Item.profile(photographer)]]
    }
    
    private func mappingPictureDataSource(isEditable: Bool, photographer: PhotographerUser) -> PhotographerDataSource {
        return [PhotographerSection.photo: updatePictureState(isEditable: isEditable, pictures: photographer.pictures).map { PhotographerSection.Item.photo($0) } ]
    }
    
    private func mappingDetailDataSource(photographer: PhotographerUser) -> PhotographerDataSource {
        return [PhotographerSection.detail: [PhotographerSection.Item.detail(photographer)]]
    }
    
    private func mappingReviewDataSource(review: ReviewInformation) -> [PhotographerDataSource] {
        return [ [.detail: [.summaryReview(review.summary)]] ] +
            [ [.review: review.reviews.map { PhotographerSection.Item.review($0) } ] ]
    }
}

extension PhotographerDetailViewModel: SelectReservationDateViewModelDelegate {
    
    func selectedReservationDate(startDate: Date, endDate: Date) {
        self.reservationDate.accept([startDate, endDate])
    }
}

// MARK: 차단, 신고 관련 메소드
extension PhotographerDetailViewModel {
    func blockPhotographer() -> Single<Void> {
        self.createBlockUseCase.create(blockedUserId: self.userId)
    }
    
    func reportPhotographer() {
        
    }
}


extension PhotographerDetailViewModel {
    private func formattingCalendarButtonText(startDate: Date, endDate: Date) -> String? {
        let startSeperated = startDate.toString(type: .yearToSecond).components(separatedBy: " ")
        let endSeperated = endDate.toString(type: .yearToSecond).components(separatedBy: " ")
        
        guard let date = startSeperated[safe: 0] else { return nil }
        let dateSeperated = date.components(separatedBy: "-")
        guard
            let month = dateSeperated[safe: 1],
            let day = dateSeperated[safe: 2]
        else { return nil }
        
        guard
            let startTime = startSeperated.last,
            let endTime = endSeperated.last
        else { return nil }
        let startHourToSec = startTime.components(separatedBy: ":")
        let endHourToSec = endTime.components(separatedBy: ":")
        guard
            let startHour = startHourToSec[safe: 0],
            let startMin = startHourToSec[safe: 1],
            let endHour = endHourToSec[safe: 0],
            let endMin = endHourToSec[safe: 1]
        else { return nil }

        let reservationDate = "\(month)/\(day)"
        let reservationStart = "\(startHour):\(startMin)"
        let reservationEnd = "\(endHour):\(endMin)"
        let dateInfo = "\(reservationDate) \(reservationStart)-\(reservationEnd)\n"
        return dateInfo
    }

}
