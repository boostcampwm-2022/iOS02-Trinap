//
//  TrinapCalendarView.swift
//  Trinap
//
//  Created by ByeongJu Yu on 2022/11/23.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

import HorizonCalendar
import SnapKit

final class TrinapCalendarView: BaseView {
    
    enum CalendarType {
        case singleSelect
        case multiSelect
    }
    // MARK: - UI
    private lazy var calendarView = CalendarView(initialContent: configureCalendarView()).than {
        $0.backgroundColor = TrinapAsset.background.color
        $0.layer.cornerRadius = 16
    }
    
    // MARK: - Properties
    private lazy var calendar = Calendar.current
    private var selectedDates: [Date] = []
    
    lazy var dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = calendar.locale
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "EEEE, MMM d, yyyy",
            options: 0,
            locale: calendar.locale ?? Locale(identifier: "ko"))
        return dateFormatter
    }()
    
    
    // MARK: - Initializers
    init(type: CalendarType) {
        super.init(frame: .zero)
        self.calendar.locale = Locale(identifier: "ko")
        switch type {
        case .singleSelect:
            self.configureSingleDaySelectionHandler()
        case.multiSelect:
            self.configureMultiDaySelectionHandler()
        }
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
    
    func configureMultiDaySelectionHandler() {
        calendarView.daySelectionHandler = { [weak self] day in
            guard
                let self,
                let day = self.calendar.date(from: day.components)
            else {
                return
            }
            
            
            if self.selectedDates.contains(day) {
                if let index = self.selectedDates.firstIndex(of: day) {
                    self.selectedDates.remove(at: index)
                }
            } else {
                self.selectedDates.append(day)
            }
            
            self.calendarView.setContent(self.configureCalendarView())
        }
    }
    
    func configureSingleDaySelectionHandler() {
        calendarView.daySelectionHandler = { [weak self] day in
            guard
                let self,
                let day = self.calendar.date(from: day.components)
            else {
                return
            }
            
            if self.selectedDates.contains(day) {
                if let index = self.selectedDates.firstIndex(of: day) {
                    self.selectedDates.remove(at: index)
                }
            } else {
                self.selectedDates = [day]
            }
            
            self.calendarView.setContent(self.configureCalendarView())
        }
    }
    
    func configureCalendarView() -> CalendarViewContent {
        let (startDate, endDate) = self.calculateCurrentMonth()
        
        let selectedDates = self.selectedDates
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
        )
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
        .dayItemProvider { [calendar, dayDateFormatter] day in
            var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive
            
            let date = calendar.date(from: day.components)
            if selectedDates.contains(date ?? Date()) {
                invariantViewProperties.font = TrinapFontFamily.Pretendard.bold.font(size: 16)
                invariantViewProperties.textColor = TrinapAsset.white.color
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor = TrinapAsset.primary.color
            }
            
            return DayView.calendarItemModel(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(
                    dayText: "\(day.day)",
                    accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
                    accessibilityHint: nil))
        }
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
    
    func getSeletedDate() -> [Date] {
        return selectedDates
    }
}
