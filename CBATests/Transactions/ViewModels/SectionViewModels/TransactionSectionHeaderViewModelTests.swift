//
//  TransactionSectionHeaderViewModelTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class TransactionSectionHeaderViewModelTests: XCTestCase {

    private var mockDate: Date!
    private var currentDate: Date!
    private var viewModel: TransactionSectionHeaderViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let calendar = Calendar.australia
        let dateComponents = DateComponents(calendar: calendar, year: 2021, month: 5, day: 10)
        mockDate = calendar.date(from: dateComponents)
        
        let todaysDateComponents = DateComponents(calendar: calendar, year: 2021, month: 9, day: 19)
        currentDate = calendar.date(from: todaysDateComponents)

        viewModel = TransactionSectionHeaderViewModel(date: mockDate, currentDate: currentDate)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockDate = nil
        currentDate = nil
        viewModel = nil
    }

    func testDateString() {
        XCTAssertEqual(viewModel.dateString, "10 May 2021")
    }

    func testTimelineTextForToday() {
        // Given
        currentDate = mockDate
        
        // When
        viewModel = TransactionSectionHeaderViewModel(date: mockDate, currentDate: currentDate)

        // Then
        XCTAssertEqual(viewModel.timelineText, "Today")
    }

    func testTimelineTextForLastWeek() {
        mockDate = Date().changeDaysBy(days: -7)
        viewModel = TransactionSectionHeaderViewModel(date: mockDate)
        
        XCTAssertEqual(viewModel.timelineText, "7 Days Ago")
    }

    func testTimelineTextForLastDay() {
        mockDate = Date().changeDaysBy(days: -1)
        viewModel = TransactionSectionHeaderViewModel(date: mockDate)
        
        XCTAssertEqual(viewModel.timelineText, "1 Day Ago")
    }

    func testCellAccessibilityText() {
        XCTAssertEqual(viewModel.cellAccessibilityText, "10 May 2021, 132 Days Ago")
    }
}

extension Date {
    func changeDaysBy(days : Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.australia.date(byAdding: dateComponents, to: self)!
    }
}
