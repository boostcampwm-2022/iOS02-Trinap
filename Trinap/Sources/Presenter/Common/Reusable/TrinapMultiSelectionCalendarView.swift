//
//  TrinapMultiSelectionCalendarView.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/27.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import HorizonCalendar
import SnapKit

final class TrinapMultiSelectionCalendarView: BaseView {
    
    // MARK: - UI
    private lazy var calendarView = CalendarView(initialContent: configureCalendarView()).than {
        $0.backgroundColor = TrinapAsset.background.color
        $0.layer.cornerRadius = 16
    }
    
    // MARK: - Properties
    private lazy var calendar = Calendar.current
    private var selectedDate: [Date] = []
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        configureSelectionHandler()
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
    
    /// 당월 작가 영업일을 설정하는 함수
    /// - Parameter possibleDate: 작가의 영업일
    func configurePossibleDate(possibleDate: [Date]) {
        self.selectedDate = filterPreviousDate(with: possibleDate)
        
        self.calendarView.setContent(self.configureCalendarView())
    }
    
    ///  선택된 작가 영업일을 반환하는 함수
    /// - Returns: 선택된 영업일
    func getSeletedDate() -> [Date] {
        return self.selectedDate
    }
}

// MARK: - Private Functions
private extension TrinapMultiSelectionCalendarView {
    
    func configureSelectionHandler() {
        calendarView.daySelectionHandler = { [weak self] day in
            guard
                let self,
                let date = self.calendar.date(from: day.components),
                day.day >= self.calendar.component(.day, from: self.calculateCurrentDate())
            else {
                return
            }
            
            if self.selectedDate.contains(date) {
                if let index = self.selectedDate.firstIndex(of: date) {
                    self.selectedDate.remove(at: index)
                }
            } else {
                self.selectedDate.append(date)
            }
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
    
    func configureDayItemProvider(day: Day, calendar: Calendar) -> CalendarItemModel<DayView> {
        var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive
        
        if day.day < calendar.component(.day, from: Date()) {
            invariantViewProperties = DayView.InvariantViewProperties.baseNonInteractive
            invariantViewProperties.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
            invariantViewProperties.textColor = TrinapAsset.disabled.color
        } else {
            if self.selectedDate.contains(where: {
                return calendar.component(.day, from: $0) == day.day
            }) {
                invariantViewProperties.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
                invariantViewProperties.textColor = TrinapAsset.white.color
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor = TrinapAsset.primary.color
            }
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
    
    func configureMonthHeaderItemProvider(_ month: Month) -> CalendarItemModel<MonthHeaderView> {
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
    
    func calculateCurrentDate() -> Date {
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
    
    func calculateCurrentMonth() -> (Date, Date) {
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        let startDate = calendar.date(from: DateComponents(year: year, month: month)) ?? Date()
        let nextMonth = calendar.date(byAdding: .month, value: +1, to: startDate) ?? Date()
        let endDate = calendar.date(byAdding: .day, value: -1, to: nextMonth) ?? Date()
        
        return (startDate, endDate)
    }
}
