//
//  TrinapSingleSelectionCalendarView.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import HorizonCalendar
import RxRelay
import SnapKit

final class TrinapSingleSelectionCalendarView: BaseView {
    
    // MARK: - UI
    private lazy var calendarView = CalendarView(initialContent: configureCalendarView()).than {
        $0.backgroundColor = TrinapAsset.background.color
        $0.layer.cornerRadius = 16
    }
    
    // MARK: - Properties
    private lazy var calendar = Calendar.current
    private var selectedDate: Date?
    private var possibleDate: [Date] = []
    let selectedSingleDate = BehaviorRelay<Date?>(value: nil)
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        self.configureSelectionHandler()
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        self.addSubview(calendarView)
    }
    
    override func configureConstraints() {
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 당월 작가의 영업일을 설정하는 함수
    /// - Parameter possibleDate: 작가의 영업일
    func configurePossibleDate(possibleDate: [Date]) {
        self.possibleDate = filterPreviousDate(with: possibleDate)
        self.selectedDate = self.isCurrentDate(date: self.possibleDate.first) ? Date() : self.possibleDate.first
        
        guard let date = self.selectedDate else { return }
        
        self.selectedSingleDate.accept(date)
        self.calendarView.setContent(self.configureCalendarView())
    }
}

// MARK: - Private Functions
private extension TrinapSingleSelectionCalendarView {
    
    func configureSelectionHandler() {
        calendarView.daySelectionHandler = { [weak self] day in
            guard
                let self,
                var date = self.calendar.date(from: day.components),
                self.possibleDate.contains(where: { self.calendar.component(.day, from: $0) == day.day })
            else {
                return
            }
            
            if day.day == self.calendar.component(.day, from: Date()) {
                date = Date()
            }
            
            self.selectedDate = date
            self.selectedSingleDate.accept(date)
            self.calendarView.setContent(self.configureCalendarView())
        }
    }
    
    func configureCalendarView() -> CalendarViewContent {
        calendar.locale = Locale(identifier: "ko_KR")
        
        let (startDate, endDate) = self.calculateCurrentMonth()
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
        )
        .verticalDayMargin(trinapOffset)
        .horizontalDayMargin(trinapOffset)
        .dayItemProvider { [calendar] day in
            return self.configureDayItemProvider(day: day, calendar: calendar)
        }
        .monthHeaderItemProvider { month in
            return self.configureMonthHeaderItemProvider(month)
        }
    }
    
    private func configureDayItemProvider(day: Day, calendar: Calendar) -> CalendarItemModel<DayView> {
        var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive
        
        if self.possibleDate.contains(where: { calendar.component(.day, from: $0) == day.day }) {
            if let selectedDate = self.selectedDate,
               calendar.component(.day, from: selectedDate) == day.day {
                invariantViewProperties.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
                invariantViewProperties.textColor = TrinapAsset.white.color
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor = TrinapAsset.primary.color
            }
        } else {
            invariantViewProperties = DayView.InvariantViewProperties.baseNonInteractive
            invariantViewProperties.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
            invariantViewProperties.textColor = TrinapAsset.disabled.color
        }
        
        return DayView.calendarItemModel(
            invariantViewProperties: invariantViewProperties,
            viewModel: .init(
                dayText: "\(day.day)",
                accessibilityLabel: nil,
                accessibilityHint: nil
            )
        )
    }
    
    private func configureMonthHeaderItemProvider(_ month: Month) -> CalendarItemModel<MonthHeaderView> {
        var invariantViewProperties = MonthHeaderView.InvariantViewProperties.base
        
        let trinapDoubleOffset = self.trinapOffset * 2
        invariantViewProperties.edgeInsets = .init(
            top: trinapDoubleOffset,
            leading: trinapDoubleOffset,
            bottom: 0,
            trailing: 0
        )
        invariantViewProperties.font = TrinapFontFamily.Pretendard.bold.font(size: 20)
        
        return MonthHeaderView.calendarItemModel(
            invariantViewProperties: invariantViewProperties,
            viewModel: .init(
                monthText: "\(month.year)년 \(month.month)월",
                accessibilityLabel: nil
            )
        )
    }
    
    private func filterPreviousDate(with possibleDate: [Date]) -> [Date] {
        return possibleDate.filter { date in
            let dateComponents = self.calendar.dateComponents([.year, .month, .day], from: date)
            guard
                let year = dateComponents.year,
                let month = dateComponents.month,
                let day = dateComponents.day
            else {
                return false
            }
            return (
                self.calendar.component(.year, from: Date()) == year &&
                self.calendar.component(.month, from: Date()) == month &&
                self.calendar.component(.day, from: Date()) <= day
            )
        }
    }
    
    private func calculateCurrentMonth() -> (Date, Date) {
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        let startDate = calendar.date(from: DateComponents(year: year, month: month)) ?? Date()
        let nextMonth = calendar.date(byAdding: .month, value: +1, to: startDate) ?? Date()
        let endDate = calendar.date(byAdding: .day, value: -1, to: nextMonth) ?? Date()
        
        return (startDate, endDate)
    }
    
    private func isCurrentDate(date: Date?) -> Bool {
        guard let date = date else { return false }
        let currentDay = self.calendar.component(.day, from: Date())
        
        return self.calendar.component(.day, from: date) == currentDay
    }
}
